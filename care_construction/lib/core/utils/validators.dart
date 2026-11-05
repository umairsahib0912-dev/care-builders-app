import '../constants/app_constants.dart';
import '../constants/app_strings.dart';

class Validators {
  // Email Validator
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    final emailRegex = RegExp(AppConstants.emailPattern);
    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  // Password Validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }

    return null;
  }

  // Confirm Password Validator
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value != password) {
      return AppStrings.passwordsDoNotMatch;
    }

    return null;
  }

  // Phone Number Validator
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    final phoneRegex = RegExp(AppConstants.phonePattern);
    if (!phoneRegex.hasMatch(value.trim())) {
      return AppStrings.invalidPhoneNumber;
    }

    return null;
  }

  // Required Field Validator
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName is required'
          : AppStrings.fieldRequired;
    }
    return null;
  }

  // Number Validator
  static String? validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    final numberRegex = RegExp(AppConstants.numberPattern);
    if (!numberRegex.hasMatch(value.trim())) {
      return 'Please enter a valid number';
    }

    return null;
  }

  // Amount Validator
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    final amount = double.tryParse(value.trim());
    if (amount == null || amount <= 0) {
      return AppStrings.invalidAmount;
    }

    return null;
  }

  // Name Validator
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    return null;
  }

  // Date Validator
  static String? validateDate(DateTime? value) {
    if (value == null) {
      return 'Please select a date';
    }
    return null;
  }

  // Dropdown Validator
  static String? validateDropdown(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an option';
    }
    return null;
  }
}
