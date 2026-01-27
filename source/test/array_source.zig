const std = @import("std");
const ArraySource = @import("source").ArraySource;

test "should retrieve the nothing" {
    const source = ArraySource(u8).init("").source(.{});

    const response = source.next();

    try std.testing.expectEqual(null, response.fst());
}

test "should retrieve the first item" {
    const source = ArraySource(u8).init("Hello").source(.{});

    const response = source.next();

    try std.testing.expectEqual('H', response.fst());
}

test "should retrieve the second item" {
    const source = ArraySource(u8).init("Hello").source(.{});

    const response = source.next().snd().next();

    try std.testing.expectEqual('e', response.fst());
}

test "should retrieve no item" {
    const source = ArraySource(u8).init("H").source(.{});

    const response = source.next().snd().next();

    try std.testing.expectEqual(null, response.fst());
}
