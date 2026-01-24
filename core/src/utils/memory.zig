const std = @import("std");

pub const Predicate: type = struct {
    pub fn expectPointer(value: anytype) void {
        const ValueType = @TypeOf(value);
        const TypeInfo = @typeInfo(ValueType);

        if (TypeInfo != .pointer) {
            @compileError("requires a pointer, got: " ++ @typeName(ValueType));
        }
    }
};

pub const Allocation: type = struct {
    pub fn copyWithAllocator(allocator: std.mem.Allocator, T: type, t: T) *T {
        const a = allocator.create(T) catch @panic("Out of memory!"); // Ouch this is brutal!
        a.* = t;
        return a;
    }

    pub fn copy(T: type, t: T) *T {
        return copyWithAllocator(std.heap.page_allocator, T, t);
    }
};
