pub fn main() !void {
    var sum: i64 = 0;
    while (try readLine()) |line| {
        const nums_list = try readNums(line);
        defer nums_list.deinit();
        sum += extrapolate(nums_list.items, nums_list.items.len);
    }
    try stdout.writer().print("{}\n", .{sum});
}

fn extrapolate(nums: []i64, len: usize) i64 {
    if (allZero(nums, len)) {
        return 0;
    }
    var index: usize = 0;
    while (index < len - 1) : (index += 1) {
        nums[index] = nums[index + 1] - nums[index];
    }
    return nums[len - 1] + extrapolate(nums, len - 1);
}

fn allZero(nums: []i64, len: usize) bool {
    var index: usize = 0;
    while (index < len) : (index += 1) {
        if (nums[index] != 0) {
            return false;
        }
    }
    return true;
}

fn readNums(line: []const u8) !std.ArrayList(i64) {
    var result = std.ArrayList(i64).init(allocator);
    errdefer result.deinit();
    var iter = split(line, " ");
    while (iter.next()) |num| {
        try result.append(try parseDecimal(i64, num));
    }
    return result;
}

const std = @import("std");

const stdout = std.io.getStdOut();
var stdin = std.io.bufferedReader(std.io.getStdIn().reader());
var buf: [4096]u8 = undefined;
const allocator = std.heap.page_allocator;

fn readLine() !?[]const u8 {
    return try stdin.reader().readUntilDelimiterOrEof(&buf, '\n');
}

fn split(
    str: []const u8,
    delimiter: []const u8,
) std.mem.SplitIterator(u8, .sequence) {
    return std.mem.splitSequence(u8, str, delimiter);
}

fn parseDecimal(comptime T: type, str: []const u8) !T {
    return try std.fmt.parseInt(T, str, 10);
}
