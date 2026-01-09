/// Transaction type enum
enum TransactionType { income, expense }

/// Transaction model
/// Demonstrates a clean data model for financial transactions
class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;
  final String? subcategory;
  final String account;
  final DateTime date;
  final String? notes;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    this.subcategory,
    required this.account,
    required this.date,
    this.notes,
  });

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
}
