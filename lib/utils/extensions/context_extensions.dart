import 'package:flutter/material.dart';

extension $BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;

  bool get isAndroid => Theme.of(this).platform == TargetPlatform.android;

  NavigatorState get navigator => Navigator.of(this);

  EdgeInsets get mediaQueryPadding => MediaQuery.of(this).padding;

  EdgeInsets get mediaQueryInsets => MediaQuery.of(this).viewInsets;

  double get height => mediaQuery.size.height;

  double get width => mediaQuery.size.width;

  double get topPadding => mediaQuery.padding.top;

  double get bottomPadding => mediaQuery.padding.bottom;

  double get topInset => mediaQuery.viewInsets.top;

  double get bottomInset => mediaQuery.viewInsets.bottom;

  Object? get args => ModalRoute.of(this)?.settings.arguments;

  TextDirection get textDirection => Directionality.of(this);

  Locale get locale => Localizations.localeOf(this);

  T getArguments<T extends Object>() {
    assert(args != null && args is T);
    return args as T;
  }

  void hideKeyboard() {
    final FocusScopeNode focusScope = FocusScope.of(this);
    if (focusScope.hasFocus) {
      focusScope.unfocus();
    }
  }
}
