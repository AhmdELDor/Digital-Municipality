import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        child: Center(
          child: Card(
            elevation: 0,
            child: SizedBox.square(
              dimension: 84,
              child: LoadingIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
        // child: LottieBuilder.asset(
        //   "assets/json/loader.json",
        //   width: 84,
        //   height: 84,
        //   fit: BoxFit.contain,
        // ),
        );
  }
}
