/// Consistent spacing system for the app
/// Demonstrates design tokens for predictable layouts
class Spacing {
  Spacing._();

  // Base spacing unit (4px)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 40.0;
  static const double xxxl = 48.0;

  // Specific use cases
  static const double cardPadding = md;
  static const double screenPadding = md;
  static const double sectionSpacing = lg;
  static const double listItemSpacing = sm;
}

/// Border radius constants
class Corners {
  Corners._();

  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;

  // Specific use cases
  static const double card = lg;
  static const double button = md;
  static const double input = md;
  static const double bottomSheet = xl;
}

/// Icon sizes
class IconSizes {
  IconSizes._();

  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
