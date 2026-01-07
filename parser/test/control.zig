const expect = @import("std").testing.expectEqualDeep;
const Unit = @import("core").data.Unit;
const ArraySource = @import("source").ArraySource;
const spec = @import("parser").spec;
const basic = @import("parser").basic;
const control = @import("parser").control;

const Self = @This();

fn check(a: u8) bool {
    return a == 'h';
}

test "should parse and check" {
    // Given
    const source = ArraySource(u8).init("h", 0).source();
    const inner = basic.Any(u8).init.parser();
    const parser = control.Satisfy(u8, u8).init(inner, Self.check).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect('h', result);
}

test "should parse and check consume" {
    // Given
    const source = ArraySource(u8).init("h", 0).source();
    const inner = basic.Any(u8).init.parser();
    const parser = control.Satisfy(u8, u8).init(inner, Self.check).parser();

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
    const source = ArraySource(u8).init("h", 0).source();
    const inner = basic.Any(u8).init.parser();
    const parser = control.Map(u8, u8, bool).init(inner, Self.check).parser();

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
    const source = ArraySource(u8).init("h", 0).source();
    const inner = basic.Any(u8).init.parser();
    const parser = control.Map(u8, u8, bool).init(inner, Self.check).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.consumed,
        .Failure => null,
    };

    // Then
    try expect(true, result);
}
