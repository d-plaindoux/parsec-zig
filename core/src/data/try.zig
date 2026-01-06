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
            switch (self) {
                .success => |*s| return .{ .success = mapper(s.*) },
                .failure => |*f| return .{ .failure = f.* },
            }
        }

        pub fn bind(self: Self, T: type, binder: fn (S) Try(T)) Try(T) {
            switch (self) {
                .success => |*s| return binder(s.*),
                .failure => |*f| return .{ .failure = f.* },
            }
        }
    };
}
