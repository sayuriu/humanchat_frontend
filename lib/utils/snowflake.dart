
timestampFromSnowflake(BigInt snowflake, BigInt epoch) {
  return DateTime.fromMillisecondsSinceEpoch((snowflake >> 22).toInt() + epoch.toInt());
}

extension SnowflakeExtensions on BigInt {
  static final epoch = DateTime.utc(2024, 1, 1).millisecondsSinceEpoch;
  DateTime get timestamp => timestampFromSnowflake(this, BigInt.from(epoch));
}

typedef Snowflake = BigInt;

extension RelativeTimeFormat on DateTime {
  String toRelativeTimeString() {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 0) {
      return "${diff.inDays}d ago";
    } else if (diff.inHours > 0) {
      return "${diff.inHours}h ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes}m ago";
    } else {
      return "Just now";
    }
  }
}