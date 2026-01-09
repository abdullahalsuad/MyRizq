import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Format utilities for consistent data display
class FormatUtils {
  FormatUtils._();

  /// Format currency with symbol
  static String currency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat('#,##0.00');
    return '$symbol${formatter.format(amount.abs())}';
  }

  /// Format date in a readable format
  static String date(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  /// Format date in short format
  static String dateShort(DateTime date) {
    return DateFormat('MMM d').format(date);
  }

  /// Format date with time
  static String dateTime(DateTime date) {
    return DateFormat('MMM d, yyyy • h:mm a').format(date);
  }

  /// Get relative date (Today, Yesterday, etc.)
  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else if (dateOnly.isAfter(today.subtract(const Duration(days: 7)))) {
      return DateFormat('EEEE').format(date);
    } else if (dateOnly.year == today.year) {
      return DateFormat('MMM d').format(date);
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  /// Format percentage
  static String percentage(double value) {
    return '${value.toStringAsFixed(1)}%';
  }

  /// Compact number format (1K, 1M, etc.)
  static String compactNumber(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}

/// Color utilities
class ColorUtils {
  ColorUtils._();

  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Lighten a color
  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Darken a color
  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}
