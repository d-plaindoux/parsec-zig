const std = @import("std");
const Try = @import("core").data.Try;

fn isZero(i: u32) bool {
    return i == 0;
}

fn incrementTry(i: u32) Try(u32) {
    return Try(u32).pure(i + 1);
}

test "perform a simple map" {
    const expect = std.testing.expect;

    const v1 = Try(u32).pure(1);
    const v2 = v1.map(bool, isZero);

    try expect(std.meta.eql(v2, Try(bool).pure(false)));
}

test "perform a simple bind" {
    const expect = std.testing.expectEqualDeep;

    const v1 = Try(u32).pure(1);
    const v2 = v1.bind(u32, incrementTry);

    try expect(v2, Try(u32).pure(2));
}
