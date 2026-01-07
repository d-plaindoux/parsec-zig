const Unit = @import("core").data.Unit;
const Source = @import("source").Source;
const Parser = @import("parsec.zig").Parser;
const Result = @import("data/result.zig").Result;

pub fn Return(comptime I: type, comptime O: type) type {
    return struct {
        const Self = @This();

        value: O,

        pub fn parser(self: *const Self) Parser(I, O) {
            return Parser(I, O).from(self);
        }

        pub fn init(value: O) Self {
            return .{ .value = value };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, O) {
            return Result(I, O).success(self.value, false, source);
        }
    };
}

pub fn Failure(comptime I: type, comptime O: type) type {
    return struct {
        const Self = @This();

        reason: ?[]const u8,

        pub fn parser(self: *const Self) Parser(I, O) {
            return Parser(I, O).from(self);
        }

        pub fn init(reason: ?[]const u8) Self {
            return .{ .reason = reason };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, O) {
            return Result(I, O).failure(self.reason, false, source);
        }
    };
}

pub fn Any(comptime I: type) type {
    return struct {
        const Self = @This();

        pub fn parser(self: *const Self) Parser(I, I) {
            return Parser(I, I).from(self);
        }

        pub const init: Self = .{};

        pub fn run(_: Self, source: Source(I)) Result(I, I) {
            const result = source.next();

            if (result.fst()) |v| {
                return Result(I, I).success(v, true, result.snd());
            } else {
                return Result(I, I).failure(null, false, result.snd());
            }
        }
    };
}

pub fn Eos(comptime I: type) type {
    return struct {
        const Self = @This();

        pub fn parser(self: *const Self) Parser(I, Unit) {
            return Parser(I, Unit).from(self);
        }

        pub const init: Self = .{};

        pub fn run(_: Self, source: Source(I)) Result(I, Unit) {
            const result = source.next();

            if (result.fst() != null) {
                return Result(I, Unit).failure("Waiting for an empty source", true, source);
            } else {
                return Result(I, Unit).success(Unit.unit(), false, result.snd());
            }
        }
    };
}
