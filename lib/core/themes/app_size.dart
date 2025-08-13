import 'package:flutter/material.dart';

abstract class Insets {
  static const double none = 0;
  static const double xSmall = 4;
  static const double small = 8;
  static const double medium = 12;
  static const double normal = 16;
  static const double large = 20;
  static const double xLarge = 24;
}

abstract class PaddingValue {
  static const EdgeInsets zero = EdgeInsets.zero;
  static const EdgeInsets xSmall = EdgeInsets.all(Insets.xSmall);
  static const EdgeInsets small = EdgeInsets.all(Insets.small);
  static const EdgeInsets medium = EdgeInsets.all(Insets.medium);
  static const EdgeInsets normal = EdgeInsets.all(Insets.normal);
  static const EdgeInsets large = EdgeInsets.all(Insets.large);
  static const EdgeInsets xLarge = EdgeInsets.all(Insets.xLarge);
}


abstract class RadiusValue {
  static const double xxSmall = 2;
  static const double xSmall = 4;
  static const double small = 6;
  static const double medium = 8;
  static const double large = 10;
  static const double xLarge = 12;
  static const double xLarge2 = 16;
  static const double xLarge3 = 20;
  static const double xLarge4 = 24;
  static const double full = 100;
}

abstract class ShapeRadius {
  static const Radius zero = Radius.zero;
  static const Radius xxSmall = Radius.circular(RadiusValue.xxSmall);
  static const Radius xSmall = Radius.circular(RadiusValue.xSmall);
  static const Radius small = Radius.circular(RadiusValue.small);
  static const Radius medium = Radius.circular(RadiusValue.medium);
  static const Radius large = Radius.circular(RadiusValue.large);
  static const Radius xLarge = Radius.circular(RadiusValue.xLarge);
  static const Radius xLarge2 = Radius.circular(RadiusValue.xLarge2);
  static const Radius xLarge3 = Radius.circular(RadiusValue.xLarge3);
  static const Radius xLarge4 = Radius.circular(RadiusValue.xLarge4);
  static const Radius full = Radius.circular(RadiusValue.full);
}

abstract class ShapeBorderRadius {
  static const BorderRadius zero = BorderRadius.zero;
  static const BorderRadius xxSmall = BorderRadius.all(ShapeRadius.xxSmall);
  static const BorderRadius xSmall = BorderRadius.all(ShapeRadius.xSmall);
  static const BorderRadius small = BorderRadius.all(ShapeRadius.small);
  static const BorderRadius medium = BorderRadius.all(ShapeRadius.medium);
  static const BorderRadius large = BorderRadius.all(ShapeRadius.large);
  static const BorderRadius xLarge = BorderRadius.all(ShapeRadius.xLarge);
  static const BorderRadius xLarge2 = BorderRadius.all(ShapeRadius.xLarge2);
  static const BorderRadius xLarge3 = BorderRadius.all(ShapeRadius.xLarge3);
  static const BorderRadius xLarge4 = BorderRadius.all(ShapeRadius.xLarge4);
  static const BorderRadius full = BorderRadius.all(ShapeRadius.full);
}

abstract class TextSize {
  static const double heading = 20;
  static const double appBarTitle = 18;
  static const double appBarSubTitle = 14;
  static const double title = 16;
  static const double subTitle = 14;
  static const double label = 14;
  static const double content = 12;
  static const double body = 10;
}

abstract class TextWeight {
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
}
