class ChangeMetric {
  final int value;
  final bool isPositive;

  ChangeMetric({
    required this.value,
    required this.isPositive,
  });

  factory ChangeMetric.fromJson(Map<String, dynamic> json) => ChangeMetric(
    value: json["value"] ?? 0,
    isPositive: json["isPositive"] ?? true,
  );
}