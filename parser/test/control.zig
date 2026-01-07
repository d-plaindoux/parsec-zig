const expect = @import("std").testing.expectEqualDeep;
const ArraySource = @import("source").ArraySource;
const control = @import("parser").control;

const Self = @This();

fn check(a: u8) bool {
    return a == 'h';
}

test "should parse and map" {
    // Given
    const source = ArraySource(u8).init("h", 0).source();
    const parser = control.Map(u8, bool).init(Self.check).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect(true, result);
}
