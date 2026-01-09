import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';
import '../../core/data/sample_data.dart';
import '../../core/models/loan.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';

/// Loans Screen - Track borrowed and lent money
/// Demonstrates dual-category organization
class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loansTaken = SampleData.loans.where((l) => l.isTaken).toList();
    final loansGiven = SampleData.loans.where((l) => l.isGiven).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Borrowed (${loansTaken.length})'),
            Tab(text: 'Lent (${loansGiven.length})'),
          ],
        ),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLoanList(loansTaken, LoanType.taken),
          _buildLoanList(loansGiven, LoanType.given),
        ],
      ),
    );
  }

  Widget _buildLoanList(List<Loan> loans, LoanType type) {
    final theme = Theme.of(context);

    if (loans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == LoanType.taken
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: Spacing.md),
            Text(
              type == LoanType.taken ? 'No borrowed money' : 'No lent money',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.md),
      itemCount: loans.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.md),
      itemBuilder: (context, index) {
        final loan = loans[index];
        return _buildLoanCard(loan);
      },
    );
  }

  Widget _buildLoanCard(Loan loan) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: () {},
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
                  Expanded(
                    child: Text(
                      loan.name,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (loan.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.sm,
                        vertical: Spacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.incomeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Corners.sm),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: IconSizes.sm,
                            color: AppTheme.incomeColor,
                          ),
                          const SizedBox(width: Spacing.xs),
                          Text(
                            'Completed',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTheme.incomeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              if (loan.notes != null) ...[
                const SizedBox(height: Spacing.xs),
                Text(loan.notes!, style: theme.textTheme.bodySmall),
              ],

              const SizedBox(height: Spacing.md),

              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(Corners.sm),
                child: LinearProgressIndicator(
                  value: (loan.percentage / 100).clamp(0.0, 1.0),
                  backgroundColor: colorScheme.surfaceContainerLow,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    loan.isCompleted
                        ? AppTheme.incomeColor
                        : colorScheme.primary,
                  ),
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
                      Text('Total Amount', style: theme.textTheme.labelSmall),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        FormatUtils.currency(loan.totalAmount),
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        loan.isCompleted ? 'Paid' : 'Remaining',
                        style: theme.textTheme.labelSmall,
                      ),
                      const SizedBox(height: Spacing.xs),
                      Text(
                        FormatUtils.currency(
                          loan.isCompleted
                              ? loan.totalAmount
                              : loan.remainingAmount,
                        ),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: loan.isCompleted
                              ? AppTheme.incomeColor
                              : AppTheme.expenseColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: Spacing.md),

              // Due date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: IconSizes.sm,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(
                    'Due: ${FormatUtils.date(loan.dueDate)}',
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
}
