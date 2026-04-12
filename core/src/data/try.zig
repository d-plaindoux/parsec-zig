const std = @import("std");

pub fn Try(comptime S: type) type {
    return union(enum) {
        success: S,
        failure: []u8,

        const Self = @This();

        pub fn pure(s: S) Self {
            return .{ .success = s };
        }

        pub fn map(self: Self, T: type, mapper: fn (S) T) Try(T) {
            return switch (self) {
                .success => |*s| .{ .success = mapper(s.*) },
                .failure => |*f| .{ .failure = f.* },
            };
        }

        pub fn flatMap(self: Self, T: type, binder: fn (S) Try(T)) Try(T) {
            return switch (self) {
                .success => |*s| binder(s.*),
                .failure => |*f| .{ .failure = f.* },
            };
        }
    };
}
