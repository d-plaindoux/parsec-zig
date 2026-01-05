const Source = @import("source").Source;

fn Result(I: type, O: type) type {
    return union(enum) {
        Success: struct { value: O, consumed: bool, source: Source(I) },
        Failure: struct { consumed: bool, source: Source(I) },

        fn success(value: O, consumed: bool, source: Source(I)) @This() {
            return .{ .Success = .{ .value = value, .consumed = consumed, .source = source } };
        }

        fn failure(consumed: bool, source: Source(I)) @This() {
            return .{ .Failure = .{ .consumed = consumed, .source = source } };
        }
    };
}

test "should match a success" {
    const expect = @import("std").testing.expectEqualDeep;
    const ArraySource = @import("array_source.zig").ArraySource;

    // Given
    const success = Result(u8, u8).success('1', true, ArraySource(u8).init("", 0).source());

    // When
    const isSuccess = switch (success) {
        .Success => true,
        .Failure => false,
    };

    // Then
    try expect(true, isSuccess);
}

test "should match a failure" {
    const expect = @import("std").testing.expectEqualDeep;
    const ArraySource = @import("array_source.zig").ArraySource;

    // Given
    const success = Result(u8, u8).failure(true, ArraySource(u8).init("", 0).source());

    // When
    const isSuccess = switch (success) {
        .Success => false,
        .Failure => true,
    };

    // Then
    try expect(true, isSuccess);
}
