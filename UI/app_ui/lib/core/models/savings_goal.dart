/// Savings goal model
class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final DateTime deadline;
  final String? emoji;

  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
    this.emoji,
  });

  double get remaining => targetAmount - savedAmount;
  double get percentage => (savedAmount / targetAmount * 100).clamp(0, 100);
  bool get isCompleted => savedAmount >= targetAmount;
}
