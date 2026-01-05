const std = @import("std");

pub fn build(b: *std.Build, _: *std.Build.Step) void {
    const core = b.modules.get("core") orelse @panic("core module is missing");
    const source = b.modules.get("source") orelse @panic("source module is missing");

    const parser = b.addLibrary(.{
        .name = "parser",
        .root_module = b.createModule(.{
            .root_source_file = b.path("parser/main.zig"),
            .target = b.graph.host,
        }),
    });

    parser.root_module.addImport("core", core);
    parser.root_module.addImport("source", source);

    b.installArtifact(parser);
}
