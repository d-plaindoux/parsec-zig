const Predicate = @import("core").data.Predicate;

pub const Check = struct {
    const Self = @This();

    expected: u8,

    fn predicate(self: *const Self) Predicate(u8) {
        return Predicate(u8).from(self);
    }

    fn init(expected: u8) Self {
        return Self{ .expected = expected };
    }

    pub fn apply(self: Self, value: u8) bool {
        return self.expected == value;
    }
};

pub fn check(expected: u8) Predicate(u8) {
    return Check.init(expected).predicate();
}
