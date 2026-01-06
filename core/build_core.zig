const std = @import("std");

pub fn build(b: *std.Build, test_step: *std.Build.Step) void {
    // Core library
    const core = b.addModule(
        "core",
        .{
            .root_source_file = b.path("core/main.zig"),
            .target = b.graph.host,
        },
    );

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("core/test/main.zig"),
            .target = b.graph.host,
        }),
    });

    tests.root_module.addImport("core", core);
    test_step.dependOn(&b.addRunArtifact(tests).step);
}
