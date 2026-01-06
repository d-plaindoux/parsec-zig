const pair = @import("pair.zig");
const tries = @import("try.zig");

test {
    @import("std").testing.refAllDecls(@This());
}
