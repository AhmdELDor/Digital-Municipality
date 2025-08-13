import 'dart:async';

class PeriodicTimer {
  final Function() callback;
  final Duration duration;
  Timer? _timer;
  bool _isRunning = false;
  bool _isDisposed = false;

  bool get running => _isRunning;

  PeriodicTimer(this.duration, this.callback);

  void dispose() {
    cancel();
    _timer = null;
    _isDisposed = true;
  }

  void start() {
    if (_isRunning || _isDisposed) return;
    _isRunning = true;
    _start();
  }

  void stop() {
    _timer?.cancel();
    _isRunning = false;
  }

  void cancel() {
    _timer?.cancel();
    _isRunning = false;
  }

  void _start() {
    if (!_isRunning || _isDisposed) return;
    Future.value(callback()).whenComplete(_setNextTimer);
  }

  void _setNextTimer() {
    if (!_isRunning) return;
    _isRunning = true;
    _timer?.cancel();
    _timer = Timer(duration, _start);
  }
}
