const memory = @import("../utils/memory.zig");
const constCast = @import("../fun/cast.zig").asConst;

pub fn Closure(comptime I: type, comptime O: type) type {
    return struct {
        const Self = @This();

        v_impl: *const anyopaque,
        v_table: *const VTable,

        const VTable = struct {
            apply: *const fn (self: *const anyopaque, I) O,
        };

        pub fn from(impl_obj: anytype) Self {
            memory.Representation.expectPointer(impl_obj);

            const adapter = Adapter(@TypeOf(impl_obj));
            return Self{
                .v_impl = memory.Allocation.copy(@TypeOf(impl_obj.*), impl_obj.*),
                .v_table = &VTable{
                    .apply = adapter.apply,
                },
            };
        }

        inline fn Adapter(ImplType: type) type {
            return struct {
                fn apply(impl: *const anyopaque, value: I) O {
                    return constCast(ImplType, impl).apply(value);
                }
            };
        }

        pub fn apply(self: Self, value: I) O {
            return self.v_table.apply(self.v_impl, value);
        }
    };
}

pub fn Predicate(comptime I: type) type {
    return Closure(I, bool);
}
