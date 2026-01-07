const Pair = @import("core").data.Pair;
const Source = @import("source").Source;
const Parser = @import("parsec.zig").Parser;
const Result = @import("data/result.zig").Result;

pub fn And(comptime I: type, comptime A: type, comptime B: type) type {
    return struct {
        const Self = @This();

        lhd: Parser(I, A),
        rhd: Parser(I, B),

        pub fn parser(self: *const Self) Parser(I, Pair(A, B)) {
            return Parser(I, Pair(A, B)).from(self);
        }

        pub fn init(lhd: Parser(I, A), rhd: Parser(I, B)) Self {
            return .{ .lhd = lhd, .rhd = rhd };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, Pair(A, B)) {
            return switch (self.lhd.run(source)) {
                .Success => |s1| {
                    return switch (self.rhd.run(s1.source)) {
                        .Success => |s2| Result(I, Pair(A, B)).success(Pair(A, B).init(s1.value, s2.value), s1.consumed or s2.consumed, s2.source),
                        .Failure => |f| Result(I, Pair(A, B)).failure(f.reason, s1.consumed or f.consumed, f.source),
                    };
                },
                .Failure => |f| Result(I, Pair(A, B)).failure(f.reason, f.consumed, f.source),
            };
        }
    };
}

pub fn Or(comptime I: type, comptime O: type) type {
    return struct {
        const Self = @This();

        lhd: Parser(I, O),
        rhd: Parser(I, O),

        pub fn parser(self: *const Self) Parser(I, O) {
            return Parser(I, O).from(self);
        }

        pub fn init(lhd: Parser(I, O), rhd: Parser(I, O)) Self {
            return .{ .lhd = lhd, .rhd = rhd };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, O) {
            return switch (self.lhd.run(source)) {
                .Success => |s| Result(I, O).success(s.value, s.consumed, s.source),
                .Failure => self.rhd.run(source),
            };
        }
    };
}
