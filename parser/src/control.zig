const Closure = @import("core").data.Closure;
const Predicate = @import("core").data.Predicate;
const Source = @import("source").Source;
const Parser = @import("parsec.zig").Parser;
const Result = @import("data/result.zig").Result;
const Any = @import("basic.zig").Any;

fn Satisfy(comptime I: type, comptime O: type) type {
    return struct {
        const Self = @This();

        inner: Parser(I, O),
        predicate: Predicate(O),

        pub fn parser(self: *const Self) Parser(I, O) {
            return Parser(I, O).from(self);
        }

        pub fn init(inner: Parser(I, O), predicate: Predicate(O)) Self {
            return Self{ .inner = inner, .predicate = predicate };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, O) {
            return switch (self.inner.run(source)) {
                .Success => |s| {
                    return if (self.predicate.apply(s.value))
                        Result(I, O).success(s.value, s.consumed, s.source)
                    else
                        Result(I, O).failure(null, false, source);
                },
                .Failure => |f| Result(I, O).failure(f.reason, false, source),
            };
        }
    };
}


fn Map(comptime I: type, comptime A: type, comptime B: type) type {
    return struct {
        const Self = @This();

        inner: Parser(I, A),
        mapper: Closure(A, B),

        pub fn parser(self: *const Self) Parser(I, B) {
            return Parser(I, B).from(self);
        }

        pub fn init(inner: Parser(I, A), mapper: Closure(A, B)) Self {
            return Self{ .inner = inner, .mapper = mapper };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, B) {
            return switch (self.inner.run(source)) {
                .Success => |s| Result(I, B).success(self.mapper.apply(s.value), s.consumed, s.source),
                .Failure => |f| Result(I, B).failure(f.reason, f.consumed, f.source),
            };
        }
    };
}


fn Bind(comptime I: type, comptime A: type, comptime B: type) type {
    return struct {
        const Self = @This();

        inner: Parser(I, A),
        binder: Closure(A, Parser(I, B)),

        pub fn parser(self: *const Self) Parser(I, B) {
            return Parser(I, B).from(self);
        }

        pub fn init(inner: Parser(I, A), binder: Closure(A, Parser(I, B))) Self {
            return Self{ .inner = inner, .binder = binder };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, B) {
            return switch (self.inner.run(source)) {
                .Success => |s1| switch (self.binder.apply(s1.value).run(s1.source)) {
                    .Success => |s2| Result(I, B).success(s2.value, s1.consumed or s2.consumed, s2.source),
                    .Failure => |f| Result(I, B).failure(f.reason, s1.consumed or f.consumed, f.source),
                },
                .Failure => |f| Result(I, B).failure(f.reason, f.consumed, f.source),
            };
        }
    };
}

pub inline fn satisfy(comptime I: type, comptime O: type) fn (Parser(I, O), Predicate(O)) Parser(I, O) {
    return struct {
        fn init(inner: Parser(I, O), predicate: Predicate(O)) Parser(I, O) {
            return Satisfy(I, O).init(inner, predicate).parser();
        }
    }.init;
}

pub inline fn map(comptime I: type, comptime A: type, comptime B: type) fn (Parser(I, A), Closure(A, B)) Parser(I, B) {
    return struct {
        fn init(inner: Parser(I, A), mapper: Closure(A, B)) Parser(I, B) {
            return Map(I, A, B).init(inner, mapper).parser();
        }
    }.init;
}

pub inline fn bind(comptime I: type, comptime A: type, comptime B: type) fn (Parser(I, A), Closure(A, Parser(I, B))) Parser(I, B) {
    return struct {
        fn init(inner: Parser(I, A), mapper: Closure(A, Parser(I, B))) Parser(I, B) {
            return Bind(I, A, B).init(inner, mapper).parser();
        }
    }.init;
}
