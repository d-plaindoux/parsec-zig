const expect = @import("std").testing.expectEqualDeep;
const Closure = @import("core").data.Closure;

test "should validate an adder closure" {
    const Adder = struct {
        const Self = @This();

        offset: u32,

        fn closure(self: *const Self) Closure(u32, u32) {
            return Closure(u32, u32).from(self);
        }

        fn init(offset: u32) Self {
            return Self{ .offset = offset };
        }

        pub fn apply(self: Self, i: u32) u32 {
            return i + self.offset;
        }
    };

    const closure = Adder.init(21).closure();

    try expect(42, closure.apply(21));
}
