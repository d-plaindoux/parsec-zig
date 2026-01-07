const Source = @import("source").Source;
const Parser = @import("parsec.zig").Parser;
const Result = @import("data/result.zig").Result;
const Any = @import("basic.zig").Any;

pub fn Map(comptime I: type, comptime O: type) type {
    return struct {
        const Self = @This();

        mapper: *const fn (I) O,

        pub fn parser(self: *const Self) Parser(I, O) {
            return Parser(I, O).from(self);
        }

        pub fn init(mapper: *const fn (I) O) Self {
            return .{ .mapper = mapper };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, O) {
            return switch (Any(I).init.parser().run(source)) {
                .Success => |s| Result(I, O).success(self.mapper(s.value), s.consumed, s.source),
                .Failure => |f| Result(I, O).failure(f.reason, f.consumed, f.source),
            };
        }
    };
}
