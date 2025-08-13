// part of 'view_common_imports.dart';
//
// class CustomStepper extends StatelessWidget {
//   final int currentStep;
//   final int totalSteps;
//
//   const CustomStepper({
//     super.key,
//     required this.currentStep,
//     required this.totalSteps,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: List.generate(totalSteps, (index) {
//         final isActive = index < currentStep;
//         return Expanded(
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 2),
//             height: 24,width: 24,
//             decoration: BoxDecoration(
//               color:
//                   isActive
//                       ? Theme.of(context).colorScheme.primary
//                       : AppColors.white,
//               shape: BoxShape.circle
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
