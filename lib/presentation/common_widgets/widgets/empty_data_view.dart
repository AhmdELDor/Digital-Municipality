import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'text.dart';

class EmptyDataView extends StatelessWidget {
  final Widget? vector;
  final String label;
  final String desc;

  const EmptyDataView(
      {super.key, this.vector, required this.label, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (vector != null) ...[
            vector!,
            const Gap(24),
          ],
          CommonText.semiBold(
            label,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
            textAlign: TextAlign.center,
          ),
          const Gap(12),
          CommonText.semiBold(
            desc,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
