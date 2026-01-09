import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';
import '../../core/data/sample_data.dart';
import '../../core/models/account.dart';
import 'add_account_screen.dart';

/// Accounts Screen - View all financial accounts
/// Demonstrates categorized list views
class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddAccountScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(Spacing.md),
        itemCount: SampleData.accounts.length,
        separatorBuilder: (_, __) => const SizedBox(height: Spacing.md),
        itemBuilder: (context, index) {
          final account = SampleData.accounts[index];
          return _buildAccountCard(context, account);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAccountScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAccountCard(BuildContext context, Account account) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(Corners.card),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Corners.md),
                ),
                child: Icon(
                  _getAccountIcon(account.type),
                  color: colorScheme.primary,
                  size: IconSizes.lg,
                ),
              ),

              const SizedBox(width: Spacing.md),

              // Account details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Text(account.typeLabel, style: theme.textTheme.bodySmall),
                    if (account.accountNumber != null) ...[
                      const SizedBox(height: Spacing.xs),
                      Text(
                        account.accountNumber!,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: Spacing.sm),

              // Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${account.balance.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text('Balance', style: theme.textTheme.labelSmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
