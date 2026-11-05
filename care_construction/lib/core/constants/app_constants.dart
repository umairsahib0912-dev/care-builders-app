class AppConstants {
  // API & Storage
  static const String firebaseStorageBucket = 'care-construction.appspot.com';

  // Collections
  static const String usersCollection = 'users';
  static const String projectsCollection = 'projects';
  static const String labourCollection = 'labour';
  static const String attendanceCollection = 'attendance';
  static const String inventoryCollection = 'inventory';
  static const String suppliersCollection = 'suppliers';
  static const String purchasesCollection = 'purchases';
  static const String incomeCollection = 'income';
  static const String expensesCollection = 'expenses';
  static const String notificationsCollection = 'notifications';

  // User Roles
  static const String roleAdmin = 'admin';
  static const String roleManager = 'manager';
  static const String roleSupervisor = 'supervisor';
  static const String roleAccountant = 'accountant';

  // Project Status
  static const List<String> projectStatusList = [
    'Planned',
    'In Progress',
    'Completed',
    'On Hold',
    'Cancelled',
  ];

  // Payment Modes
  static const List<String> paymentModeList = [
    'Cash',
    'Cheque',
    'Bank Transfer',
    'UPI',
    'Card',
  ];

  // Expense Categories
  static const List<String> expenseCategoryList = [
    'Labour',
    'Material',
    'Equipment',
    'Transport',
    'Utilities',
    'Miscellaneous',
  ];

  // Material Units
  static const List<String> materialUnitList = [
    'Bags',
    'Tonnes',
    'Cubic Feet',
    'Cubic Meters',
    'Pieces',
    'Kg',
    'Liters',
    'Meters',
    'Square Feet',
    'Square Meters',
  ];

  // Job Roles
  static const List<String> jobRoleList = [
    'Mason',
    'Helper',
    'Carpenter',
    'Electrician',
    'Plumber',
    'Painter',
    'Steel Fixer',
    'Supervisor',
    'Driver',
    'Security Guard',
  ];

  // Attendance Status
  static const String attendancePresent = 'Present';
  static const String attendanceAbsent = 'Absent';
  static const String attendanceHalfDay = 'Half Day';

  // Date Formats
  static const String dateFormat = 'dd MMM yyyy';
  static const String timeFormat = 'hh:mm a';
  static const String dateTimeFormat = 'dd MMM yyyy, hh:mm a';

  // Pagination
  static const int itemsPerPage = 20;

  // Image
  static const double maxImageSizeMB = 5.0;
  static const int imageQuality = 85;

  // GPS
  static const double gpsAccuracyThreshold = 50.0; // meters

  // Currency
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Regex Patterns
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  static const String phonePattern = r'^[6-9]\d{9}$';
  static const String numberPattern = r'^\d+\.?\d*$';
}
