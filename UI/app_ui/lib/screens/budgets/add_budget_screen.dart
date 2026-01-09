import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/spacing.dart';
import '../../core/data/sample_data.dart';
import '../../core/theme/app_theme.dart';

/// Add Budget Screen - Create new budget with limits and alerts
class AddBudgetScreen extends StatefulWidget {
  const AddBudgetScreen({super.key});

  @override
  State<AddBudgetScreen> createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String _budgetType = 'monthly';
  String? _selectedCategoryId;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  double _alertThreshold = 80.0;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _updateDatesBasedOnType() {
    setState(() {
      _startDate = DateTime.now();
      if (_budgetType == 'monthly') {
        _endDate = DateTime(
          _startDate.year,
          _startDate.month + 1,
          0,
        ); // Last day of month
      } else if (_budgetType == 'yearly') {
        _endDate = DateTime(_startDate.year, 12, 31);
      }
      // For custom, user picks dates
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Budget'),
        actions: [
          TextButton(onPressed: _saveBudget, child: const Text('Save')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Budget Name
              Text('Budget Name', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'e.g., June Food Budget',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter budget name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: Spacing.lg),

              // Budget Amount
              Text('Budget Amount', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  hintText: '0.00',
                  border: OutlineInputBorder(),
                  prefixText: '\$ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: Spacing.lg),

              // Budget Type
              Text('Budget Period', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'monthly',
                    label: Text('Monthly'),
                    icon: Icon(Icons.calendar_month),
                  ),
                  ButtonSegment(
                    value: 'yearly',
                    label: Text('Yearly'),
                    icon: Icon(Icons.calendar_today),
                  ),
                  ButtonSegment(
                    value: 'custom',
                    label: Text('Custom'),
                    icon: Icon(Icons.date_range),
                  ),
                ],
                selected: {_budgetType},
                onSelectionChanged: (Set<String> selected) {
                  setState(() {
                    _budgetType = selected.first;
                    _updateDatesBasedOnType();
                  });
                },
              ),

              const SizedBox(height: Spacing.lg),

              // Category Selection
              Text('Category (Optional)', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              InkWell(
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
                      if (_selectedCategoryId != null) ...[
                        _buildCategoryIcon(),
                        const SizedBox(width: Spacing.md),
                        Expanded(
                          child: Text(
                            _getSelectedCategoryName(),
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
                            'All categories',
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
              ),

              const SizedBox(height: Spacing.lg),

              // Date Range
              Text('Date Range', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _buildDateSelector(
                      context,
                      'Start Date',
                      _startDate,
                      (date) => setState(() => _startDate = date),
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  const Icon(Icons.arrow_forward),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: _buildDateSelector(
                      context,
                      'End Date',
                      _endDate,
                      (date) => setState(() => _endDate = date),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: Spacing.lg),

              // Alert Threshold
              Text('Alert Threshold', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Alert me at ${_alertThreshold.toInt()}% of budget',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Spacing.sm,
                              vertical: Spacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.warningColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(Corners.sm),
                            ),
                            child: Text(
                              '${_alertThreshold.toInt()}%',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppTheme.warningColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.sm),
                      Slider(
                        value: _alertThreshold,
                        min: 50,
                        max: 100,
                        divisions: 10,
                        label: '${_alertThreshold.toInt()}%',
                        onChanged: (value) {
                          setState(() => _alertThreshold = value);
                        },
                      ),
                      Text(
                        '  You\'ll be notified when spending reaches this percentage',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: Spacing.lg),

              // Notes
              Text('Notes (Optional)', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  hintText: 'Add notes about this budget...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: Spacing.xxl),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveBudget,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  ),
                  child: const Text('Create Budget'),
                ),
              ),

              const SizedBox(height: Spacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    String label,
    DateTime date,
    Function(DateTime) onDateSelected,
  ) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      borderRadius: BorderRadius.circular(Corners.md),
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(Corners.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelSmall),
            const SizedBox(height: 4),
            Text(
              '${date.month}/${date.day}/${date.year}',
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    if (_selectedCategoryId == null) return const SizedBox();

    final category = SampleData.expenseCategories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => SampleData.expenseCategories.first,
    );

    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: category.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Corners.sm),
      ),
      child: Icon(category.icon, color: category.color, size: IconSizes.lg),
    );
  }

  String _getSelectedCategoryName() {
    if (_selectedCategoryId == null) return 'All categories';

    final category = SampleData.expenseCategories.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => SampleData.expenseCategories.first,
    );

    return category.name;
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

            // All categories option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(Spacing.sm),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Corners.sm),
                ),
                child: Icon(
                  Icons.category_outlined,
                  color: theme.colorScheme.primary,
                ),
              ),
              title: const Text('All Categories'),
              subtitle: const Text('Track all spending'),
              trailing: _selectedCategoryId == null
                  ? Icon(Icons.check, color: theme.colorScheme.primary)
                  : null,
              onTap: () {
                setState(() => _selectedCategoryId = null);
                Navigator.pop(context);
              },
            ),

            const Divider(),

            // Individual categories
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: Spacing.sm,
                  mainAxisSpacing: Spacing.sm,
                  childAspectRatio: 1,
                ),
                itemCount: SampleData.expenseCategories.length,
                itemBuilder: (context, index) {
                  final category = SampleData.expenseCategories[index];
                  final isSelected = _selectedCategoryId == category.id;

                  return InkWell(
                    onTap: () {
                      setState(() => _selectedCategoryId = category.id);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(Corners.md),
                    child: Container(
                      padding: const EdgeInsets.all(Spacing.sm),
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(Corners.md),
                        border: Border.all(
                          color: isSelected
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

  void _saveBudget() {
    if (_formKey.currentState!.validate()) {
      // Here you would save to database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Budget "${_nameController.text}" created for \$${_amountController.text}',
          ),
          backgroundColor: AppTheme.savingsColor,
        ),
      );

      Navigator.pop(context);
    }
  }
}
