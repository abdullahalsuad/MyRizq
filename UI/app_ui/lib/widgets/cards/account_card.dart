import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';

/// Reusable account card component
/// Demonstrates component-driven design with consistent styling
class AccountCard extends StatelessWidget {
  final String name;
  final String type;
  final double balance;
  final String? accountNumber;
  final IconData icon;
  final VoidCallback? onTap;

  const AccountCard({
    super.key,
    required this.name,
    required this.type,
    required this.balance,
    this.accountNumber,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 180,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Corners.md),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.primary,
                    size: IconSizes.lg,
                  ),
                ),

                const SizedBox(height: Spacing.sm),

                // Account type
                Text(
                  type,
                  style: theme.textTheme.labelSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 2),

                // Account name
                Text(
                  name,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: Spacing.sm),

                // Balance
                Text(
                  '\$${balance.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                if (accountNumber != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    accountNumber!,
                    style: theme.textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
