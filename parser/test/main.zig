pub const result = @import("data/result.zig");
pub const basic = @import("basic.zig");

test {
    @import("std").testing.refAllDecls(@This());
}
