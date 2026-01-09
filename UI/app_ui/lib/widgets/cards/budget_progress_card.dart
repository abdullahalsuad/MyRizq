import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';
import '../../core/theme/app_theme.dart';

/// Budget progress card component
/// Visual indicator for budget tracking with warning states
class BudgetProgressCard extends StatelessWidget {
  final String category;
  final double limit;
  final double spent;
  final double percentage;
  final bool isExceeded;
  final bool isNearLimit;
  final VoidCallback? onTap;

  const BudgetProgressCard({
    super.key,
    required this.category,
    required this.limit,
    required this.spent,
    required this.percentage,
    this.isExceeded = false,
    this.isNearLimit = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = limit - spent;

    Color progressColor;
    if (isExceeded) {
      progressColor = AppTheme.expenseColor;
    } else if (isNearLimit) {
      progressColor = AppTheme.warningColor;
    } else {
      progressColor = theme.colorScheme.primary;
    }

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category, style: theme.textTheme.titleMedium),
                  if (isExceeded)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.expenseColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Corners.sm),
                      ),
                      child: Text(
                        'Exceeded',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.expenseColor,
                          fontWeight: FontWeight.w600,
                        ),
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
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  minHeight: 8,
                ),
              ),

              const SizedBox(height: Spacing.md),

              // Amounts
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Spent', style: theme.textTheme.labelSmall),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        '\$${spent.toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: progressColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        isExceeded ? 'Over Budget' : 'Remaining',
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        '\$${remaining.abs().toStringAsFixed(2)}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: isExceeded
                              ? AppTheme.expenseColor
                              : theme.textTheme.bodyLarge?.color,
                        ),
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
