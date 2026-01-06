const Source = @import("source").Source;

pub fn Result(I: type, O: type) type {
    return union(enum) {
        Success: struct { value: O, consumed: bool, source: Source(I) },
        Failure: struct { reason: ?[]const u8, consumed: bool, source: Source(I) },

        pub fn success(value: O, consumed: bool, source: Source(I)) @This() {
            return .{ .Success = .{ .value = value, .consumed = consumed, .source = source } };
        }

        pub fn failure(reason: ?[]const u8, consumed: bool, source: Source(I)) @This() {
            return .{ .Failure = .{ .reason = reason, .consumed = consumed, .source = source } };
        }
    };
}
