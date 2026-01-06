const Source = @import("source").Source;
const Parser = @import("parsec.zig").Parser;
const Result = @import("data/result.zig").Result;

pub fn Return(comptime I: type, comptime O: type) type {
    return struct {
        value: O,

        const Self = @This();

        pub fn parser(self: *const Self) Parser(I, O) {
            return Parser(I, O).from(self);
        }

        pub fn init(value: O) Return(I, O) {
            return .{ .value = value };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, O) {
            return Result(I, O).success(self.value, false, source);
        }
    };
}

pub fn Failure(comptime I: type, comptime O: type) type {
    return struct {
        reason: ?[]const u8,

        const Self = @This();

        pub fn parser(self: *const Self) Parser(I, O) {
            return Parser(I, O).from(self);
        }

        pub fn init(reason: ?[]const u8) Failure(I, O) {
            return .{ .reason = reason };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, O) {
            return Result(I, O).failure(self.reason, false, source);
        }
    };
}
