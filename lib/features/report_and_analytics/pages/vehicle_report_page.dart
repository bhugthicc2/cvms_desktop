import 'package:cvms_desktop/core/theme/app_spacing.dart';
import 'package:cvms_desktop/core/widgets/layout/spacing.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/cards/vehicle_info_card.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/sections/vehicle_report_header.dart';
import 'package:cvms_desktop/features/report_and_analytics/widgets/sections/vehicle_section.dart';
import 'package:flutter/material.dart';

class VehicleReportPage extends StatelessWidget {
  const VehicleReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        VehicleReportHeader(
          title: 'Vehicle Report',
          subtitle: 'Individual vehicle report',
          searchController: SearchController(),
          onExportPdf: () {}, //todo
          onExportCsv: () {}, //todo
        ),
        Spacing.vertical(size: AppSpacing.medium),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: VehicleInfoCard()),
              //vehicle info card section
              Spacing.horizontal(size: AppSpacing.medium),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: VehicleSection(
                        height: double.infinity,
                        child: Center(
                          child: Text(
                            'Violation by type and status \n(Bar Chart: Violations by Type/Status).',
                          ),
                        ),
                        //Violation Summary (Bar Chart: Violations by Type/Status).
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(
                      child: VehicleSection(
                        height: double.infinity,
                        child: Center(
                          child: Text(
                            'Log Summary \n(Line Chart: Parking Durations Over Time).',
                          ),
                        ),
                      ),
                    ),
                    //Log Summary (Line Chart: Parking Durations Over Time).
                  ],
                ),
              ),
            ],
          ),
        ),
        //top section
        Spacing.vertical(size: AppSpacing.medium),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: VehicleSection(
                  height: double.infinity,
                  child: Center(
                    child: Text(
                      'Recent Logs \n(Table: Last 10 logs with timeIn/out, duration).',
                    ),
                  ),
                  //Violation Summary (Bar Chart: Violations by Type/Status).
                ),
              ),
              //vehicle info card section
              Spacing.horizontal(size: AppSpacing.medium),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: VehicleSection(
                        height: double.infinity,
                        child: Center(
                          child: Text(
                            'Violation Trends Overtime \n(Line Chart: Violations summary over time).',
                          ),
                        ),
                        //Violation Summary \n(Line Chart: Violations summary over time)
                      ),
                    ),
                    Spacing.horizontal(size: AppSpacing.medium),
                    Expanded(
                      child: VehicleSection(
                        height: double.infinity,
                        child: Center(
                          child: Text(
                            'Violation type distribution \n(Doughnut Chart: Violation type distribution).',
                          ),
                        ),
                        //Violation type distribution \n(Doughnut Chart: Violation type distribution).
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
