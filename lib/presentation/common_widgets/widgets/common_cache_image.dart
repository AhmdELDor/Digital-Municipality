import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import 'image.dart';

Widget commonCacheImage(
  String? url,
  String? placeHolder, {
  double? height,
  double? width,
  BoxFit? fit,
  Color? color,
}) {
  return CachedNetworkImage(
    placeholder:
        (context, url) => Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: CupertinoActivityIndicator(
              color: Theme.of(context).colorScheme.primary,
              animating: true, // Control animation
            ),
          ),
        ),
    errorWidget: (_, __, ___) {
      return placeholderWidget(placeHolder);
    },
    imageUrl: '$url',
    height: height,
    width: width,
    color: color,
    fit: fit ?? BoxFit.cover,
    fadeInDuration: const Duration(seconds: 1),
  );
}

Widget? Function(BuildContext, String) placeholderWidgetFn() =>
    (_, s) => placeholderWidget("");

Widget placeholderWidget(String? placeHolder) => SvgImageFromAsset(
  placeHolder ?? UserPlaceholderAssets.userPlaceHolderDark,
  fit: BoxFit.cover,
);
