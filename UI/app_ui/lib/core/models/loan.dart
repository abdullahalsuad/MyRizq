/// Loan type enum
enum LoanType { taken, given }

/// Loan model
class Loan {
  final String id;
  final String name;
  final LoanType type;
  final double totalAmount;
  final double paidAmount;
  final DateTime dueDate;
  final String? notes;

  const Loan({
    required this.id,
    required this.name,
    required this.type,
    required this.totalAmount,
    required this.paidAmount,
    required this.dueDate,
    this.notes,
  });

  double get remainingAmount => totalAmount - paidAmount;
  double get percentage => (paidAmount / totalAmount * 100).clamp(0, 100);
  bool get isCompleted => paidAmount >= totalAmount;
  bool get isTaken => type == LoanType.taken;
  bool get isGiven => type == LoanType.given;
}
