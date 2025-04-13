import 'package:intl/intl.dart';

/// Utility class for formatting dates and timestamps in the application
class AppDateFormat {
  /// Prevents instantiation of this class
  AppDateFormat._();

  /// Formats a timestamp in milliseconds to a human-readable date format
  ///
  /// Example output: "Apr 13, 2025 • 2:31 PM"
  static String formatTimestamp(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat('MMM d, yyyy • h:mm a').format(dateTime);
  }

  /// Returns relative time (time ago) from a millisecond timestamp
  ///
  /// Example outputs:
  /// - Just now
  /// - 5m ago
  /// - 2h ago
  /// - 3d ago
  /// - 2mo ago
  /// - 1y ago
  static String getTimeAgo(int milliseconds) {
    final now = DateTime.now();
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 30) return '${difference.inDays}d ago';
    if (difference.inDays < 365) return '${(difference.inDays / 30).floor()}mo ago';
    return '${(difference.inDays / 365).floor()}y ago';
  }

  /// Formats a timestamp to a short date (e.g., "Apr 13, 2025")
  static String formatShortDate(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat('MMM d, yyyy').format(dateTime);
  }

  /// Formats a timestamp to time only (e.g., "2:31 PM")
  static String formatTimeOnly(int milliseconds) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat('h:mm a').format(dateTime);
  }

  /// Formats a timestamp to a custom pattern
  static String formatCustom(int milliseconds, String pattern) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat(pattern).format(dateTime);
  }
}
