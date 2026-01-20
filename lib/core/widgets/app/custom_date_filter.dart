import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/features/dashboard/models/report/date_range.dart';
import 'package:cvms_desktop/core/widgets/animation/hover_grow.dart';
import 'package:flutter/material.dart';

class CustomDateFilter extends StatefulWidget {
  final Function(DateRange?) onApply;
  const CustomDateFilter({super.key, required this.onApply});

  @override
  State<CustomDateFilter> createState() => _CustomDateFilterState();
}

class _CustomDateFilterState extends State<CustomDateFilter> {
  String _selectedMode = 'Day'; // Default mode
  List<DateTime?> _selectedDates = [];
  DateRange? _selectedPeriod;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mode selector using SegmentedButton
        SegmentedButton<String>(
          style: SegmentedButton.styleFrom(
            side: BorderSide(color: AppColors.dividerColor),
            selectedBackgroundColor: AppColors.primary,
            selectedForegroundColor: AppColors.white,
          ),
          segments: const [
            ButtonSegment(value: 'Day', label: Text('Day')),
            ButtonSegment(value: 'Week', label: Text('Week')),
            ButtonSegment(value: 'Month', label: Text('Month')),
            ButtonSegment(value: 'Year', label: Text('Year')),
            ButtonSegment(value: 'Range', label: Text('Range')),
          ],
          selected: {_selectedMode},
          onSelectionChanged: (Set<String> newSelection) {
            setState(() {
              _selectedMode = newSelection.first;
              _selectedDates = []; // Reset selection
              _selectedPeriod = null;
            });
          },
        ),
        const SizedBox(height: 16),
        // CalendarDatePicker2 widget
        Expanded(
          child: CalendarDatePicker2(
            config: _getConfig(),
            value: _selectedDates,
            onValueChanged: (dates) {
              setState(() {
                _selectedDates = dates;
                if (dates.isNotEmpty) {
                  DateTime start = dates.first;
                  DateTime end = dates.last;
                  // Adjust based on mode
                  switch (_selectedMode) {
                    case 'Week':
                      // Snap to full week (Monday to Sunday)
                      int weekday = start.weekday;
                      start = start.subtract(Duration(days: weekday - 1));
                      end = start.add(const Duration(days: 6));
                      _selectedDates = [start, end];
                      _selectedPeriod = DateRange.week(start, end);

                      break;
                    case 'Month':
                      // Snap to full month

                      _selectedPeriod = DateRange.month(
                        start.year,
                        start.month,
                      );
                      _selectedDates = [
                        DateTime(start.year, start.month, 1),
                        DateTime(start.year, start.month + 1, 0),
                      ];

                      break;
                    case 'Year':
                      // Snap to full year

                      _selectedPeriod = DateRange.year(start.year);
                      _selectedDates = [
                        DateTime(start.year, 1, 1),
                        DateTime(start.year, 12, 31),
                      ];

                      break;
                    case 'Range':
                      // Use as-is for custom range

                      _selectedPeriod = DateRange.customRange(start, end);

                      break;
                    default:
                      _selectedPeriod = DateRange.day(start);
                      end = start;
                  }
                }
              });
            },
          ),
        ),
        const SizedBox(height: 16),
        HoverGrow(
          hoverScale: 1.02,
          onTap: () {
            widget.onApply(_selectedPeriod);
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Center(
              child: Text(
                'Apply Filter',
                style: TextStyle(color: AppColors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  CalendarDatePicker2Config _getConfig() {
    final today = DateTime.now();
    CalendarDatePicker2Type type;
    switch (_selectedMode) {
      case 'Day':
        type = CalendarDatePicker2Type.single;
        break;
      case 'Week':
      case 'Month':
      case 'Year':
      case 'Range':
        type = CalendarDatePicker2Type.range;
        break;
      default:
        type = CalendarDatePicker2Type.single;
    }

    return CalendarDatePicker2Config(
      calendarType: type,
      firstDate: DateTime(2020), // Customize min date
      lastDate: today.add(const Duration(days: 365)), // Customize max date
      selectedDayHighlightColor:
          Colors.blue, // Customize to match app theme, e.g., AppColors.primary
      todayTextStyle: const TextStyle(color: Colors.red),
      // Add more customizations as needed, e.g., dayBuilder for custom cells
    );
  }
}
