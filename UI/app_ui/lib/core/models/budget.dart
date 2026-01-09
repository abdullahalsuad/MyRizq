/// Budget model
class Budget {
  final String id;
  final String category;
  final double limit;
  final double spent;
  final DateTime startDate;
  final DateTime endDate;

  const Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
    required this.startDate,
    required this.endDate,
  });

  double get remaining => limit - spent;
  double get percentage => (spent / limit * 100).clamp(0, 100);
  bool get isExceeded => spent > limit;
  bool get isNearLimit => percentage >= 80 && percentage < 100;
}
