class AppError {
  AppError._();

  static const String errorUnauthorized =
      "Authentication failed.Please try again";

  static const String errorUserNameEmpty = "Please enter user name";
  static const String errorEmailEmpty = "Please enter email address";
  static const String errorEmailInvalid = "Please enter valid email address";
  static const String errorMobileNumberEmpty = "Please enter phone number";
  static const String errorMobileNumberInvalid =
      "Please enter valid phone number";
  static const String errorPasswordEmpty = "Please enter password";
  static const String errorPasswordInvalid = "Please enter valid password";
  static const String errorPasswordInvalidDesc =
      "Password must contain minimum eight and maximum thirty characters at least one alphabet and one number and one uppercase and one special character";
  static const String errorNewPasswordEmpty = "Please enter new password";
  static const String errorNewPasswordInvalid =
      "Please enter valid new password";
  static const String errorCurrentPasswordEmpty =
      "Please enter current password";
  static const String errorCurrentPasswordInvalid =
      "Please enter valid current password";
  static const String errorConfirmPasswordEmpty =
      "Please enter confirm password";
  static const String errorConfirmPasswordInvalid =
      "Please enter valid confirm password";
  static const String errorPasswordMismatch = "Sorry! Password doesn't match!";

  static const String errorFullNameEmpty = "Please enter full name";
  static const String errorAddressEmpty = "Please enter address";
  static const String errorStateEmpty = "Please select state";
  static const String errorCityEmpty = "Please enter city";
  static const String errorZipcodeEmpty = "Please enter zipcode";
  static const String errorZipcodeInvalid = "Please enter a valid 6-digit ZIP code.";
  static const String errorGenderEmpty = "Please select gender";
  static const String errorAddNewVoucherAmountEmpty = "Please enter amount";
  static const String errorMinimumEmpty = "Please enter minimum amount.";
  static const String errorMaximumEmpty = "Please enter maximum amount.";
  static const String errorMaximumAmountInvalid = "Maximum price should be greater then minimum price.";

  static const String errorEmptyFirstName = "Please enter First Name";
  static const String errorEmptyLastName = "Please enter Last Name";
  static const String errorName = 'Name must contain only alphabetic characters';
}
