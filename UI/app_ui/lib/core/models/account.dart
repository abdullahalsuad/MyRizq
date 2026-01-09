/// Account type enum
enum AccountType { bank, card, wallet, cash, savings }

/// Account model
class Account {
  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final String? accountNumber;
  final String? icon;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.accountNumber,
    this.icon,
  });

  String get typeLabel {
    switch (type) {
      case AccountType.bank:
        return 'Bank Account';
      case AccountType.card:
        return 'Credit Card';
      case AccountType.wallet:
        return 'E-Wallet';
      case AccountType.cash:
        return 'Cash';
      case AccountType.savings:
        return 'Savings';
    }
  }
}
