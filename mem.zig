const std = @import("std");

fn copyWithAllocator(allocator: std.mem.Allocator, T: type, t: T) *T {
    const a = allocator.create(T) catch @panic("OOM");
    a.* = t;
    return a;
}

fn copy(T: type, t: T) *T {
    return copyWithAllocator(std.heap.page_allocator, T, t);
}

fn Owner(comptime T: type) type {
    return struct {
        const Self = @This();

        owned: *const T,

        fn init(owned: *const T) Self {
            return Self{ .owned = owned };
        }
    };
}

const Address: type = struct {
    const Self = @This();

    value: []const u8,

    fn init(value: []const u8) Self {
        return Self{ .value = value };
    }
};

const Person: type = struct {
    const Self = @This();

    name: []const u8,
    address: Owner(Address),

    fn init(name: []const u8, address: *const Address) Self {
        return Self{ .name = name, .address = Owner(Address).init(address) };
    }

    fn relocate(self: Self, address: Address) Self {
        return init(self.name, copy(@TypeOf(address), address));
    }
};

pub fn main() void {
    const a = Address.init("Bobs address");
    const p = Person.init("Bob", &a).relocate(Address.init("toto"));

    std.debug.print("{*} =?= {*}\n", .{ &a, &p.address });
    std.debug.print("{any} =?= {any}\n", .{ a, p.address });
}
