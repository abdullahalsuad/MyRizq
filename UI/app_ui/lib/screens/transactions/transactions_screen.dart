import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';
import '../../core/data/sample_data.dart';
import '../../core/models/transaction.dart';
import '../../core/utils/format_utils.dart';
import '../../widgets/list_items/transaction_list_item.dart';
import '../add_transaction/add_transaction_screen.dart';

/// Transactions Screen - Grouped list of all transactions
/// Demonstrates list grouping, filtering, and date-based sorting
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Income', 'Expense'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Group transactions by date
    final groupedTransactions = _groupTransactionsByDate(
      _getFilteredTransactions(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.sm,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: Spacing.sm),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const Divider(height: 1),

          // Transactions List
          Expanded(
            child: groupedTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: Spacing.md),
                        Text(
                          'No transactions found',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
                    itemCount: groupedTransactions.length,
                    itemBuilder: (context, index) {
                      final dateGroup = groupedTransactions[index];
                      return _buildTransactionGroup(
                        context,
                        dateGroup['date'] as DateTime,
                        dateGroup['transactions'] as List<Transaction>,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransactionGroup(
    BuildContext context,
    DateTime date,
    List<Transaction> transactions,
  ) {
    final theme = Theme.of(context);

    // Calculate total for the day
    double totalIncome = 0;
    double totalExpense = 0;
    for (var t in transactions) {
      if (t.type == TransactionType.income) {
        totalIncome += t.amount;
      } else {
        totalExpense += t.amount;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          color: theme.colorScheme.surfaceContainerLowest,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FormatUtils.relativeDate(date),
                style: theme.textTheme.titleMedium,
              ),
              Text(
                FormatUtils.dateShort(date),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),

        // Transactions
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final category =
                (transaction.type == TransactionType.income
                        ? SampleData.incomeCategories
                        : SampleData.expenseCategories)
                    .firstWhere(
                      (c) => c.id == transaction.category,
                      orElse: () => SampleData.expenseCategories.last,
                    );

            return TransactionListItem(
              transaction: transaction,
              categoryIcon: category.icon,
              categoryColor: category.color,
              onTap: () {},
              onEdit: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit transaction')),
                );
              },
              onDelete: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Delete transaction')),
                );
              },
            );
          },
        ),

        const SizedBox(height: Spacing.sm),
      ],
    );
  }

  List<Transaction> _getFilteredTransactions() {
    if (_selectedFilter == 'Income') {
      return SampleData.transactions
          .where((t) => t.type == TransactionType.income)
          .toList();
    } else if (_selectedFilter == 'Expense') {
      return SampleData.transactions
          .where((t) => t.type == TransactionType.expense)
          .toList();
    }
    return SampleData.transactions;
  }

  List<Map<String, dynamic>> _groupTransactionsByDate(
    List<Transaction> transactions,
  ) {
    final Map<String, List<Transaction>> grouped = {};

    for (var transaction in transactions) {
      final dateKey = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      ).toIso8601String();

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    // Convert to list and sort by date (newest first)
    final result = grouped.entries.map((entry) {
      return {'date': DateTime.parse(entry.key), 'transactions': entry.value};
    }).toList();

    result.sort(
      (a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime),
    );

    return result;
  }
}
