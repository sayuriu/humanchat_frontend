import 'dart:async';

class Debounce<T> {
  Debounce({this.debounceTimeMillis = 500});
  final int debounceTimeMillis;
  bool isDebound = false;
  Future<T?> execute(FutureOr<T> Function() action) async {
    if (isDebound) {
      return null;
    }
    isDebound = true;
    return await Future.delayed(Duration(milliseconds: debounceTimeMillis), () async {
      isDebound = false;
      return await Future(() => action());
    });
  }
}