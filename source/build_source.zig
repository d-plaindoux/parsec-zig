const std = @import("std");

pub fn build(b: *std.Build, test_step: *std.Build.Step) void {
    const core = b.modules.get("core") orelse @panic("core module is missing");

    const source = b.addModule(
        "source",
        .{
            .root_source_file = b.path("source/main.zig"),
            .target = b.graph.host,
        },
    );

    source.addImport("core", core);

    const tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("source/test/main.zig"),
            .target = b.graph.host,
        }),
    });
    tests.root_module.addImport("source", source);
    test_step.dependOn(&b.addRunArtifact(tests).step);
}
