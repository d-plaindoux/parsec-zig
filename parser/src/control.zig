const Source = @import("source").Source;
const Parser = @import("parsec.zig").Parser;
const Result = @import("data/result.zig").Result;
const Any = @import("basic.zig").Any;

pub fn Satisfy(comptime I: type, comptime O: type) type {
    return struct {
        const Self = @This();

        inner: Parser(I, O),
        predicate: *const fn (O) bool,

        pub fn parser(self: *const Self) Parser(I, O) {
            return Parser(I, O).from(self);
        }

        pub fn init(inner: Parser(I, O), predicate: *const fn (O) bool) Self {
            return .{ .inner = inner, .predicate = predicate };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, O) {
            return switch (self.inner.run(source)) {
                .Success => |s| {
                    return if (self.predicate(s.value))
                        Result(I, O).success(s.value, s.consumed, s.source)
                    else
                        Result(I, O).failure(null, false, source);
                },
                .Failure => |f| Result(I, O).failure(f.reason, false, source),
            };
        }
    };
}

pub fn Map(comptime I: type, comptime A: type, comptime B: type) type {
    return struct {
        const Self = @This();

        inner: Parser(I, A),
        mapper: *const fn (A) B,

        pub fn parser(self: *const Self) Parser(I, B) {
            return Parser(I, B).from(self);
        }

        pub fn init(inner: Parser(I, A), mapper: *const fn (A) B) Self {
            return .{ .inner = inner, .mapper = mapper };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, B) {
            return switch (self.inner.run(source)) {
                .Success => |s| Result(I, B).success(self.mapper(s.value), s.consumed, s.source),
                .Failure => |f| Result(I, B).failure(f.reason, f.consumed, f.source),
            };
        }
    };
}

pub fn Bind(comptime I: type, comptime A: type, comptime B: type) type {
    return struct {
        const Self = @This();

        inner: Parser(I, A),
        binder: *const fn (A) Parser(I, B),

        pub fn parser(self: *const Self) Parser(I, B) {
            return Parser(I, B).from(self);
        }

        pub fn init(inner: Parser(I, A), binder: *const fn (A) Parser(I, B)) Self {
            return .{ .inner = inner, .binder = binder };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, B) {
            return switch (self.inner.run(source)) {
                .Success => |s1| {
                    switch (self.binder(s1.value).run(s1.source)) {
                        .Success => |s2| Result(I, B).success(s2.value, s1.consumed or s2.consumed, s2.source),
                        .Failure => |f| Result(I, B).failure(f.reason, s1.consumed or f.consumed, f.source),
                    }
                },
                .Failure => |f| Result(I, B).failure(f.reason, f.consumed, f.source),
            };
        }
    };
}
