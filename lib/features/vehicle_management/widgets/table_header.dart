import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../core/widgets/app/search_field.dart';

class TableHeader extends StatelessWidget {
  final TextEditingController? searchController;

  const TableHeader({super.key, this.searchController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (searchController != null)
          Expanded(
            child: SizedBox(
              height: 40,
              child: SearchField(controller: searchController!),
            ),
          ),
        Spacing.horizontal(size: AppSpacing.medium),
        Expanded(
          child: SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('Vehicle Status Tapped');
                    },
                    child: Container(
                      //TODO ADD VEHICLE BUTTON
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Vehicle Status',
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Sora',
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              PhosphorIconsFill.caretDown,
                              size: 15,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('Vehicle Type Tapped');
                    },
                    child: Container(
                      //TODO ADD VEHICLE BUTTON
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Vehicle Type',
                              style: TextStyle(
                                fontSize: AppFontSizes.small,
                                color: AppColors.white,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Sora',
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              PhosphorIconsFill.caretDown,
                              size: 15,
                              color: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      debugPrint('Bulk mode Tapped');
                    },
                    child: Container(
                      //TODO BULK MODE BUTTON
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'Bulk Mode',
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Spacing.horizontal(size: AppSpacing.medium),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    //TODO
                    child: Container(
                      //TODO ADD VEHICLE BUTTON
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          'Add Vehicle',
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
