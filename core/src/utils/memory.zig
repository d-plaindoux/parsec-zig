const std = @import("std");

// Note: inlining do not imply any copy and then preserves passed data.

pub const Representation: type = struct {
    pub inline fn isPointer(value: anytype) bool {
        const ValueType = @TypeOf(value);
        const TypeInfo = @typeInfo(ValueType);

        return TypeInfo == .pointer;
    }

    pub inline fn expectPointer(value: anytype) void {
        if (!isPointer(value)) {
            const ValueType = @TypeOf(value);
            @compileError("requires a pointer, got: " ++ @typeName(ValueType) ++ "\n");
        }
    }
};

pub const Allocation: type = struct {
    pub inline fn copyWithAllocator(allocator: std.mem.Allocator, T: type, t: T) *T {
        const a = allocator.create(T) catch @panic("Out of memory!"); // Ouch this is brutal!
        a.* = t;
        return a;
    }

    pub inline fn copy(T: type, t: T) *T {
        return copyWithAllocator(std.heap.page_allocator, T, t);
    }
};
