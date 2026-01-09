import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';
import '../../core/data/sample_data.dart';
import '../../core/models/account.dart';
import '../../core/utils/format_utils.dart';
import '../../widgets/cards/account_card.dart';
import '../../widgets/list_items/transaction_list_item.dart';
import '../add_transaction/add_transaction_screen.dart';

/// Dashboard Screen - Main overview of finances
/// Demonstrates layout hierarchy, card grids, and list views
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  IconData _getAccountIcon(AccountType type) {
    switch (type) {
      case AccountType.bank:
        return Icons.account_balance;
      case AccountType.card:
        return Icons.credit_card;
      case AccountType.wallet:
        return Icons.account_balance_wallet;
      case AccountType.cash:
        return Icons.payments_outlined;
      case AccountType.savings:
        return Icons.savings_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Balance Card
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(Spacing.md),
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [colorScheme.primary, colorScheme.secondary],
                ),
                borderRadius: BorderRadius.circular(Corners.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    FormatUtils.currency(SampleData.totalBalance),
                    style: theme.textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBalanceInfo(
                          context,
                          'Income',
                          SampleData.monthlyIncome,
                          Icons.arrow_downward,
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: _buildBalanceInfo(
                          context,
                          'Expense',
                          SampleData.monthlyExpense,
                          Icons.arrow_upward,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Accounts Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Accounts', style: theme.textTheme.headlineSmall),
                  TextButton(onPressed: () {}, child: const Text('See All')),
                ],
              ),
            ),

            const SizedBox(height: Spacing.sm),

            // Accounts Horizontal List
            SizedBox(
              height: 180,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
                scrollDirection: Axis.horizontal,
                itemCount: SampleData.accounts.length,
                separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
                itemBuilder: (context, index) {
                  final account = SampleData.accounts[index];
                  return AccountCard(
                    name: account.name,
                    type: account.typeLabel,
                    balance: account.balance,
                    accountNumber: account.accountNumber,
                    icon: _getAccountIcon(account.type),
                    onTap: () {},
                  );
                },
              ),
            ),

            const SizedBox(height: Spacing.lg),

            // Recent Transactions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: theme.textTheme.headlineSmall,
                  ),
                  TextButton(onPressed: () {}, child: const Text('See All')),
                ],
              ),
            ),

            const SizedBox(height: Spacing.sm),

            // Recent Transactions List
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5, // Show only 5 recent
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final transaction = SampleData.transactions[index];
                final category = SampleData.expenseCategories.firstWhere(
                  (c) => c.id == transaction.category,
                  orElse: () => SampleData.incomeCategories.firstWhere(
                    (c) => c.id == transaction.category,
                    orElse: () => SampleData.expenseCategories.last,
                  ),
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

            const SizedBox(height: Spacing.lg),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
      ),
    );
  }

  Widget _buildBalanceInfo(
    BuildContext context,
    String label,
    double amount,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(Corners.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: IconSizes.sm),
              const SizedBox(width: Spacing.xs),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.xs),
          Text(
            FormatUtils.currency(amount),
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
