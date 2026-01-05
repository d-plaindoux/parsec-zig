pub fn as(T: type, opaque_ptr: *anyopaque) T {
    return @as(T, @ptrCast(@alignCast(opaque_ptr)));
}

pub fn asConst(T: type, opaque_ptr: *const anyopaque) T {
    return @as(T, @ptrCast(@alignCast(@constCast(opaque_ptr))));
}
