import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';
import '../../core/data/sample_data.dart';
import '../../widgets/cards/savings_goal_card.dart';

/// Savings Goals Screen - Track savings progress
/// Demonstrates target-based progress tracking
class SavingsGoalsScreen extends StatelessWidget {
  const SavingsGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: SampleData.savingsGoals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.savings_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: Spacing.md),
                  Text(
                    'No savings goals yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: Spacing.sm),
                  Text(
                    'Create a goal to start saving',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: Spacing.lg),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('Create Goal'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(Spacing.md),
              itemCount: SampleData.savingsGoals.length,
              separatorBuilder: (_, __) => const SizedBox(height: Spacing.md),
              itemBuilder: (context, index) {
                final goal = SampleData.savingsGoals[index];
                return SavingsGoalCard(
                  name: goal.name,
                  targetAmount: goal.targetAmount,
                  savedAmount: goal.savedAmount,
                  deadline: goal.deadline,
                  percentage: goal.percentage,
                  emoji: goal.emoji,
                  onTap: () {},
                );
              },
            ),
    );
  }
}
