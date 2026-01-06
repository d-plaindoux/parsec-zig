const std = @import("std");
const ArraySource = @import("source").ArraySource;

test "should retrieve the first item" {
    const source = ArraySource(u8).init("Hello", 0).source();

    const response = source.next();

    try std.testing.expectEqual('H', response.fst());
}

test "should retrieve the second item" {
    const source = ArraySource(u8).init("Hello", 0).source();

    const response = source.next().snd().next();

    try std.testing.expectEqual('e', response.fst());
}

test "should retrieve no item" {
    const source = ArraySource(u8).init("H", 0).source();

    const response = source.next().snd().next();

    try std.testing.expectEqual(null, response.fst());
}
