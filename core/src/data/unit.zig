pub const Unit = struct {
    const Self = @This();

    pub fn unit() Self {
        return .{};
    }
};
