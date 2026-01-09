import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';
import '../../core/data/sample_data.dart';
import '../../widgets/cards/budget_progress_card.dart';
import 'add_budget_screen.dart';

/// Budgets Screen - Track spending limits
/// Demonstrates progress indicators and warning states
class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddBudgetScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SampleData.budgets.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pie_chart_outline,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    'No budgets yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    'Create a budget to track your spending',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddBudgetScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Budget'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: SampleData.budgets.length,
              separatorBuilder: (_, __) => const SizedBox(height: Spacing.md),
              itemBuilder: (context, index) {
                final budget = SampleData.budgets[index];
                return BudgetProgressCard(
                  category: budget.category,
                  limit: budget.limit,
                  spent: budget.spent,
                  percentage: budget.percentage,
                  isExceeded: budget.isExceeded,
                  isNearLimit: budget.isNearLimit,
                  onTap: () {},
                );
              },
            ),
    );
  }
}
