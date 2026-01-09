# Quick Start Guide

## 🚀 Getting Started in 5 Minutes

### Step 1: Install Dependencies

```bash
cd e:\Z personal\Flutter\expense_tracker_ui
flutter pub get
```

### Step 2: Run the App

```bash
# For web (easiest)
flutter run -d chrome

# For mobile (with device/emulator)
flutter run
```

### Step 3: Explore the Code

Open `lib/main.dart` and start exploring!

## 📚 Learning Path

### Day 1: Understand the Structure

1. Read `README.md` for project overview
2. Explore `lib/core/theme/app_theme.dart` to see theming
3. Look at `lib/core/constants/spacing.dart` for design tokens
4. Check `lib/core/models/` to understand data structures

### Day 2: Study Components

1. Open `lib/widgets/cards/account_card.dart`
2. Understand how props are passed
3. See how the design system is used
4. Study `lib/widgets/list_items/transaction_list_item.dart` for more complex example

### Day 3: Explore Screens

1. Start with `lib/screens/dashboard/dashboard_screen.dart`
2. See how components are composed
3. Study layout patterns (Column, Row, ListView)
4. Check other screens to see different patterns

### Day 4: Navigation & State

1. Examine `lib/app/expense_tracker_app.dart`
2. Understand bottom navigation
3. See how screens are switched
4. Study state management in `TransactionsScreen`

### Day 5: Customize & Extend

1. Change colors in `app_theme.dart`
2. Modify spacing constants
3. Add a new screen
4. Create a new component

## 🎨 Common Customizations

### Change Primary Color

**File:** `lib/core/theme/app_theme.dart`

```dart
// Find this line (around line 28)
static const Color _primary = Color(0xFF6366F1);

// Change to your color, e.g., purple:
static const Color _primary = Color(0xFF9333EA);
```

### Change Spacing

**File:** `lib/core/constants/spacing.dart`

```dart
// Modify any spacing value
static const double md = 16.0;  // Change to 20.0 for more space
```

### Add Sample Transaction

**File:** `lib/core/data/sample_data.dart`

```dart
// In the transactions list, add:
Transaction(
  id: 't13',
  title: 'Coffee',
  amount: 5.50,
  type: TransactionType.expense,
  category: 'food',
  subcategory: 'Coffee',
  account: 'acc4',
  date: DateTime.now(),
),
```

### Change App Name

**File:** `lib/main.dart`

```dart
// Find this line
title: 'Expense Tracker',

// Change to:
title: 'My Finance App',
```

## 🔧 Common Tasks

### Task 1: Add a New Category

**Step 1:** Open `lib/core/data/sample_data.dart`

**Step 2:** Add to `expenseCategories` list:

```dart
const Category(
  id: 'pets',
  name: 'Pets',
  icon: Icons.pets,
  color: Color(0xFFEC4899),
  subcategories: ['Food', 'Vet', 'Toys'],
),
```

### Task 2: Create a Simple Widget

**Step 1:** Create `lib/widgets/cards/stat_card.dart`

**Step 2:** Add code:

```dart
import 'package:flutter/material.dart';
import '../../core/constants/spacing.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.md),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: Spacing.sm),
            Text(label, style: theme.textTheme.bodySmall),
            const SizedBox(height: Spacing.xs),
            Text(value, style: theme.textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
```

**Step 3:** Use it in a screen:

```dart
StatCard(
  label: 'Total Spent',
  value: '\$1,234',
  icon: Icons.trending_down,
  color: Colors.red,
)
```

### Task 3: Add Navigation to New Screen

**Step 1:** Create screen in `lib/screens/reports/reports_screen.dart`

**Step 2:** Add to drawer in `lib/app/expense_tracker_app.dart`:

```dart
ListTile(
  leading: const Icon(Icons.bar_chart),
  title: const Text('Reports'),
  onTap: () {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReportsScreen(),
      ),
    );
  },
),
```

### Task 4: Modify Card Appearance

**Example:** Make AccountCard rounded

In `lib/widgets/cards/account_card.dart`, find the `Card` widget and modify:

```dart
Card(
  clipBehavior: Clip.antiAlias,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Corners.xl),  // Changed from lg
  ),
  child: InkWell(
    // ... rest of code
  ),
)
```

### Task 5: Add Filter to Transactions

Already implemented! Check `lib/screens/transactions/transactions_screen.dart`.

To add more filters:

```dart
// Add to _filters list
final List<String> _filters = ['All', 'Income', 'Expense', 'Today', 'This Week'];

// Add logic in _getFilteredTransactions()
if (_selectedFilter == 'Today') {
  final today = DateTime.now();
  return SampleData.transactions.where((t) =>
    t.date.day == today.day &&
    t.date.month == today.month &&
    t.date.year == today.year
  ).toList();
}
```

## 💡 Tips & Tricks

### Hot Reload

Press `r` in the terminal while app is running to see changes instantly!

### Hot Restart

Press `R` (capital R) to fully restart the app.

### Debug Mode

Press `p` to show widget boundaries and see layout visually.

### Format Code

```bash
flutter format lib/
```

### Check for Issues

```bash
flutter analyze
```

## 🐛 Troubleshooting

### Problem: "Package not found"

**Solution:**

```bash
flutter pub get
flutter clean
flutter pub get
```

### Problem: "Widget not showing"

**Solution:**

1. Check if widget is in the widget tree
2. Verify it's not behind another widget
3. Check its size constraints
4. Use `Container(color: Colors.red)` to see boundaries

### Problem: "Layout overflow"

**Solution:**

1. Wrap content in `SingleChildScrollView`
2. Use `Expanded` or `Flexible` for dynamic sizing
3. Check for fixed sizes that might not fit

### Problem: "State not updating"

**Solution:**

1. Make sure you're using `setState(() { })`
2. Verify the widget is `StatefulWidget`, not `StatelessWidget`
3. Check that you're modifying the state variable

## 📖 Code Reading Checklist

When reading any widget code, ask:

1. **Is it Stateless or Stateful?**

   - Stateless = doesn't change
   - Stateful = can change

2. **What are its properties?**

   - Look at the `final` fields
   - These are passed from parent

3. **How is it laid out?**

   - Column = vertical
   - Row = horizontal
   - Stack = layered

4. **What can it do?**

   - Look for `onTap`, `onPressed` callbacks
   - Check for navigation calls

5. **How does it get its style?**
   - Theme from context
   - Design tokens (Spacing, Corners)
   - Direct values

## 🎯 Practice Exercises

### Beginner

**Exercise 1:** Change the primary color to your favorite color
**Exercise 2:** Add your name to the drawer header
**Exercise 3:** Change the currency symbol from $ to your currency
**Exercise 4:** Add a new sample transaction

### Intermediate

**Exercise 5:** Create a new category with icon and color
**Exercise 6:** Add a date range filter to transactions
**Exercise 7:** Create a simple statistics widget
**Exercise 8:** Modify the dashboard balance card design

### Advanced

**Exercise 9:** Create a new screen for analytics
**Exercise 10:** Implement search functionality in transactions
**Exercise 11:** Add sorting options to budgets
**Exercise 12:** Create an "Add Transaction" form screen

## 📚 Additional Resources

### Flutter Documentation

- [Flutter.dev](https://flutter.dev)
- [Widget Catalog](https://flutter.dev/docs/development/ui/widgets)
- [Material Design](https://m3.material.io)

### Video Tutorials

- Search YouTube for "Flutter UI Tutorial"
- Look for "Flutter Material 3" guides
- Check out "Flutter Widget of the Week"

### Practice

- Modify this app daily
- Try to break it and fix it
- Implement new features
- Compare with other finance apps

## ✅ Daily Checklist for Learning

**Week 1: Exploration**

- [ ] Day 1: Run the app and explore all screens
- [ ] Day 2: Read through all model files
- [ ] Day 3: Study one widget component in detail
- [ ] Day 4: Understand the theme system
- [ ] Day 5: Modify colors and spacing
- [ ] Day 6-7: Review and practice

**Week 2: Modification**

- [ ] Day 1: Change app colors completely
- [ ] Day 2: Add a new category
- [ ] Day 3: Modify a widget component
- [ ] Day 4: Create a simple new widget
- [ ] Day 5: Add navigation to a new screen
- [ ] Day 6-7: Review and practice

**Week 3: Creation**

- [ ] Day 1: Create a new screen
- [ ] Day 2: Create new reusable widgets
- [ ] Day 3: Implement filtering or sorting
- [ ] Day 4: Add forms for input
- [ ] Day 5: Work on layouts
- [ ] Day 6-7: Review and practice

## 🎊 Congratulations!

You now have a production-grade Flutter UI project to learn from. Take your time, experiment freely, and don't be afraid to break things. Every error is a learning opportunity!

**Remember:**

- Start small
- Build incrementally
- Ask questions (Google, Stack Overflow, Flutter Discord)
- Practice daily
- Have fun!

Happy coding! 🚀
