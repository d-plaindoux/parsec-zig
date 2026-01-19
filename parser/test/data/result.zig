const expect = @import("std").testing.expectEqualDeep;
const ArraySource = @import("source").ArraySource;
const Result = @import("parser").data.Result;

test "should match a success" {
    // Given
    const result = Result(u8, u8).success('1', true, ArraySource(u8).init("").source());

    // When
    const isSuccess = switch (result) {
        .Success => true,
        .Failure => false,
    };

    // Then
    try expect(true, isSuccess);
}

test "should match a success value" {
    // Given
    const result = Result(u8, u8).success('1', true, ArraySource(u8).init("").source());

    // When
    const value = switch (result) {
        .Success => |s| s.value,
        .Failure => null,
    };

    // Then
    try expect('1', value);
}

test "should match a success consumed" {
    // Given
    const result = Result(u8, u8).success('1', true, ArraySource(u8).init("").source());

    // When
    const value = switch (result) {
        .Success => true,
        .Failure => false,
    };

    // Then
    try expect(true, value);
}

test "should match a failure" {
    // Given
    const result = Result(u8, u8).failure(null, true, ArraySource(u8).init("").source());

    // When
    const isSuccess = switch (result) {
        .Success => false,
        .Failure => true,
    };

    // Then
    try expect(true, isSuccess);
}

test "should match a failure consumed" {
    // Given
    const result = Result(u8, u8).failure(null, true, ArraySource(u8).init("").source());

    // When
    const value = switch (result) {
        .Success => false,
        .Failure => true,
    };

    // Then
    try expect(true, value);
}
