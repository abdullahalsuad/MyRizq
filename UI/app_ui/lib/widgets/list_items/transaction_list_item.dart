import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';
import '../../core/models/transaction.dart';
import '../../core/utils/format_utils.dart';
import '../../core/theme/app_theme.dart';

/// Transaction list item component
/// Shows clear visual distinction between income and expense
class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final IconData categoryIcon;
  final Color categoryColor;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.categoryIcon,
    required this.categoryColor,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncome = transaction.type == TransactionType.income;

    return Dismissible(
      key: Key(transaction.id),
      background: _buildSwipeBackground(
        context,
        alignment: Alignment.centerLeft,
        color: Colors.blue,
        icon: Icons.edit,
      ),
      secondaryBackground: _buildSwipeBackground(
        context,
        alignment: Alignment.centerRight,
        color: AppTheme.expenseColor,
        icon: Icons.delete,
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEdit?.call();
          return false;
        } else {
          onDelete?.call();
          return false;
        }
      },
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          child: Row(
            children: [
              // Category icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Corners.md),
                ),
                child: Icon(
                  categoryIcon,
                  color: categoryColor,
                  size: IconSizes.lg,
                ),
              ),

              const SizedBox(width: Spacing.md),

              // Transaction details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: Spacing.xs),
                    Row(
                      children: [
                        Text(
                          transaction.category,
                          style: theme.textTheme.bodySmall,
                        ),
                        if (transaction.subcategory != null) ...[
                          Text(
                            ' • ${transaction.subcategory}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: Spacing.sm),

              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isIncome ? '+' : '-'}${FormatUtils.currency(transaction.amount)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isIncome
                          ? AppTheme.incomeColor
                          : AppTheme.expenseColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: Spacing.xs),
                  Text(
                    FormatUtils.relativeDate(transaction.date),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(
    BuildContext context, {
    required Alignment alignment,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      color: color,
      child: Icon(icon, color: Colors.white, size: IconSizes.lg),
    );
  }
}
