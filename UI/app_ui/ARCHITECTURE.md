# Component Architecture Guide

## Overview

This document explains the widget composition and component hierarchy used throughout the Expense Tracker app. Understanding this structure is key to learning Flutter's widget-based architecture.

## Core Principles

### 1. Everything is a Widget

In Flutter, everything from a button to an entire screen is a widget. Widgets are the building blocks of the UI.

### 2. Composition Over Inheritance

Complex UIs are built by composing simple widgets together, not by inheriting from complex base classes.

### 3. Single Responsibility

Each widget should do one thing well. Complex widgets delegate to simpler widgets.

## Widget Hierarchy

```
MaterialApp (Root)
└── ExpenseTrackerApp
    ├── Scaffold
    │   ├── IndexedStack (Body)
    │   │   ├── DashboardScreen
    │   │   ├── TransactionsScreen
    │   │   ├── BudgetsScreen
    │   │   └── AccountsScreen
    │   ├── NavigationBar (Bottom)
    │   └── Drawer (Side Menu)
    └── Theme Data (Material 3)
```

## Screen Anatomy

### Dashboard Screen Structure

```
DashboardScreen
├── Scaffold
│   ├── AppBar
│   │   ├── Title
│   │   └── Actions (Icons)
│   ├── Body: SingleChildScrollView
│   │   └── Column
│   │       ├── Total Balance Card (Container)
│   │       │   ├── Title
│   │       │   ├── Balance Amount
│   │       │   └── Row (Income/Expense)
│   │       │       ├── Income Info Widget
│   │       │       └── Expense Info Widget
│   │       ├── Accounts Section Header
│   │       ├── Horizontal ListView
│   │       │   └── AccountCard (x5)
│   │       ├── Transactions Section Header
│   │       └── Vertical ListView
│   │           └── TransactionListItem (x5)
│   └── FloatingActionButton
```

### Key Learnings:

1. **SingleChildScrollView**: Makes content scrollable
2. **Column**: Arranges children vertically
3. **Row**: Arranges children horizontally
4. **ListView**: Scrollable list (horizontal or vertical)
5. **Card**: Material design card with elevation

## Component Deep Dive

### 1. AccountCard Component

**Purpose**: Display account information in a compact, tappable card.

**Composition:**

```
AccountCard (StatelessWidget)
└── Card
    └── InkWell (for tap effect)
        └── Container (padding)
            └── Column
                ├── Icon Container (decorated)
                │   └── Icon
                ├── Account Type (Text)
                ├── Account Name (Text)
                ├── Spacer (pushes balance to bottom)
                ├── Balance (Text)
                └── Account Number (Text, optional)
```

**Widget Concepts Demonstrated:**

- `StatelessWidget`: Immutable widget
- `final` properties: Passed from parent
- `const` constructor: Performance optimization
- Null safety: Optional `accountNumber?`
- Conditional rendering: `if (accountNumber != null)`

**Layout Concepts:**

- Fixed width (180px)
- Internal padding (Spacing.md = 16px)
- Spacer to push content to bottom
- Text overflow handling

### 2. TransactionListItem Component

**Purpose**: Display a transaction with swipe actions.

**Composition:**

```
TransactionListItem (StatelessWidget)
└── Dismissible (swipe actions)
    └── InkWell (tap effect)
        └── Padding
            └── Row
                ├── Category Icon Container
                │   └── Icon
                ├── Transaction Details (Expanded)
                │   └── Column
                │       ├── Title (Text)
                │       └── Category Info (Row)
                ├── Amount & Date (Column)
                │   ├── Amount (Text, colored)
                │   └── Date (Text)
```

**Advanced Concepts:**

- `Dismissible`: Swipe-to-action widget
- `confirmDismiss`: Async confirmation
- `Expanded`: Takes available space
- Conditional colors: `isIncome ? green : red`
- Text styling: `copyWith()` for variations

### 3. BudgetProgressCard Component

**Purpose**: Show budget progress with visual indicators.

**Composition:**

```
BudgetProgressCard (StatelessWidget)
└── Card
    └── InkWell
        └── Padding
            └── Column
                ├── Header Row
                │   ├── Category Name (Text)
                │   └── Status Badge (Container, conditional)
                ├── Progress Bar (LinearProgressIndicator)
                └── Amounts Row
                    ├── Spent Info (Column)
                    │   ├── Label (Text)
                    │   └── Amount (Text)
                    └── Remaining Info (Column)
                        ├── Label (Text)
                        └── Amount (Text)
```

**State Indicators:**

- Normal: Primary color, < 80%
- Warning: Orange color, 80-100%
- Exceeded: Red color, > 100%

**Dynamic Styling:**

```dart
Color progressColor;
if (isExceeded) {
  progressColor = AppTheme.expenseColor;
} else if (isNearLimit) {
  progressColor = AppTheme.warningColor;
} else {
  progressColor = theme.colorScheme.primary;
}
```

## Layout Patterns

### Pattern 1: Card-Based List

Used in: Budgets, Savings, Loans, Accounts

```dart
ListView.separated(
  padding: EdgeInsets.all(Spacing.md),
  itemCount: items.length,
  separatorBuilder: (_, __) => SizedBox(height: Spacing.md),
  itemBuilder: (context, index) {
    return CustomCard(item: items[index]);
  },
)
```

**Concepts:**

- `ListView.separated`: Adds space between items
- `itemBuilder`: Creates widgets lazily
- Consistent padding and spacing

### Pattern 2: Horizontal Scrolling Cards

Used in: Dashboard accounts

```dart
SizedBox(
  height: 160,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: Spacing.md),
    itemCount: items.length,
    separatorBuilder: (_, __) => SizedBox(width: Spacing.sm),
    itemBuilder: (context, index) => AccountCard(...),
  ),
)
```

**Concepts:**

- Fixed height container
- Horizontal scroll direction
- Uniform card widths

### Pattern 3: Grouped Lists

Used in: Transactions screen

```dart
ListView.builder(
  itemCount: groupedData.length,
  itemBuilder: (context, index) {
    final group = groupedData[index];
    return Column(
      children: [
        DateHeader(date: group.date),
        ...group.items.map((item) => ItemWidget(item)),
      ],
    );
  },
)
```

**Concepts:**

- Data grouping before rendering
- Nested lists with headers
- Spread operator `...` for lists

### Pattern 4: Grid Layout

Used in: Categories screen

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: Spacing.md,
    mainAxisSpacing: Spacing.md,
    childAspectRatio: 1.2,
  ),
  itemCount: categories.length,
  itemBuilder: (context, index) => CategoryCard(...),
)
```

**Concepts:**

- 2-column grid
- Consistent spacing
- Aspect ratio control

## State Management Patterns

### Stateless Widgets

Used when widget doesn't change over time.

```dart
class AccountCard extends StatelessWidget {
  final String name;

  const AccountCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(child: Text(name));
  }
}
```

### Stateful Widgets

Used when widget needs to update.

```dart
class TransactionsScreen extends StatefulWidget {
  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(...);
  }
}
```

**When to use Stateful:**

- User input (filters, search)
- Animation controllers
- Data that changes within the widget

## Theme Access Pattern

### Getting Theme Colors

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Container(
    color: colorScheme.primary,
    child: Text(
      'Hello',
      style: theme.textTheme.titleMedium,
    ),
  );
}
```

**Available from Theme:**

- `colorScheme`: Semantic colors
- `textTheme`: Typography styles
- `cardTheme`: Card styling
- `inputDecorationTheme`: Form styling

## Navigation Patterns

### Bottom Navigation

```dart
NavigationBar(
  selectedIndex: _currentIndex,
  onDestinationSelected: (index) {
    setState(() => _currentIndex = index);
  },
  destinations: [
    NavigationDestination(icon: Icon(...), label: 'Home'),
  ],
)
```

### Push Navigation

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailScreen(),
  ),
);
```

### Pop Navigation

```dart
Navigator.pop(context);
```

## Design Token Usage

### Spacing

```dart
// Use named constants, not magic numbers
Padding(
  padding: EdgeInsets.all(Spacing.md),  // ✅ Good
  // NOT: EdgeInsets.all(16)             // ❌ Bad
)
```

### Border Radius

```dart
BorderRadius.circular(Corners.card)     // ✅ Good
// NOT: BorderRadius.circular(16)       // ❌ Bad
```

### Colors

```dart
color: AppTheme.incomeColor             // ✅ Good
// NOT: color: Colors.green             // ❌ Bad
```

## Common Patterns Summary

### 1. Conditional Rendering

```dart
if (condition) Widget(),
condition ? Widget1() : Widget2(),
```

### 2. List Mapping

```dart
...items.map((item) => Widget(item)).toList()
```

### 3. Callbacks

```dart
onTap: () {
  // Handle tap
}
```

### 4. Null Safety

```dart
String? optionalValue
if (optionalValue != null) Text(optionalValue)
```

### 5. Spread Operator

```dart
children: [
  Widget1(),
  ...listOfWidgets,
  Widget2(),
]
```

## Learning Exercises

### Exercise 1: Create a New Card Component

Create a `StatisticsCard` that shows:

- Icon with background
- Title
- Value (number)
- Trend indicator

### Exercise 2: Modify Existing Component

Add a "favorite" star icon to `AccountCard` that can be toggled.

### Exercise 3: Create a New Screen

Create a "Reports" screen showing:

- Monthly spending chart (placeholder)
- Top categories list
- Spending trends

### Exercise 4: Add Filtering

Add category filtering to the Transactions screen.

## Debugging Tips

### 1. Use Debug Paint

Press 'p' in console to see widget boundaries.

### 2. Widget Inspector

Use DevTools to inspect widget tree.

### 3. Print Statements

```dart
print('Value: $variable');
```

### 4. Assert Statements

```dart
assert(value != null, 'Value should not be null');
```

## Performance Tips

### 1. Use Const Constructors

```dart
const Text('Hello')  // Reused across rebuilds
```

### 2. Extract Widgets

Don't build everything in one `build()` method.

### 3. ListView.builder

Better than `ListView(children: [])` for long lists.

### 4. Avoid Rebuilding Static Widgets

Extract to separate widgets or use `const`.

## Next Steps

1. **Study the code**: Read through each file
2. **Modify components**: Change colors, spacing, layouts
3. **Create new widgets**: Practice composition
4. **Add features**: Implement new functionality
5. **Experiment**: Break things and fix them

Remember: The best way to learn is by doing. Modify, experiment, and build!
