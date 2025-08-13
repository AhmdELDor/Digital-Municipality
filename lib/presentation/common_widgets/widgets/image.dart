import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageFromAsset extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;
  final bool matchTextDirection;

  const ImageFromAsset(
    this.image, {
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.contain,
    this.matchTextDirection = true,
    super.key,
  });

  const ImageFromAsset.square(
    this.image, {
    double size = 24,
    this.color,
    this.fit = BoxFit.contain,
    this.matchTextDirection = true,
    super.key,
  }) : height = size,
       width = size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      fit: fit,
      color: color,
      width: width,
      height: height,
      matchTextDirection: matchTextDirection,
    );
  }
}

class SvgImageFromAsset extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Color? color;
  final bool matchTextDirection;
  final ColorFilter? colorFilter;

  const SvgImageFromAsset(
    this.image, {
    super.key,
    this.height,
    this.width,
    this.color,
    this.fit = BoxFit.contain,
    this.matchTextDirection = true,
    this.colorFilter,
  });

  const SvgImageFromAsset.square(
    this.image, {
    super.key,
    double size = 24,
    this.color,
    this.fit = BoxFit.contain,
    this.matchTextDirection = true,
    this.colorFilter,
  }) : height = size,
       width = size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      fit: fit,
      width: width,
      height: height,
      colorFilter: colorFilter,
      matchTextDirection: matchTextDirection,
    );
  }
}
