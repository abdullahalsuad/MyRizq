import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/spacing.dart';
import '../../core/models/account.dart';
import '../../core/theme/app_theme.dart';

/// Add Account Screen - Create new financial account
class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _cardLast4Controller = TextEditingController();
  final _creditLimitController = TextEditingController();
  final _walletIdentifierController = TextEditingController();
  final _locationController = TextEditingController();

  AccountType _selectedType = AccountType.bank;
  String _selectedCurrency = 'USD';
  String _cardType = 'credit';
  String _cardNetwork = 'visa';
  String _walletProvider = 'paypal';

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'BDT', 'INR'];

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _accountNumberController.dispose();
    _bankNameController.dispose();
    _cardLast4Controller.dispose();
    _creditLimitController.dispose();
    _walletIdentifierController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
        actions: [
          TextButton(onPressed: _saveAccount, child: const Text('Save')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Type Selection
              Text('Account Type', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              _buildAccountTypeSelector(),

              const SizedBox(height: Spacing.lg),

              // Account Name
              Text('Account Name', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: _getNameHint(),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: Spacing.lg),

              // Initial Balance
              Text('Initial Balance', style: theme.textTheme.titleSmall),
              const SizedBox(height: Spacing.sm),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _balanceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        hintText: '0.00',
                        border: OutlineInputBorder(),
                        prefixText: '\$ ',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter balance';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCurrency,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: _currencies.map((currency) {
                        return DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedCurrency = value);
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: Spacing.lg),

              // Type-specific fields
              ..._buildTypeSpecificFields(),

              const SizedBox(height: Spacing.xxl),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAccount,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: Spacing.md),
                  ),
                  child: const Text('Create Account'),
                ),
              ),

              const SizedBox(height: Spacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountTypeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AccountType.values.map((type) {
          final isSelected = _selectedType == type;
          return Padding(
            padding: const EdgeInsets.only(right: Spacing.sm),
            child: ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForType(type),
                    size: 18,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : null,
                  ),
                  const SizedBox(width: Spacing.xs),
                  Text(_getTypeLabelAccount(type)),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedType = type);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildTypeSpecificFields() {
    final theme = Theme.of(context);

    switch (_selectedType) {
      case AccountType.bank:
        return [
          // Bank Name
          Text('Bank Name', style: theme.textTheme.titleSmall),
          const SizedBox(height: Spacing.sm),
          TextFormField(
            controller: _bankNameController,
            decoration: const InputDecoration(
              hintText: 'e.g., Chase Bank',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: Spacing.lg),

          // Account Number
          Text('Account Number (Optional)', style: theme.textTheme.titleSmall),
          const SizedBox(height: Spacing.sm),
          TextFormField(
            controller: _accountNumberController,
            decoration: const InputDecoration(
              hintText: 'Last 4 digits: ****1234',
              border: OutlineInputBorder(),
              prefixText: '****',
            ),
            keyboardType: TextInputType.number,
            maxLength: 4,
          ),
        ];

      case AccountType.card:
        return [
          // Card Type
          Text('Card Type', style: theme.textTheme.titleSmall),
          const SizedBox(height: Spacing.sm),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'credit', label: Text('Credit')),
              ButtonSegment(value: 'debit', label: Text('Debit')),
              ButtonSegment(value: 'prepaid', label: Text('Prepaid')),
            ],
            selected: {_cardType},
            onSelectionChanged: (selected) {
              setState(() => _cardType = selected.first);
            },
          ),
          const SizedBox(height: Spacing.lg),

          // Card Network
          Text('Card Network', style: theme.textTheme.titleSmall),
          const SizedBox(height: Spacing.sm),
          Wrap(
            spacing: Spacing.sm,
            children: ['visa', 'mastercard', 'amex', 'discover'].map((network) {
              return ChoiceChip(
                label: Text(network.toUpperCase()),
                selected: _cardNetwork == network,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _cardNetwork = network);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: Spacing.lg),

          // Last 4 digits
          Text('Card Last 4 Digits', style: theme.textTheme.titleSmall),
          const SizedBox(height: Spacing.sm),
          TextFormField(
            controller: _cardLast4Controller,
            decoration: const InputDecoration(
              hintText: '4532',
              border: OutlineInputBorder(),
              prefixText: '****',
            ),
            keyboardType: TextInputType.number,
            maxLength: 4,
            validator: (value) {
              if (value != null && value.isNotEmpty && value.length != 4) {
                return 'Must be 4 digits';
              }
              return null;
            },
          ),
          const SizedBox(height: Spacing.lg),

          // Credit Limit (for credit cards)
          if (_cardType == 'credit') ...[
            Text('Credit Limit (Optional)', style: theme.textTheme.titleSmall),
            const SizedBox(height: Spacing.sm),
            TextFormField(
              controller: _creditLimitController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                hintText: '10000.00',
                border: OutlineInputBorder(),
                prefixText: '\$ ',
              ),
            ),
          ],
        ];

      case AccountType.wallet:
        return [
          // Wallet Provider
          Text('Wallet Provider', style: theme.textTheme.titleSmall),
          const SizedBox(height: Spacing.sm),
          Wrap(
            spacing: Spacing.sm,
            runSpacing: Spacing.sm,
            children: ['paypal', 'venmo', 'cashapp', 'google_pay', 'apple_pay']
                .map((provider) {
                  return ChoiceChip(
                    label: Text(_formatProviderName(provider)),
                    selected: _walletProvider == provider,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _walletProvider = provider);
                      }
                    },
                  );
                })
                .toList(),
          ),
          const SizedBox(height: Spacing.lg),

          // Wallet Identifier
          Text('Email/Phone/Username', style: theme.textTheme.titleSmall),
          const SizedBox(height: Spacing.sm),
          TextFormField(
            controller: _walletIdentifierController,
            decoration: const InputDecoration(
              hintText: 'john@example.com or +1234567890',
              border: OutlineInputBorder(),
            ),
          ),
        ];

      case AccountType.cash:
        return [
          // Location
          Text('Cash Location', style: theme.textTheme.titleSmall),
          const SizedBox(height: Spacing.sm),
          Wrap(
            spacing: Spacing.sm,
            children: ['Wallet', 'Safe', 'Drawer', 'Other'].map((location) {
              return ChoiceChip(
                label: Text(location),
                selected: _locationController.text == location,
                onSelected: (selected) {
                  if (selected) {
                    setState(() => _locationController.text = location);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: Spacing.sm),
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              hintText: 'Or type custom location',
              border: OutlineInputBorder(),
            ),
          ),
        ];

      case AccountType.savings:
        return [
          Card(
            color: AppTheme.savingsColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Row(
                children: [
                  Icon(Icons.savings_outlined, color: AppTheme.savingsColor),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Text(
                      'Dedicated savings account for financial goals',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
    }
  }

  String _getNameHint() {
    switch (_selectedType) {
      case AccountType.bank:
        return 'e.g., Main Checking Account';
      case AccountType.card:
        return 'e.g., Chase Sapphire Card';
      case AccountType.wallet:
        return 'e.g., PayPal Business';
      case AccountType.cash:
        return 'e.g., Wallet Cash';
      case AccountType.savings:
        return 'e.g., Emergency Fund';
    }
  }

  IconData _getIconForType(AccountType type) {
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

  String _getTypeLabelAccount(AccountType type) {
    switch (type) {
      case AccountType.bank:
        return 'Bank';
      case AccountType.card:
        return 'Card';
      case AccountType.wallet:
        return 'Wallet';
      case AccountType.cash:
        return 'Cash';
      case AccountType.savings:
        return 'Savings';
    }
  }

  String _formatProviderName(String provider) {
    return provider
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  void _saveAccount() {
    if (_formKey.currentState!.validate()) {
      // Here you would save to database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_getTypeLabelAccount(_selectedType)} account "${_nameController.text}" created',
          ),
          backgroundColor: AppTheme.savingsColor,
        ),
      );

      Navigator.pop(context);
    }
  }
}
