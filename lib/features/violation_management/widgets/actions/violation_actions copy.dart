// import 'package:cvms_desktop/core/theme/app_colors.dart';
// import 'package:cvms_desktop/core/widgets/app/custom_icon_button.dart';
// import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
// import 'package:cvms_desktop/features/violation_management/widgets/dialogs/custom_reject_dialog.dart';
// import 'package:cvms_desktop/features/violation_management/widgets/dialogs/custom_edit_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';

// class ViolationActions extends StatelessWidget {
//   final int rowIndex;
//   final BuildContext context;
//   final String plateNumber;
//   final bool isResolved;
//   final ViolationEntry violationEntry;

//   const ViolationActions({
//     super.key,
//     required this.rowIndex,
//     required this.context,
//     required this.plateNumber,
//     required this.isResolved,
//     required this.violationEntry,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//           child: CustomIconButton(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder:
//                     (_) => const CustomEditDialog(
//                       title: "Edit Violation Information ",
//                     ),
//               );
//             },
//             icon: PhosphorIconsRegular.notePencil,
//             iconColor: AppColors.primary,
//           ),
//         ),

//         Expanded(
//           child: CustomIconButton(
//             onPressed: () {
//               //todo confirm
//             },
//             iconSize: 17,
//             icon: PhosphorIconsFill.checkCircle,
//             iconColor: isResolved ? AppColors.success : AppColors.grey,
//           ),
//         ),
//         Expanded(
//           child: CustomIconButton(
//             onPressed: () {
//               showDialog(
//                 context: context,
//                 builder:
//                     (_) => CustomDeleteDialog(
//                       title: "Confirm Delete",
//                       plateNumber: plateNumber,
//                     ),
//               );
//             },
//             icon: PhosphorIconsRegular.trash,
//             iconColor: AppColors.error,
//           ),
//         ),

//         Expanded(
//           child: CustomIconButton(
//             onPressed: () {
//               //todo more options
//             },
//             icon: PhosphorIconsBold.dotsThreeVertical,
//             iconColor: AppColors.error,
//           ),
//         ),
//       ],
//     );
//   }
// }
