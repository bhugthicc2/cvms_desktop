import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget buildSkeletonTable(String title) => Container(
  decoration: cardDecoration(),
  child: Column(
    children: [
      // Fake header
      Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),

        child: Row(
          children: [
            Skeleton.leaf(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('ONSITE'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Skeleton.leaf(
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView.builder(
          itemCount: 10,
          itemBuilder:
              (context, index) => Skeletonizer(
                enabled: true,

                child: Skeleton.leaf(
                  child: Container(
                    height: 35,
                    margin: EdgeInsets.all(8),
                    color: AppColors.grey,
                  ),
                ),
              ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.small,
        ),
        child: Row(
          children: [
            Skeleton.leaf(child: Text('Showing 1 to 2 of 2 entries')),
            const Spacer(),
            Skeleton.leaf(
              child: Container(
                decoration: cardDecoration(),
                height: 25,
                width: 90,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    ],
  ),
);
