import 'package:flutter/material.dart';

import '../../../core/themes/app_size.dart';
import 'image.dart';

class SocialIconButton extends StatelessWidget {
 final String icon;

  const SocialIconButton({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 80,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: ShapeBorderRadius.full,
      ),
      child: IconButton(
        icon: Center(child: SvgImageFromAsset(icon, fit: BoxFit.fitHeight)),
        onPressed: () {},
      ),
    );
  }
}
