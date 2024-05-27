class Throttle {
  Throttle({this.throttleGapMillis});
  final int? throttleGapMillis;
  int? lastActionTime;

  dynamic execute(dynamic Function() action) {
    if (lastActionTime == null) {
      action();
      lastActionTime = DateTime.now().microsecondsSinceEpoch;
    } else {
      if (DateTime.now().microsecondsSinceEpoch - lastActionTime! > (throttleGapMillis ?? 500)) {
        action();
        lastActionTime = DateTime.now().microsecondsSinceEpoch;
      }
    }
  }
}