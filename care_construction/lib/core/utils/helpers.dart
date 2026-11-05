import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class AppHelpers {
  // Format Currency
  static String formatCurrency(double amount) {
    return '${AppConstants.currencySymbol}${NumberFormat('#,##,##0.00').format(amount)}';
  }

  // Format Currency without decimals
  static String formatCurrencyShort(double amount) {
    return '${AppConstants.currencySymbol}${NumberFormat('#,##,##0').format(amount)}';
  }

  // Format Date
  static String formatDate(DateTime date) {
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  // Format Time
  static String formatTime(DateTime time) {
    return DateFormat(AppConstants.timeFormat).format(time);
  }

  // Format DateTime
  static String formatDateTime(DateTime dateTime) {
    return DateFormat(AppConstants.dateTimeFormat).format(dateTime);
  }

  // Parse Date String
  static DateTime? parseDate(String dateString) {
    try {
      return DateFormat(AppConstants.dateFormat).parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Get Days Difference
  static int getDaysDifference(DateTime start, DateTime end) {
    return end.difference(start).inDays;
  }

  // Check if Date is Today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  // Get Month Name
  static String getMonthName(int month) {
    return DateFormat('MMMM').format(DateTime(2024, month));
  }

  // Get First Day of Month
  static DateTime getFirstDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  // Get Last Day of Month
  static DateTime getLastDayOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  // Capitalize First Letter
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Get Initials from Name
  static String getInitials(String name) {
    if (name.isEmpty) return '';

    List<String> parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
  }

  // Validate Email Format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(AppConstants.emailPattern);
    return emailRegex.hasMatch(email);
  }

  // Validate Phone Format
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(AppConstants.phonePattern);
    return phoneRegex.hasMatch(phone);
  }

  // Calculate Percentage
  static double calculatePercentage(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  // Calculate Profit/Loss Percentage
  static double calculateProfitLossPercentage(double income, double expense) {
    if (expense == 0) return 100;
    return ((income - expense) / expense) * 100;
  }

  // Round to Decimal Places
  static double roundToDecimal(double value, int places) {
    num mod = 10.0.pow(places);
    return ((value * mod).round().toDouble() / mod);
  }

  // Get File Extension
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  // Get File Size in MB
  static double getFileSizeInMB(int bytes) {
    return bytes / (1024 * 1024);
  }

  // Truncate Text
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Generate Random ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  // Get Time Ago
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else {
      return '${(difference.inDays / 365).floor()}y ago';
    }
  }

  // Get Greeting Based on Time
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  // Convert String to Double
  static double stringToDouble(String value) {
    return double.tryParse(value) ?? 0.0;
  }

  // Convert String to Int
  static int stringToInt(String value) {
    return int.tryParse(value) ?? 0;
  }

  // Check if String is Numeric
  static bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  // Remove Special Characters
  static String removeSpecialCharacters(String text) {
    return text.replaceAll(RegExp(r'[^\w\s]+'), '');
  }

  // Format Phone Number
  static String formatPhoneNumber(String phone) {
    if (phone.length == 10) {
      return '${phone.substring(0, 5)} ${phone.substring(5)}';
    }
    return phone;
  }
}
