const Result = @import("result.zig").Result;

fn Parser(comptime I: type, comptime O: type) type {
    return fn (I) Result(O);
}
