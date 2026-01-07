const expect = @import("std").testing.expectEqualDeep;
const Pair = @import("core").data.Pair;
const ArraySource = @import("source").ArraySource;
const spec = @import("parser").spec;
const basic = @import("parser").basic;
const control = @import("parser").control;
const flow = @import("parser").flow;

fn check(l: u8) fn (u8) bool {
    return struct {
        fn eq(r: u8) bool {
            return l == r;
        }
    }.eq;
}

test "should parse two characters" {
    // Given
    const source = ArraySource(u8).init("he", 0).source();
    const inner = basic.Any(u8).init.parser();
    const parser = flow.And(u8, u8, u8).init(inner, inner).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect(Pair(u8, u8).init('h', 'e'), result);
}

test "should parse one characters" {
    // Given
    const source = ArraySource(u8).init("e", 0).source();
    const rhd = basic.Any(u8).init.parser();
    const lhd = control.Satisfy(u8, u8).init(rhd, check('h')).parser();
    const parser = flow.Or(u8, u8).init(lhd, rhd).parser();

    // When
    const result = switch (parser.run(source)) {
        .Success => |v| v.value,
        .Failure => null,
    };

    // Then
    try expect('e', result);
}
