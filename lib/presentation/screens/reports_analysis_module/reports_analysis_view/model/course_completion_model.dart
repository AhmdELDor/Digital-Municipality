import 'package:education_admin_portal/presentation/screens/reports_analysis_module/reports_analysis_view/model/summary_metric_model.dart';

class CourseCompletion {
  final int currentRate;
  final SummaryMetric last6MonthAverage;
  final SummaryMetric last3YearAverage;

  CourseCompletion({
    required this.currentRate,
    required this.last6MonthAverage,
    required this.last3YearAverage,
  });

  /// ✅ Empty defaults
  factory CourseCompletion.empty() => CourseCompletion(
    currentRate: 0,
    last6MonthAverage: SummaryMetric.empty(),
    last3YearAverage: SummaryMetric.empty(),
  );

  factory CourseCompletion.fromJson(Map<String, dynamic> json) =>
      CourseCompletion(
        currentRate: json["currentRate"] ?? 0,
        last6MonthAverage: json["last6MonthAverage"] != null
            ? SummaryMetric.fromJson(json["last6MonthAverage"])
            : SummaryMetric.empty(),
        last3YearAverage: json["last3YearAverage"] != null
            ? SummaryMetric.fromJson(json["last3YearAverage"])
            : SummaryMetric.empty(),
      );
}
