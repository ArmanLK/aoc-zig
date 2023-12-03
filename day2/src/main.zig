const std = @import("std");
const stdin = std.io.getStdIn();
const mem = std.mem;

const Hand = struct {
    const Color = enum {
        Red,
        Green,
        Blue,
        UnKhown,
    };
    color: Color,
    num: u32,

    const Self = @This();

    fn new(num: u32, color_name: []const u8) Self {
        if (mem.eql(u8, color_name, "red")) {
            return .{ .color = .Red, .num = num };
        } else if (mem.eql(u8, color_name, "green")) {
            return .{ .color = .Green, .num = num };
        } else if (mem.eql(u8, color_name, "blue")) {
            return .{ .color = .Blue, .num = num };
        } else {
            return .{ .color = .UnKhown, .num = num };
        }
    }
};

pub fn main() !void {
    var buf: [200]u8 = undefined;
    var sum1: usize = 0;
    var sum2: usize = 0;

    while (stdin.reader().readUntilDelimiter(&buf, '\n') catch null) |line| {
        sum1 += try part1(line);
        sum2 += try part2(line);
    }

    std.debug.print("part1: {}\npart2: {}\n", .{ sum1, sum2 });
}

fn part1(line: []const u8) !u32 {
    // Ignore Game
    const no_game_line = line[5..];
    var game_num_and_game = mem.splitScalar(u8, no_game_line, ':');
    const game_num = try std.fmt.parseInt(u32, game_num_and_game.next().?, 10); // use (.?) becuse I know it will not fail.
    var game = game_num_and_game.next().?; // again. I know it will not fail.
    var sets = mem.splitScalar(u8, game, ';');
    while (sets.next()) |set| {
        var hands = mem.splitScalar(u8, set, ',');
        while (hands.next()) |hand| {
            var x = mem.splitScalar(u8, hand, ' ');
            _ = x.next().?; // this is a space
            const num = try std.fmt.parseInt(u32, x.next().?, 10);
            const color = x.next().?;
            const ab = Hand.new(num, color);
            switch (ab.color) {
                .Red => {
                    if (ab.num > 12) return 0;
                },
                .Blue => {
                    if (ab.num > 14) return 0;
                },
                .Green => {
                    if (ab.num > 13) return 0;
                },
                .UnKhown => {
                    return 0;
                },
            }
        }
    }
    return game_num;
}

fn part2(line: []const u8) !u32 {
    var max_red: u32 = 0;
    var max_blue: u32 = 0;
    var max_green: u32 = 0;
    // Ignore Game
    const no_game_line = line[5..];
    var game_num_and_game = mem.splitScalar(u8, no_game_line, ':');
    // Ignoring game number for second game. It will not fail.
    _ = game_num_and_game.next();
    var game = game_num_and_game.next().?; // again. I know it will not fail.
    var sets = mem.splitScalar(u8, game, ';');
    while (sets.next()) |set| {
        var hands = mem.splitScalar(u8, set, ',');
        while (hands.next()) |hand| {
            var x = mem.splitScalar(u8, hand, ' ');
            _ = x.next().?; // this is a space
            const num = try std.fmt.parseInt(u32, x.next().?, 10);
            const color = x.next().?;
            const ab = Hand.new(num, color);
            switch (ab.color) {
                .Red => {
                    if (max_red < ab.num) max_red = ab.num;
                },
                .Blue => {
                    if (max_blue < ab.num) max_blue = ab.num;
                },
                .Green => {
                    if (max_green < ab.num) max_green = ab.num;
                },
                .UnKhown => {
                    return 0;
                },
            }
        }
    }
    const power = max_red * max_blue * max_green;
    return power;
}
