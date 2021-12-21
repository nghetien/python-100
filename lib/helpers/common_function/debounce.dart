import 'dart:async';
import 'dart:ui';

class Debounce{
  final int seconds;
  Timer? _timer;

  Debounce({this.seconds = 5});

  void run(VoidCallback action){
    if(_timer?.isActive ?? false) _timer?.cancel();
    _timer = Timer(Duration(seconds: seconds), action);
  }

  void dispose() => _timer?.cancel();
}