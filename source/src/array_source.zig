const std = @import("std");
const string = @import("core").data.Pair;
const Pair = @import("core").data.Pair;
const Source = @import("source.zig").Source;

pub fn ArraySource(comptime T: type) type {
    return struct {
        const Self = @This();

        index: usize,
        elements: []const T,

        pub fn source(self: *const Self, options: struct { copy: bool = true }) Source(u8) {
            return Source(T).from(self, .{ .copy = options.copy });
        }

        pub fn init(elements: []const T) Self {
            return .{
                .index = 0,
                .elements = elements,
            };
        }

        pub fn next(self: Self) Pair(?T, Self) {
            if (self.index < self.elements.len) {
                return .{
                    ._1 = self.elements[self.index],
                    ._2 = Self{ .elements = self.elements, .index = self.index + 1 },
                };
            } else {
                return .{
                    ._1 = null,
                    ._2 = self,
                };
            }
        }

        pub fn toString(_: Self) []const u8 {
            return "TODO";
        }
    };
}
