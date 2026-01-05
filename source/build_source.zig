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

    const tests = [_][]const u8{"source/tests/array_source.zig"};
    for (tests) |a_test| {
        const coreTests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(a_test),
                .target = b.graph.host,
            }),
        });
        coreTests.root_module.addImport("source", source);
        test_step.dependOn(&b.addRunArtifact(coreTests).step);
    }
}
