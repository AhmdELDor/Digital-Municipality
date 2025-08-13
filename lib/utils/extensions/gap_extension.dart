import 'package:gap/gap.dart';

extension NumX on double {
  Gap get gap => Gap(this);
  SliverGap get sliverGap => SliverGap(this);
}
