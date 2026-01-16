import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/utils/card_decor.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

Widget buildSkeletonTable() => SizedBox(
  child: Column(
    children: [
      // Fake header
      Row(
        children: [
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
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Row(
              children: [
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
                const SizedBox(width: AppSpacing.medium),
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
                const SizedBox(width: AppSpacing.medium),
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
                const SizedBox(width: AppSpacing.medium),
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
        ],
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
