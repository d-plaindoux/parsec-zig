const Pair = @import("core").data.Pair;

test "should return Pair first" {
    const expect = @import("std").testing.expectEqualDeep;

    const p = Pair(u8, []const u8).init(1, "hello");

    try expect(1, p.fst());
}

test "should return Pair second" {
    const expect = @import("std").testing.expectEqualDeep;

    const p = Pair(u8, *const ["hello".len:0]u8).init(1, "hello");

    try expect("hello", p.snd());
}
