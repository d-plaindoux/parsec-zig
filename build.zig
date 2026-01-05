const std = @import("std");

pub fn build(b: *std.Build) void {
    const test_step = b.step("test", "Core test execution");
    const core = @import("core/build_core.zig").build(b, test_step);
    const source = @import("source/build_source.zig").build(b,core, test_step);

    // Parsec library
    const parser = b.addLibrary(.{
        .name = "parser",
        .root_module = b.createModule(.{
            .root_source_file = b.path("parser/main.zig"),
            .target = b.graph.host,
        }),
    });

    parser.root_module.addImport("core", core.root_module);
    parser.root_module.addImport("source", source.root_module);

    b.installArtifact(parser);
}
