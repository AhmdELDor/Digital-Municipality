import 'package:flutter/material.dart';

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
