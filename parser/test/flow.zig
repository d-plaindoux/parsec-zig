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
    const inner = basic.Any(u8).init.parser();
    const parser = flow.And(u8, u8, u8).init(inner, inner).parser();

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
    const lhd = basic.Element(u8).init('h').parser();
    const rhd = basic.Element(u8).init('e').parser();
    const parser = flow.Or(u8, u8).init(lhd, rhd).parser();

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
    const lhd = basic.Element(u8).init('e').parser();
    const rhd = basic.Element(u8).init('h').parser();
    const parser = flow.Or(u8, u8).init(lhd, rhd).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect('h', result);
}
