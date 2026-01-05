const std = @import("std");

pub fn build(b: *std.Build) void {
    const test_step = b.step("test", "Tests execution");

    @import("core/build_core.zig").build(b, test_step);
    @import("source/build_source.zig").build(b, test_step);
    @import("parser/build_parser.zig").build(b, test_step);
}
