const std = @import("std");
const stdin = std.io.getStdIn();

const NUMBERS = std.ComptimeStringMap(u32, .{
    .{ "one", 1 },
    .{ "two", 2 },
    .{ "three", 3 },
    .{ "four", 4 },
    .{ "five", 5 },
    .{ "six", 6 },
    .{ "seven", 7 },
    .{ "eight", 8 },
    .{ "nine", 9 },
});

pub fn main() !void {
    var buf: [64]u8 = undefined;
    var sum1: usize = 0;
    var sum2: usize = 0;

    while (stdin.reader().readUntilDelimiter(&buf, '\n') catch null) |line| {
        sum1 += part1(line);
        sum2 += part2(line);
    }

    std.debug.print("part1: {}\npart2: {}\n", .{ sum1, sum2 });
}

pub fn part1(line: []const u8) u32 {
    var first: u32 = 0;
    var last: u32 = 0;

    for (line) |ch| {
        if (parsePart1(ch)) |num| {
            if (first == 0) {
                first = num;
            }
            last = num;
        }
    }

    return last + first * 10;
}

fn parsePart1(ch: u8) ?u32 {
    for ([_]u8{ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' }, 0..) |num, i| {
        if (ch == num) return @intCast(i);
    }

    return null;
}

pub fn part2(line: []const u8) u32 {
    var first: u32 = 0;
    var last: u32 = 0;

    for (line, 0..) |ch, i| {
        if (parsePart1(ch)) |num| {
            if (first == 0) {
                first = num;
            }
            last = num;
        } else if (parsePart2(line, i)) |num| {
            if (first == 0) {
                first = num;
            }
            last = num;
        }
    }

    return last + first * 10;
}
fn parsePart2(line: []const u8, i: usize) ?u32 {
    const len = line.len;
    // what the hell??
    if (i + 3 <= len) if (NUMBERS.get(line[i .. i + 3])) |num| return num;
    if (i + 4 <= len) if (NUMBERS.get(line[i .. i + 4])) |num| return num;
    if (i + 5 <= len) if (NUMBERS.get(line[i .. i + 5])) |num| return num;
    return null;
}
