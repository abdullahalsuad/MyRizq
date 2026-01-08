import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/spacing.dart';
import '../../core/data/sample_data.dart';
import '../../core/models/category.dart';
import '../../core/models/transaction.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';

/// Add Transaction Screen - Form to create new transactions
/// Demonstrates form handling, input validation, and bottom sheets
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  TransactionType _transactionType = TransactionType.expense;
  Category? _selectedCategory;
  String? _selectedSubcategory;
  String _selectedAccount = 'acc1';
  DateTime _selectedDate = DateTime.now();

  List<Category> get _availableCategories {
    return _transactionType == TransactionType.expense
        ? SampleData.expenseCategories
        : SampleData.incomeCategories;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        actions: [
          TextButton(onPressed: _saveTransaction, child: const Text('Save')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input (Large)
              _buildAmountInput(theme),

              const SizedBox(height: Spacing.xl),

              // Transaction Type Toggle
              Text('Transaction Type', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              _buildTypeSelector(theme),

              const SizedBox(height: Spacing.lg),

              // Category Selector
              Text('Category', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              _buildCategorySelector(theme),

              if (_selectedCategory != null &&
                  _selectedCategory!.subcategories.isNotEmpty) ...[
                const SizedBox(height: Spacing.md),
                Text('Subcategory', style: theme.textTheme.titleSmall),
                const SizedBox(height: Spacing.sm),
                _buildSubcategorySelector(theme),
              ],

              const SizedBox(height: Spacing.lg),

              // Account Selector
              Text('Account', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              _buildAccountSelector(theme),

              const SizedBox(height: Spacing.lg),

              // Date Picker
              Text('Date', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              _buildDateSelector(theme),

              const SizedBox(height: Spacing.lg),

              // Notes Input
              Text('Notes (Optional)', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Add notes...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: Spacing.xxl),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  ),
                  child: const Text('Add Transaction'),
                ),
              ),

              const SizedBox(height: Spacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInput(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: _transactionType == TransactionType.income
            ? AppTheme.incomeColor.withOpacity(0.1)
            : AppTheme.expenseColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Corners.lg),
        border: Border.all(
          color: _transactionType == TransactionType.income
              ? AppTheme.incomeColor.withOpacity(0.3)
              : AppTheme.expenseColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Amount',
            style: theme.textTheme.titleMedium?.copyWith(
              color: _transactionType == TransactionType.income
                  ? AppTheme.incomeColor
                  : AppTheme.expenseColor,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '\$',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: _transactionType == TransactionType.income
                        ? AppTheme.incomeColor
                        : AppTheme.expenseColor,
                  ),
                ),
              ),
              const SizedBox(width: Spacing.sm),
              Expanded(
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: _transactionType == TransactionType.income
                        ? AppTheme.incomeColor
                        : AppTheme.expenseColor,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Amount must be greater than 0';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildTypeButton(
            theme,
            'Expense',
            TransactionType.expense,
            Icons.arrow_upward,
            AppTheme.expenseColor,
          ),
        ),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: _buildTypeButton(
            theme,
            'Income',
            TransactionType.income,
            Icons.arrow_downward,
            AppTheme.incomeColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeButton(
    ThemeData theme,
    String label,
    TransactionType type,
    IconData icon,
    Color color,
  ) {
    final isSelected = _transactionType == type;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          _transactionType = type;
          _selectedCategory = null;
          _selectedSubcategory = null;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? color.withOpacity(0.1) : null,
        side: BorderSide(
          color: isSelected ? color : theme.colorScheme.outline,
          width: isSelected ? 2 : 1,
        ),
        padding: const EdgeInsets.symmetric(vertical: Spacing.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? color : theme.colorScheme.onSurface),
          const SizedBox(width: Spacing.sm),
          Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: isSelected ? color : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector(ThemeData theme) {
    return InkWell(
      onTap: () => _showCategoryPicker(context),
      borderRadius: BorderRadius.circular(Corners.md),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(Corners.md),
        ),
        child: Row(
          children: [
            if (_selectedCategory != null) ...[
              Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: _selectedCategory!.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Corners.sm),
                ),
                child: Icon(
                  _selectedCategory!.icon,
                  color: _selectedCategory!.color,
                  size: IconSizes.lg,
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Text(
                  _selectedCategory!.name,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ] else ...[
              Icon(
                Icons.category_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Text(
                  'Select category',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategorySelector(ThemeData theme) {
    return Wrap(
      spacing: Spacing.sm,
      runSpacing: Spacing.sm,
      children: _selectedCategory!.subcategories.map((sub) {
        final isSelected = _selectedSubcategory == sub;
        return ChoiceChip(
          label: Text(sub),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _selectedSubcategory = selected ? sub : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildAccountSelector(ThemeData theme) {
    final selectedAccount = SampleData.accounts.firstWhere(
      (acc) => acc.id == _selectedAccount,
    );

    return InkWell(
      onTap: () => _showAccountPicker(context),
      borderRadius: BorderRadius.circular(Corners.md),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(Corners.md),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(Corners.sm),
              ),
              child: Icon(
                Icons.account_balance_wallet,
                color: theme.colorScheme.primary,
                size: IconSizes.lg,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedAccount.name,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    FormatUtils.currency(selectedAccount.balance),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(ThemeData theme) {
    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(Corners.md),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(Corners.md),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                FormatUtils.date(_selectedDate),
                style: theme.textTheme.titleMedium,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryPicker(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select Category', style: theme.textTheme.headlineSmall),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: Spacing.sm,
                  mainAxisSpacing: Spacing.sm,
                  childAspectRatio: 1,
                ),
                itemCount: _availableCategories.length,
                itemBuilder: (context, index) {
                  final category = _availableCategories[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                        _selectedSubcategory = null;
                      });
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(Corners.md),
                    child: Container(
                      padding: const EdgeInsets.all(Spacing.sm),
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Corners.md),
                        border: Border.all(
                          color: _selectedCategory?.id == category.id
                              ? category.color
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category.icon,
                            color: category.color,
                            size: IconSizes.xl,
                          ),
                          const SizedBox(height: Spacing.xs),
                          Text(
                            category.name,
                            style: theme.textTheme.labelSmall,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: Spacing.md),
          ],
        ),
      ),
    );
  }

  void _showAccountPicker(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Account', style: theme.textTheme.headlineSmall),
            const SizedBox(height: Spacing.md),
            ...SampleData.accounts.map((account) {
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(Spacing.sm),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Corners.sm),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: Text(account.name),
                subtitle: Text(FormatUtils.currency(account.balance)),
                trailing: _selectedAccount == account.id
                    ? Icon(Icons.check, color: theme.colorScheme.primary)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedAccount = account.id;
                  });
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: Spacing.md),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')),
        );
        return;
      }

      // Here you would save the transaction to your data store
      // For now, just show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Transaction added: ${_transactionType == TransactionType.income ? '+' : '-'}\$${_amountController.text}',
          ),
          backgroundColor: _transactionType == TransactionType.income
              ? AppTheme.incomeColor
              : AppTheme.expenseColor,
        ),
      );

      Navigator.pop(context);
    }
  }
}
