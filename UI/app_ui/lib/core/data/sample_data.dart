import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/account.dart';
import '../models/category.dart';
import '../models/budget.dart';
import '../models/savings_goal.dart';
import '../models/loan.dart';

/// Sample data for UI demonstration
/// Shows realistic financial data for learning purposes
class SampleData {
  SampleData._();

  // ============================================
  // Categories
  // ============================================

  static final List<Category> expenseCategories = [
    const Category(
      id: 'food',
      name: 'Food & Dining',
      icon: Icons.restaurant_outlined,
      color: Color(0xFFEF4444),
      subcategories: ['Restaurants', 'Groceries', 'Coffee', 'Fast Food'],
    ),
    const Category(
      id: 'transport',
      name: 'Transportation',
      icon: Icons.directions_car_outlined,
      color: Color(0xFFF59E0B),
      subcategories: ['Fuel', 'Parking', 'Taxi', 'Public Transit'],
    ),
    const Category(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag_outlined,
      color: Color(0xFFEC4899),
      subcategories: ['Clothing', 'Electronics', 'Gifts', 'Other'],
    ),
    const Category(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.movie_outlined,
      color: Color(0xFF8B5CF6),
      subcategories: ['Movies', 'Games', 'Sports', 'Hobbies'],
    ),
    const Category(
      id: 'bills',
      name: 'Bills & Utilities',
      icon: Icons.receipt_long_outlined,
      color: Color(0xFF3B82F6),
      subcategories: ['Electricity', 'Water', 'Internet', 'Phone'],
    ),
    const Category(
      id: 'health',
      name: 'Health & Fitness',
      icon: Icons.favorite_border,
      color: Color(0xFF10B981),
      subcategories: ['Doctor', 'Pharmacy', 'Gym', 'Supplements'],
    ),
    const Category(
      id: 'education',
      name: 'Education',
      icon: Icons.school_outlined,
      color: Color(0xFF06B6D4),
      subcategories: ['Courses', 'Books', 'Supplies', 'Tuition'],
    ),
    const Category(
      id: 'other',
      name: 'Other',
      icon: Icons.more_horiz,
      color: Color(0xFF6B7280),
      subcategories: [],
    ),
  ];

  static final List<Category> incomeCategories = [
    const Category(
      id: 'salary',
      name: 'Salary',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFF10B981),
    ),
    const Category(
      id: 'freelance',
      name: 'Freelance',
      icon: Icons.laptop_mac_outlined,
      color: Color(0xFF06B6D4),
    ),
    const Category(
      id: 'investment',
      name: 'Investment',
      icon: Icons.trending_up,
      color: Color(0xFF8B5CF6),
    ),
    const Category(
      id: 'other_income',
      name: 'Other',
      icon: Icons.more_horiz,
      color: Color(0xFF6B7280),
    ),
  ];

  // ============================================
  // Accounts
  // ============================================

  static final List<Account> accounts = [
    const Account(
      id: 'acc1',
      name: 'Main Bank',
      type: AccountType.bank,
      balance: 12450.00,
      accountNumber: '****1234',
    ),
    const Account(
      id: 'acc2',
      name: 'Credit Card',
      type: AccountType.card,
      balance: 3250.50,
      accountNumber: '****5678',
    ),
    const Account(
      id: 'acc3',
      name: 'PayPal',
      type: AccountType.wallet,
      balance: 845.00,
    ),
    const Account(
      id: 'acc4',
      name: 'Cash',
      type: AccountType.cash,
      balance: 320.00,
    ),
    const Account(
      id: 'acc5',
      name: 'Savings',
      type: AccountType.savings,
      balance: 25000.00,
    ),
  ];

  // ============================================
  // Transactions
  // ============================================

  static final List<Transaction> transactions = [
    // Today
    Transaction(
      id: 't1',
      title: 'Salary',
      amount: 5000.00,
      type: TransactionType.income,
      category: 'salary',
      account: 'acc1',
      date: DateTime.now(),
      notes: 'Monthly salary',
    ),
    Transaction(
      id: 't2',
      title: 'Grocery Shopping',
      amount: 156.80,
      type: TransactionType.expense,
      category: 'food',
      subcategory: 'Groceries',
      account: 'acc1',
      date: DateTime.now(),
    ),
    Transaction(
      id: 't3',
      title: 'Gas Station',
      amount: 45.00,
      type: TransactionType.expense,
      category: 'transport',
      subcategory: 'Fuel',
      account: 'acc2',
      date: DateTime.now(),
    ),

    // Yesterday
    Transaction(
      id: 't4',
      title: 'Restaurant',
      amount: 85.50,
      type: TransactionType.expense,
      category: 'food',
      subcategory: 'Restaurants',
      account: 'acc2',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: 't5',
      title: 'Freelance Project',
      amount: 1200.00,
      type: TransactionType.income,
      category: 'freelance',
      account: 'acc3',
      date: DateTime.now().subtract(const Duration(days: 1)),
      notes: 'Website development',
    ),
    Transaction(
      id: 't6',
      title: 'Netflix',
      amount: 15.99,
      type: TransactionType.expense,
      category: 'entertainment',
      subcategory: 'Movies',
      account: 'acc1',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),

    // 2 days ago
    Transaction(
      id: 't7',
      title: 'Electricity Bill',
      amount: 125.00,
      type: TransactionType.expense,
      category: 'bills',
      subcategory: 'Electricity',
      account: 'acc1',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: 't8',
      title: 'Coffee Shop',
      amount: 12.50,
      type: TransactionType.expense,
      category: 'food',
      subcategory: 'Coffee',
      account: 'acc4',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),

    // 3 days ago
    Transaction(
      id: 't9',
      title: 'Gym Membership',
      amount: 50.00,
      type: TransactionType.expense,
      category: 'health',
      subcategory: 'Gym',
      account: 'acc1',
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Transaction(
      id: 't10',
      title: 'Online Course',
      amount: 89.99,
      type: TransactionType.expense,
      category: 'education',
      subcategory: 'Courses',
      account: 'acc2',
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),

    // 5 days ago
    Transaction(
      id: 't11',
      title: 'Investment Return',
      amount: 450.00,
      type: TransactionType.income,
      category: 'investment',
      account: 'acc5',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Transaction(
      id: 't12',
      title: 'Shopping Mall',
      amount: 235.00,
      type: TransactionType.expense,
      category: 'shopping',
      subcategory: 'Clothing',
      account: 'acc2',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // ============================================
  // Budgets
  // ============================================

  static final List<Budget> budgets = [
    Budget(
      id: 'b1',
      category: 'Food & Dining',
      limit: 600.00,
      spent: 454.80,
      startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      endDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
    ),
    Budget(
      id: 'b2',
      category: 'Transportation',
      limit: 200.00,
      spent: 145.00,
      startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      endDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
    ),
    Budget(
      id: 'b3',
      category: 'Entertainment',
      limit: 150.00,
      spent: 165.99,
      startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      endDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
    ),
    Budget(
      id: 'b4',
      category: 'Shopping',
      limit: 400.00,
      spent: 235.00,
      startDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
      endDate: DateTime(DateTime.now().year, DateTime.now().month + 1, 0),
    ),
  ];

  // ============================================
  // Savings Goals
  // ============================================

  static final List<SavingsGoal> savingsGoals = [
    SavingsGoal(
      id: 's1',
      name: 'New Laptop',
      targetAmount: 2000.00,
      savedAmount: 1450.00,
      deadline: DateTime.now().add(const Duration(days: 60)),
      emoji: '💻',
    ),
    SavingsGoal(
      id: 's2',
      name: 'Vacation to Bali',
      targetAmount: 3500.00,
      savedAmount: 850.00,
      deadline: DateTime.now().add(const Duration(days: 180)),
      emoji: '🏝️',
    ),
    SavingsGoal(
      id: 's3',
      name: 'Emergency Fund',
      targetAmount: 10000.00,
      savedAmount: 6200.00,
      deadline: DateTime.now().add(const Duration(days: 365)),
      emoji: '🛡️',
    ),
    SavingsGoal(
      id: 's4',
      name: 'New Car',
      targetAmount: 25000.00,
      savedAmount: 8500.00,
      deadline: DateTime.now().add(const Duration(days: 730)),
      emoji: '🚗',
    ),
  ];

  // ============================================
  // Loans
  // ============================================

  static final List<Loan> loans = [
    Loan(
      id: 'l1',
      name: 'Personal Loan - Bank',
      type: LoanType.taken,
      totalAmount: 5000.00,
      paidAmount: 2800.00,
      dueDate: DateTime.now().add(const Duration(days: 180)),
      notes: 'EMI: \$200/month',
    ),
    Loan(
      id: 'l2',
      name: 'Lent to John',
      type: LoanType.given,
      totalAmount: 800.00,
      paidAmount: 300.00,
      dueDate: DateTime.now().add(const Duration(days: 45)),
      notes: 'Friend - to be returned by March',
    ),
    Loan(
      id: 'l3',
      name: 'Lent to Sarah',
      type: LoanType.given,
      totalAmount: 1500.00,
      paidAmount: 1500.00,
      dueDate: DateTime.now().subtract(const Duration(days: 10)),
      notes: 'Fully repaid',
    ),
  ];

  // ============================================
  // Calculated Data
  // ============================================

  static double get totalBalance {
    return accounts.fold(0.0, (sum, account) => sum + account.balance);
  }

  static double get monthlyIncome {
    final now = DateTime.now();
    final thisMonth = transactions.where(
      (t) =>
          t.type == TransactionType.income &&
          t.date.month == now.month &&
          t.date.year == now.year,
    );
    return thisMonth.fold(0.0, (sum, t) => sum + t.amount);
  }

  static double get monthlyExpense {
    final now = DateTime.now();
    final thisMonth = transactions.where(
      (t) =>
          t.type == TransactionType.expense &&
          t.date.month == now.month &&
          t.date.year == now.year,
    );
    return thisMonth.fold(0.0, (sum, t) => sum + t.amount);
  }
}
