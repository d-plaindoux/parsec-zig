const expect = @import("std").testing.expectEqualDeep;
const Pair = @import("core").data.Pair;
const Predicate = @import("core").data.Predicate;
const ArraySource = @import("source").ArraySource;
const spec = @import("parser").spec;
const basic = @import("parser").basic;
const control = @import("parser").control;
const flow = @import("parser").flow;
const check = @import("utils/check.zig").check;

test "should parse two characters" {
    // Given
    const source = ArraySource(u8).init("he").source();
    const inner = basic.any(u8);
    const parser = flow.then(u8, u8, u8)(inner, inner);

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect(Pair(u8, u8).init('h', 'e'), result);
}

test "should parse one character with left selector" {
    // Given
    const source = ArraySource(u8).init("h").source();
    const lhd = basic.element(u8)('h');
    const rhd = basic.element(u8)('e');
    const parser = flow.choice(u8, u8)(lhd, rhd);

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect('h', result);
}

test "should parse one character with right selector" {
    // Given
    const source = ArraySource(u8).init("h").source();
    const lhd = basic.element(u8)('e');
    const rhd = basic.element(u8)('h');
    const parser = flow.choice(u8, u8)(lhd, rhd);

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect('h', result);
}
