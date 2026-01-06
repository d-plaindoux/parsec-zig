const constCast = @import("core").fun.cast.asConst;
const Source = @import("source").Source;
const Result = @import("data/result.zig").Result;

pub fn Parser(comptime I: type, comptime O: type) type {
    return struct {
        const Self = @This();

        v_impl: *const anyopaque,
        v_table: *const VTable,

        const VTable = struct {
            run: *const fn (self: *const anyopaque, Source(I)) Result(I, O),
        };

        pub fn from(impl_obj: anytype) Self {
            return .{
                .v_impl = impl_obj,
                .v_table = &VTable{
                    .run = Adapter(impl_obj).run,
                },
            };
        }

        inline fn Adapter(impl_obj: anytype) type {
            const ImplType = @TypeOf(impl_obj);

            return struct {
                fn run(impl: *const anyopaque, source: Source(I)) Result(I, O) {
                    return constCast(ImplType, impl).run(source);
                }
            };
        }

        pub fn run(self: Self, source: Source(I)) Result(I, O) {
            return self.v_table.run(self.v_impl, source);
        }
    };
}
