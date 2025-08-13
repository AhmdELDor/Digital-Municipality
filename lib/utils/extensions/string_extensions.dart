import 'package:intl/intl.dart';

extension $StringExtension on String {
  DateTime parseUtcDateTime([String format = "yyyy-MM-dd HH:mm:ss"]) {
    var time = DateFormat(
      format,
    ).parseUTC(replaceAll("T", " ").replaceAll("Z", " "));
    return time;
  }

  DateTime parseLocalDateTime([String format = "yyyy-MM-dd HH:mm:ss"]) {
    var time = DateFormat(
      format,
    ).parse(replaceAll("T", " ").replaceAll("Z", " "));
    return time;
  }

  String parseLocalFormat() {
    return DateFormat("dd/MM/yyyy").format(DateTime.parse(this));
  }

  String parseLocalDateWithFormat(String format) {
    return DateFormat(format).format(DateTime.parse(this));
  }

  String toFormattedPrice([int? lengthAfterDecimal]) {
    int number = double.parse(this).toInt();
    var floatingNumber = double.parse(this) - number;
    if (number > -1000 && number < 1000 && (lengthAfterDecimal ?? 0) > 2) {
      return "$number.${floatingNumber.toStringAsFixed(lengthAfterDecimal ?? 4).substring(2)}";
    }
    final String digits = number.abs().toString();
    final StringBuffer result = StringBuffer(number < 0 ? '-' : '');
    final int maxDigitIndex = digits.length - 1;
    for (int i = 0; i <= maxDigitIndex; i += 1) {
      result.write(digits[i]);
      if (i < maxDigitIndex && (maxDigitIndex - i) % 3 == 0) result.write(',');
    }
    return (lengthAfterDecimal ?? 0) > 2
        ? "$result.${floatingNumber.toStringAsFixed(lengthAfterDecimal ?? 4).substring(2)}"
        : '$result.${floatingNumber.toStringAsFixed(lengthAfterDecimal ?? 4)}';
  }

  String emailFormat([int? number = 3]) {
    if (isEmpty) return this;
    var parts = split('@');
    if (parts.first.length > 3) {
      return "${parts.first.substring(0, number).padRight(parts.first.length, '*')}@${parts.last}";
    }
    return this;
  }

  String phoneFormat() {
    if (isEmpty) return this;
    if (length > 6) {
      return substring(0, 3).padRight(length - 3, '*') +
          substring(length - 3, length);
    }
    return this;
  }

  String get capitalize {
    if (length <= 1) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String timeAgoCustom(DateTime d) {
    // <-- Custom method Time Show  (Display Example  ==> 'Today 7:00 PM')
    Duration diff = DateTime.now().difference(d);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return DateFormat.E().add_jm().format(d);
    }
    if (diff.inHours > 0) {
      return "Today ${DateFormat('jm').format(d)}";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }
}

extension $NullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  int toInt() {
    return this == null ? 0 : int.tryParse(this!) ?? 0;
  }

  double toDouble() {
    return this == null ? 0 : double.tryParse(this!) ?? 0.0;
  }
}
