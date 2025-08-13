import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CommonCircularLoader extends StatelessWidget {
  const CommonCircularLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: 50,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary500,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white,),
          ),
        ),
      ),
    );
  }
}