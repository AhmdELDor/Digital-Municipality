import 'package:get/get.dart';

extension $DoubleExtension on double {
  (double days, double hours, double minutes, double seconds)
      getDurationFromDouble() {
    double hours = toDouble();
    double days = (hours / 24).toDouble().toPrecision(2);
    double minutes = ((this - hours) * 60).toDouble();
    double seconds = ((((this - hours) * 60) - minutes) * 60).toDouble();
    return (days, hours, minutes, seconds);
  }
}
