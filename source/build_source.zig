const std = @import("std");

pub fn build(b: *std.Build, core: *std.Build.Step.Compile, test_step: *std.Build.Step) *std.Build.Step.Compile {
    // Core library
    const source = b.addLibrary(.{
        .name = "source",
        .root_module = b.createModule(.{
            .root_source_file = b.path("source/main.zig"),
            .target = b.graph.host,
        }),
    });
    source.root_module.addImport("core", core.root_module);

    const tests = [_][]const u8{"source/tests/array_source.zig"};
    for (tests) |a_test| {
        const coreTests = b.addTest(.{
            .root_module = b.createModule(.{
                .root_source_file = b.path(a_test),
                .target = b.graph.host,
            }),
        });
        coreTests.root_module.addImport("source", source.root_module);
        test_step.dependOn(&b.addRunArtifact(coreTests).step);
    }

    b.installArtifact(source);

    return source;
}
