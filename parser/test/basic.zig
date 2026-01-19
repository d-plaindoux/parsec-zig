const expect = @import("std").testing.expectEqualDeep;
const ArraySource = @import("source").ArraySource;
const basic = @import("parser").basic;

test "should returns a value" {
    // Given
    const source = ArraySource(u8).init("").source();
    const parser = basic.Return(u8, u8).init(42).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect(42, result);
}

test "should returns an error" {
    // Given
    const source = ArraySource(u8).init("").source();
    const parser = basic.Failure(u8, u8).init("error").parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => null,
        .Failure => |v| v.reason,
    };

    // Then
    try expect("error", result);
}

test "should parse one character" {
    // Given
    const source = ArraySource(u8).init("hello").source();
    const parser = basic.Any(u8).init.parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect('h', result);
}

test "should parse and consume one character" {
    // Given
    const source = ArraySource(u8).init("hello").source();
    const parser = basic.Any(u8).init.parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.consumed,
        .Failure => null,
    };

    // Then
    try expect(true, result);
}

test "should parse one specific character" {
    // Given
    const source = ArraySource(u8).init("hello").source();
    const parser = basic.Element(u8).init('h').parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect('h', result);
}

test "should parse and consume one specific character" {
    // Given
    const source = ArraySource(u8).init("hello").source();
    const parser = basic.Element(u8).init('h').parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.consumed,
        .Failure => null,
    };

    // Then
    try expect(true, result);
}

test "should not parse one character" {
    // Given
    const source = ArraySource(u8).init("").source();
    const parser = basic.Any(u8).init.parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => null,
        .Failure => true,
    };

    // Then
    try expect(true, result);
}

test "should parse empty source" {
    // Given
    const source = ArraySource(u8).init("").source();
    const parser = basic.Eos(u8).init.parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => true,
        .Failure => null,
    };

    // Then
    try expect(true, result);
}
