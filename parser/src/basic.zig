const std = @import("std");
const Unit = @import("core").data.Unit;
const Source = @import("source").Source;
const Parser = @import("parsec.zig").Parser;
const Result = @import("data/result.zig").Result;

fn Return(comptime I: type, comptime O: type) type {
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

fn Failure(comptime I: type, comptime O: type) type {
    return struct {
        const Self = @This();

        reason: ?[]const u8,

        pub fn parser(self: *const Self) Parser(I, O) {
            return Parser(I, O).from(self);
        }

        pub fn init(reason: ?[]const u8) Self {
            return Self{ .reason = reason };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, O) {
            return Result(I, O).failure(self.reason, false, source);
        }
    };
}

fn Any(comptime I: type) type {
    return struct {
        const Self = @This();

        pub fn parser(self: *const Self) Parser(I, I) {
            return Parser(I, I).from(self);
        }

        pub const init: Self = Self{};

        pub fn run(_: Self, source: Source(I)) Result(I, I) {
            const result = source.next();

            return if (result.fst()) |v|
                Result(I, I).success(v, true, result.snd())
            else
                Result(I, I).failure(
                    "Empty source while waiting for an element",
                    false,
                    result.snd(),
                );
        }
    };
}

fn Element(comptime I: type) type {
    return struct {
        const Self = @This();

        element: I,

        pub fn parser(self: *const Self) Parser(I, I) {
            return Parser(I, I).from(self);
        }

        pub fn init(value: I) Self {
            return Self{ .element = value };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, I) {
            const result = source.next();

            return if (result.fst()) |v|
                if (std.meta.eql(v, self.element))
                    Result(I, I).success(v, true, result.snd())
                else
                    Result(I, I).failure(
                        self.comparisonError(v),
                        false,
                        result.snd(),
                    )
            else
                Result(I, I).failure(
                    "Empty source while waiting for an element",
                    false,
                    result.snd(),
                );
        }

        pub fn comparisonError(self: Self, v: I) []const u8 {
            const common = "Element comparison fails";

            var buf: [1024]u8 = undefined;
            return std.fmt.bufPrint(
                &buf,
                "{s}: expecting {any}, found {any}",
                .{ common, self.element, v },
            ) catch common;
        }
    };
}

fn Eos(comptime I: type) type {
    return struct {
        const Self = @This();

        pub fn parser(self: *const Self) Parser(I, Unit) {
            return Parser(I, Unit).from(self);
        }

        pub const init: Self = Self{};

        pub fn run(_: Self, source: Source(I)) Result(I, Unit) {
            const result = source.next();

            if (result.fst() != null)
                return Result(I, Unit).failure(
                    "Waiting for an empty source",
                    true,
                    source,
                )
            else
                return Result(I, Unit).success(
                    Unit.unit(),
                    false,
                    result.snd(),
                );
        }
    };
}

/// Public section
pub inline fn returns(comptime I: type, comptime O: type) fn (O) Parser(I, O) {
    return struct {
        fn init(value: O) Parser(I, O) {
            return Return(I, O).init(value).parser();
        }
    }.init;
}

pub inline fn failure(comptime I: type, comptime O: type) fn (?[]const u8) Parser(I, O) {
    return struct {
        fn init(message: ?[]const u8) Parser(I, O) {
            return Failure(I, O).init(message).parser();
        }
    }.init;
}

pub inline fn any(comptime I: type) Parser(I, I) {
    return Any(I).init.parser();
}

pub inline fn element(comptime I: type) fn (I) Parser(I, I) {
    return struct {
        fn init(value: I) Parser(I, I) {
            return Element(I).init(value).parser();
        }
    }.init;
}

pub inline fn eos(comptime I: type) Parser(I, Unit) {
    return Eos(I).init.parser();
}
