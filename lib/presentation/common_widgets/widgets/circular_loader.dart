import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CircularLoader extends StatelessWidget {
  final double? loaderSize;
  const CircularLoader({super.key, this.loaderSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: loaderSize ?? 60.0,
      height: loaderSize ?? 60.0,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}

Future<void> commonToastMsg(String msgText) async {
  await Fluttertoast.showToast(
    msg: msgText,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 1,
    backgroundColor: AppColors.primary500,
    textColor: AppColors.white,
    fontSize: 16.0,
  );
}