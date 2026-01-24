const expect = @import("std").testing.expectEqualDeep;
const Unit = @import("core").data.Unit;
const Closure = @import("core").data.Closure;
const Predicate = @import("core").data.Predicate;
const Source = @import("source").Source;
const ArraySource = @import("source").ArraySource;
const spec = @import("parser").spec;
const basic = @import("parser").basic;
const control = @import("parser").control;
const Result = @import("data/result.zig").Result;
const check = @import("utils/check.zig").check;

test "should parse and satisfy" {
    // Given
    const source = ArraySource(u8).init("h").source();
    const inner = basic.Any(u8).init.parser();
    const parser = control.Satisfy(u8, u8).init(inner, check('h')).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect('h', result);
}

test "should parse and satisfy consume" {
    // Given
    const source = ArraySource(u8).init("h").source();
    const inner = basic.Any(u8).init.parser();
    const parser = control.Satisfy(u8, u8).init(inner, check('h')).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.consumed,
        .Failure => null,
    };

    // Then
    try expect(true, result);
}

test "should parse and map" {
    // Given
    const source = ArraySource(u8).init("h").source();
    const inner = basic.Any(u8).init.parser();
    const parser = control.Map(u8, u8, bool).init(inner, check('h')).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect(true, result);
}

test "should parse and map consume" {
    // Given
    const source = ArraySource(u8).init("h").source();
    const inner = basic.Any(u8).init.parser();
    const parser = control.Map(u8, u8, bool).init(inner, check('h')).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.consumed,
        .Failure => null,
    };

    // Then
    try expect(true, result);
}

pub const Binder = struct {
    const Self = @This();

    pub fn closure(self: *const Self) Closure(u8, spec.Parser(u8, u8)) {
        return Closure(u8, spec.Parser(u8, u8)).from(self);
    }

    pub const init: Self = Self{};

    pub fn apply(_: Self, value: u8) spec.Parser(u8, u8) {
        return basic.Element(u8).init(value).parser();
    }
};

const sameOne = Binder.init.closure();

test "should parse with binded function" {
    // Given
    const source = ArraySource(u8).init("h").source();
    const parser = sameOne.apply('h');

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect('h', result);
}

test "should parse and bind consume" {
    // Given
    const source = ArraySource(u8).init("hh").source();
    const inner = basic.Any(u8).init.parser();
    const parser = control.Bind(u8, u8, u8).init(inner, sameOne).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect('h', result);
}
