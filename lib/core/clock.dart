/// Millisecond clock used for last-write-wins timestamps.
class Clock {
  const Clock();

  int nowMillis() => DateTime.now().toUtc().millisecondsSinceEpoch;
}

class FakeClock extends Clock {
  FakeClock(this.millis);

  int millis;

  @override
  int nowMillis() => millis;

  void advance(Duration duration) {
    millis += duration.inMilliseconds;
  }
}
