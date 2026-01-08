import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';
import '../../core/theme/app_theme.dart';

/// Savings goal card component
/// Visual progress indicator for savings goals
class SavingsGoalCard extends StatelessWidget {
  final String name;
  final double targetAmount;
  final double savedAmount;
  final DateTime deadline;
  final double percentage;
  final String? emoji;
  final VoidCallback? onTap;

  const SavingsGoalCard({
    super.key,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
    required this.percentage,
    this.emoji,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = targetAmount - savedAmount;
    final isCompleted = savedAmount >= targetAmount;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Corners.card),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  if (emoji != null) ...[
                    Text(emoji!, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: Spacing.sm),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Spacing.xs),
                        Text(
                          'Target: \$${targetAmount.toStringAsFixed(2)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.all(Spacing.sm),
                      decoration: BoxDecoration(
                        color: AppTheme.savingsColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        color: AppTheme.savingsColor,
                        size: IconSizes.md,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: Spacing.md),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(Corners.sm),
                child: LinearProgressIndicator(
                  value: (percentage / 100).clamp(0.0, 1.0),
                  backgroundColor: theme.colorScheme.surfaceContainerLow,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted
                        ? AppTheme.savingsColor
                        : theme.colorScheme.primary,
                  ),
                  minHeight: 8,
                ),
              ),

              const SizedBox(height: Spacing.md),

              // Amounts and progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saved', style: theme.textTheme.labelSmall),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        '\$${savedAmount.toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.savingsColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isCompleted ? 'Completed' : 'Remaining',
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        isCompleted
                            ? '${percentage.toStringAsFixed(0)}%'
                            : '\$${remaining.toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
