import '/core/constants/app_errors.dart';

//^                                    Start anchor
//(?=.*[A-Z].*[A-Z])           Ensure string has two uppercase letters.
//(?=.*[!@#$&*])               Ensure string has one special case letter.
//(?=.*[0-9].*[0-9])            Ensure string has two digits.
//(?=.*[a-z].*[a-z].*[a-z])   Ensure string has three lowercase letters.
//.{8}                                 Ensure string is of length 8.
//$                                      End anchor.

//"^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d$@$!%*#?&]{8,30}$"
//Minimum 8 and Maximum 30 characters at least 1 Alphabet and 1 Number

//"^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
//Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character

//"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
//Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number

//"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
//Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character

//"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,15}"
//Minimum 8 and Maximum 15 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character

RegExp emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$'); //Email Regex
RegExp phoneNumRegex = RegExp(r'^[0-9]{10}$'); //Phone Number Regex
RegExp passwordRegex = RegExp(
  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~%}{^()_+=":/?.,><;]).{8,30}$',
); //Password Regex

String? validateMobileNumber(String? value) {
  if (value == null) {
    return null;
  } else if (value.trim().isEmpty) {
    return AppError.errorMobileNumberEmpty;
  } else if (value.replaceAll(" ", "").length < 7 ||
      value.replaceAll(" ", "").length > 11) {
    return AppError.errorMobileNumberInvalid;
  } else {
    return null;
  }
}

String? validatePassword(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorPasswordEmpty;
  } else {
    return null;
  }
}

String? validatePasswordWithDescription(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorPasswordEmpty;
  } else if (!passwordRegex.hasMatch(value.trim())) {
    return AppError.errorPasswordInvalidDesc;
  } else {
    return null;
  }
}

String? validateNewPassword(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorNewPasswordEmpty;
  } else if (!passwordRegex.hasMatch(value.trim())) {
    return AppError.errorPasswordInvalidDesc;
  } else {
    return null;
  }
}

String? validateAtLeastEightCharacters(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorNewPasswordEmpty;
  } else if (!passwordRegex.hasMatch(value.trim())) {
    return AppError.errorPasswordInvalidDesc;
  } else {
    return null;
  }
}

String? validateCurrentPassword(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorCurrentPasswordEmpty;
  } else if (!passwordRegex.hasMatch(value.trim())) {
    return AppError.errorPasswordInvalidDesc;
  } else {
    return null;
  }
}

String? validateConfirmPassword(String? value, String password) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorConfirmPasswordEmpty;
  } else if (value != password) {
    return AppError.errorPasswordMismatch;
  } else {
    return null;
  }
}

String? validateEmail(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorEmailEmpty;
  } else if (!emailRegex.hasMatch(value.trim())) {
    return AppError.errorEmailInvalid;
  } else {
    return null;
  }
}

String? validateOldPassword(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorPasswordEmpty;
  } else {
    return null;
  }
}

String? validateAddressLine1(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorAddressEmpty;
  } else {
    return null;
  }
}

String? validateFullName(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorFullNameEmpty;
  } else {
    return null;
  }
}

String? validateCardNumber(String? value) {
  if (value == null || value.trim().isEmpty) return 'Please enter card number';
  if (value.replaceAll(' ', '').length < 16) return 'Invalid card number';
  return null;
}

String? validateExpiryDate(String? value) {
  if (value == null || value.isEmpty) return 'Please enter expiry date';

  final parts = value.split('/');
  if (parts.length != 2) return 'Invalid format';

  final month = int.tryParse(parts[0]);
  final year = int.tryParse(parts[1]);

  if (month == null || year == null) return 'Invalid numbers';
  if (month < 1 || month > 12) return 'Month must be 01–12';

  final now = DateTime.now();
  final currentYear = int.parse(
    now.year.toString().substring(2),
  ); // last two digits
  final currentMonth = now.month;

  if (year < currentYear || (year == currentYear && month < currentMonth)) {
    return 'Card expired';
  }

  if (year > currentYear + 20) return 'Invalid year';

  return null;
}

String? validateEmptyValue(String? value, String? errorMsg) {
  if (value == null) {
    return null;
  } else if (value.trim().isEmpty) {
    return errorMsg;
  } else {
    return null;
  }
}

String? validateCVVValue(String? value) {
  if (value == null || value.isEmpty) {
    return 'CVV is required';
  }
  if (value.length < 3 || value.length > 4) {
    return 'Invalid CVV';
  }
  return null;
}

String? validateZipcode(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorZipcodeEmpty;
  } else if (value.length != 6) {
    return AppError.errorZipcodeInvalid; // Define this error string in AppError
  } else {
    return null;
  }
}

String? validateCity(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorCityEmpty;
  } else {
    return null;
  }
}

String? validateAddNewVoucherAmount(String? value) {
  if (value == null) {
    return null;
  } else if (value.isEmpty) {
    return AppError.errorAddNewVoucherAmountEmpty;
  } else {
    return null;
  }


}

String? validateFirstName(String? value) {
  String pattern =
      r"^[a-zA-Z]+$"; // Pattern to match alphabetic characters only
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty) {
    return AppError.errorEmptyFirstName;
  } else if (!regex.hasMatch(value)) {
    return AppError.errorName;
  } else {
    return null;
  }
}

String? validateLastName(String? value) {
  String pattern =
      r"^[a-zA-Z]+$"; // Pattern to match alphabetic characters only
  RegExp regex = RegExp(pattern);
  if (value == null || value.isEmpty) {
    return AppError.errorEmptyLastName;
  } else if (!regex.hasMatch(value)) {
    return AppError.errorName;
  } else {
    return null;
  }
}