import 'package:intl/intl.dart';

extension $DateTimeExtension on DateTime {
  String toLocalString([String format = "yyyy-MM-dd HH:mm:ss"]) {
    var strDate = DateFormat(format).format(this);
    return strDate;
  }

  String toFormatedString([String format = "yyyy-MM-dd HH:mm:ss"]) {
    var strDate = DateFormat(format).format(this);
    return strDate;
  }

  String toTimeZoneString([String format = "yyyy-MM-dd HH:mm:ss"]) {
    var strDate = DateFormat(format).format(toLocal());
    return strDate;
  }

  String toUtcString([String format = "yyyy-MM-dd HH:mm:ss"]) {
    var strDate = DateFormat(format).format(toUtc());
    return strDate;
  }

  bool get isToday {
    var now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day &&
        yesterday.month == month &&
        yesterday.year == year;
  }

  bool isSameDay(DateTime dateTime) {
    return day == dateTime.day &&
        month == dateTime.month &&
        year == dateTime.year;
  }
}

extension DateConversation on String {
  String toLocalDateTime([String format = "yyyy-MM-dd HH:mm:ss"]) {
    return DateFormat(format)
        .format(DateFormat("yyyy-MM-dd hh:mm:ss").parseUTC(this).toLocal());
  }
}
