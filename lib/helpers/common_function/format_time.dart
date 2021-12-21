import 'package:intl/intl.dart';

String formatTime(int second) {
  Duration duration = Duration(seconds: second);
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)} giờ $twoDigitMinutes phút $twoDigitSeconds giây";
}

String formatTimeFromTimestamp(int timestamp){
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return DateFormat('dd/MM/yyyy, hh:mm a').format(dateTime);
}