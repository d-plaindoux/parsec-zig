const memory = @import("core").memory;
const constCast = @import("core").fun.cast.asConst;
const Pair = @import("core").data.Pair;

pub fn Source(comptime T: type) type {
    return struct {
        const Self = @This();

        v_impl: *const anyopaque,
        v_table: *const VTable,

        const VTable = struct {
            next: *const fn (self: *const anyopaque) Pair(?T, Self),
        };

        pub fn from(impl_obj: anytype) Self {
            memory.Predicate.expectPointer(impl_obj);

            const adapter = Adapter(@TypeOf(impl_obj));

            return Self{
                .v_impl = memory.Allocation.copy(@TypeOf(impl_obj.*), impl_obj.*),
                .v_table = &VTable{
                    .next = adapter.next,
                },
            };
        }

        inline fn Adapter(ImplType: type) type {
            return struct {
                fn next(impl: *const anyopaque) Pair(?T, Self) {
                    const result = constCast(ImplType, impl).next();
                    return Pair(?T, Self).init(result.fst(), from(&result.snd()));
                }
            };
        }

        pub fn next(self: Self) Pair(?T, Self) {
            return self.v_table.next(self.v_impl);
        }
    };
}
