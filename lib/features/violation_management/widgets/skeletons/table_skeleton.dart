import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget buildSkeletonTable() => SizedBox(
  child: Column(
    children: [
      // Fake header
      SizedBox(
        child: Row(
          children: [
            //search bar
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Text('Search by plate no., owner, school ID, or model'),
                    Spacer(),
                    Icon(Icons.search),
                  ],
                ),
              ),
            ),

            const Spacing.horizontal(size: AppSpacing.medium),
            //report button
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today),
                  Spacing.horizontal(size: AppSpacing.small),
                  Text('GENERATE REPORT'),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.medium),
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: cardDecoration(),
          child: Column(
            children: [
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
              const SizedBox(height: AppSpacing.medium),
              Row(
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
            ],
          ),
        ),
      ),
    ],
  ),
);
