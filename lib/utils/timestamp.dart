import 'package:intl/intl.dart';

String getTimestamp() {
  DateTime now = DateTime.now();
  String currentTime = DateFormat('H:m, MMM d ''yyyy.').format(now);
  return currentTime;
}


String getCurrentDate() {
  DateTime now = DateTime.now();
  String creationDate = DateFormat('EEE, MMM d ''yyyy').format(now);
  return creationDate;
}