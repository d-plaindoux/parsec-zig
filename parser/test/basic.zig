const expect = @import("std").testing.expectEqualDeep;
const ArraySource = @import("source").ArraySource;
const basic = @import("parser").basic;

test "should returns a value" {
    // Given
    const source = ArraySource(u8).init("", 0).source();
    const parser = basic.Return(u8, u8).init(42).parser();

    // When
    const isSuccess = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect(42, isSuccess);
}


test "should returns an error" {
    // Given
    const source = ArraySource(u8).init("", 0).source();
    const parser = basic.Failure(u8, u8).init("error").parser();

    // When
    const isSuccess = switch (parser.run(source)) {
        .Success => null,
        .Failure => |v| v.reason,
    };

    // Then
    try expect("error", isSuccess);
}
