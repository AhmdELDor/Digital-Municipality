import 'package:intl/intl.dart';

extension $NumberExtension on num? {
  String formattedAmount([int? decimalDigits]) {
    final NumberFormat numberFormat = NumberFormat.currency(
      locale: Intl.getCurrentLocale(),
      customPattern: '##,###.##',
      decimalDigits: decimalDigits ?? 2,
    );
    final String amountString = numberFormat.format(this ?? 0);
    return amountString;
  }
}
