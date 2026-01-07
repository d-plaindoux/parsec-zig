const expect = @import("std").testing.expectEqualDeep;
const Unit = @import("core").data.Unit;
const ArraySource = @import("source").ArraySource;
const spec = @import("parser").spec;
const basic = @import("parser").basic;
const control = @import("parser").control;

fn check(l: u8) fn (u8) bool {
    return struct {
        fn eq(r: u8) bool {
            return l == r;
        }
    }.eq;
}

test "should parse and check" {
    // Given
    const source = ArraySource(u8).init("h", 0).source();
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

test "should parse and check consume" {
    // Given
    const source = ArraySource(u8).init("h", 0).source();
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
    const source = ArraySource(u8).init("h", 0).source();
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
    const source = ArraySource(u8).init("h", 0).source();
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

fn sameOne(a: u8) spec.Parser(u8, u8) {
    return control.Satisfy(u8, u8).init(basic.Any(u8).init.parser(), check(a)).parser();
}

test "should parse and bind consume" {
    // Given
    const source = ArraySource(u8).init("hh", 0).source();
    const inner = basic.Any(u8).init.parser();
    const parser = control.Bind(u8, u8, u8).init(inner, sameOne).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect(null, result);
    try expect(null, result);
}

