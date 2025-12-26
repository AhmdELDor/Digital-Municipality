class AppError {
  AppError._();

  static const String errorUnauthorized =
      "فشلت المصادقة. يرجى المحاولة مرة أخرى";

  static const String errorUserNameEmpty = "الرجاء إدخال اسم المستخدم";
  static const String errorEmailEmpty = "الرجاء إدخال البريد الإلكتروني";
  static const String errorEmailInvalid = "الرجاء إدخال بريد إلكتروني صالح";
  static const String errorMobileNumberEmpty = "الرجاء إدخال رقم الهاتف";
  static const String errorMobileNumberInvalid =
      "الرجاء إدخال رقم هاتف صالح";
  static const String errorPasswordEmpty = "الرجاء إدخال كلمة المرور";
  static const String errorPasswordInvalid = "الرجاء إدخال كلمة مرور صالحة";
  static const String errorPasswordInvalidDesc =
      "يجب أن تحتوي كلمة المرور على ثمانية أحرف كحد أدنى وثلاثين حرفًا كحد أقصى وحرف واحد على الأقل ورقم واحد وحرف كبير واحد وحرف خاص واحد";
  static const String errorNewPasswordEmpty = "الرجاء إدخال كلمة المرور الجديدة";
  static const String errorNewPasswordInvalid =
      "الرجاء إدخال كلمة مرور جديدة صالحة";
  static const String errorCurrentPasswordEmpty =
      "الرجاء إدخال كلمة المرور الحالية";
  static const String errorCurrentPasswordInvalid =
      "الرجاء إدخال كلمة مرور حالية صالحة";
  static const String errorConfirmPasswordEmpty =
      "الرجاء إدخال تأكيد كلمة المرور";
  static const String errorConfirmPasswordInvalid =
      "الرجاء إدخال تأكيد كلمة مرور صالحة";
  static const String errorPasswordMismatch = "عذراً! كلمة المرور غير متطابقة!";

  static const String errorFullNameEmpty = "الرجاء إدخال الاسم الكامل";
  static const String errorAddressEmpty = "الرجاء إدخال العنوان";
  static const String errorStateEmpty = "الرجاء اختيار المحافظة";
  static const String errorCityEmpty = "الرجاء إدخال المدينة";
  static const String errorZipcodeEmpty = "الرجاء إدخال الرمز البريدي";
  static const String errorZipcodeInvalid = "الرجاء إدخال رمز بريدي صالح مكون من 6 أرقام.";
  static const String errorGenderEmpty = "الرجاء اختيار الجنس";
  static const String errorAddNewVoucherAmountEmpty = "الرجاء إدخال المبلغ";
  static const String errorMinimumEmpty = "الرجاء إدخال الحد الأدنى للمبلغ.";
  static const String errorMaximumEmpty = "الرجاء إدخال الحد الأقصى للمبلغ.";
  static const String errorMaximumAmountInvalid = "يجب أن يكون الحد الأقصى للسعر أكبر من الحد الأدنى للسعر.";

  static const String errorEmptyFirstName = "الرجاء إدخال الاسم الأول";
  static const String errorEmptyLastName = "الرجاء إدخال الاسم الأخير";
  static const String errorName = 'يجب أن يحتوي الاسم على أحرف أبجدية فقط';
}
