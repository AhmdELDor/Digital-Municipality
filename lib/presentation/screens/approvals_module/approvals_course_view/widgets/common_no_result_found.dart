import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
class CommonNoResultFound extends StatefulWidget {
  const CommonNoResultFound({super.key});

  @override
  State<CommonNoResultFound> createState() => _CommonNoResultFoundState();
}

class _CommonNoResultFoundState extends State<CommonNoResultFound> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gap(30),
          CommonText.medium('No Data Found',size: 30,)

        ],

      ),
    );
  }
}
