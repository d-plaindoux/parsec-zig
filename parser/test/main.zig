pub const result = @import("data/result.zig");
pub const basic = @import("basic.zig");
pub const control = @import("control.zig");

test {
    @import("std").testing.refAllDecls(@This());
}
