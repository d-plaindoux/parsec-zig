const std = @import("std");

pub fn build(b: *std.Build,test_step: *std.Build.Step) *std.Build.Step.Compile {
    // Core library
    const core = b.addLibrary(.{
        .name = "core",
        .root_module = b.createModule(.{
            .root_source_file = b.path("core/main.zig"),
            .target = b.graph.host,
        }),
    });

    const tests = [_][]const u8{ "core/tests/pair.zig", "core/tests/try.zig" };
    for (tests) |a_test| {
        const coreTests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(a_test),
                .target = b.graph.host,
            }),
        });
        coreTests.root_module.addImport("core", core.root_module);
        test_step.dependOn(&b.addRunArtifact(coreTests).step);
    }

    b.installArtifact(core);

    return core;
}
