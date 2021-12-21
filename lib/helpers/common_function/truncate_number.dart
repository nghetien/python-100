import 'package:intl/intl.dart';

String truncateNumberToString(dynamic number) {
  final f = NumberFormat("###,###.###", "tr_TR");
  return f.format(number);
}

String truncateNumberToUCoin(dynamic number) {
  final f = NumberFormat("###,###.###", "tr_TR");
  String convertUCoin = f.format(number);
  if(convertUCoin.length >= 13){
    convertUCoin = "${convertUCoin.substring(0, 13)}...";
  }
  return convertUCoin;
}