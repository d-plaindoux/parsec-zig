const std = @import("std");
const Pair = @import("core").data.Pair;
const Source = @import("../source.zig").Source;

pub fn ArraySource(comptime T: type) type {
    return struct {
        elements: []const T,
        index: usize,

        const Self = @This();

        pub fn source(self: *const Self) Source(u8) {
            return Source(T).from(self);
        }

        pub fn init(elements: []const T, index: usize) Self {
            return .{
                .elements = elements,
                .index = index,
            };
        }

        pub fn next(self: Self) Pair(?T, Self) {
            if (self.index < self.elements.len) {
                return .{
                    ._1 = self.elements[self.index],
                    ._2 = Self.init(self.elements, self.index + 1),
                };
            } else {
                return .{
                    ._1 = null,
                    ._2 = self,
                };
            }
        }
    };
}
