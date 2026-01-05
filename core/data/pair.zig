pub fn Pair(comptime F: type, comptime S: type) type {
    return struct {
        _1: F,
        _2: S,

        const Self = @This();

        pub fn init(f: F, s: S) Self {
            return .{ ._1 = f, ._2 = s };
        }

        pub fn fst(self: Self) F {
            return self._1;
        }

        pub fn snd(self: Self) S {
            return self._2;
        }
    };
}
