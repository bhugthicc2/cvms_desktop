import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/features/sanction_management/models/saction_model.dart';
import 'package:cvms_desktop/features/sanction_management/models/sanction_enums.dart';
import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:cvms_desktop/core/widgets/table/cell_badge.dart';
import 'package:cvms_desktop/features/sanction_management/bloc/sanction_cubit.dart';
import 'package:cvms_desktop/features/sanction_management/bloc/sanction_state.dart';
import 'package:cvms_desktop/features/sanction_management/widgets/actions/sanction_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SanctionDataSource extends DataGridSource {
  final List<Sanction> _originalEntries;
  final bool _showCheckbox;
  final bool _showActions;
  // ignore: unused_field
  final BuildContext? _context;
  final VoidCallback? onView;
  final Function(Sanction)? onEdit;
  final Function(Sanction)? onUpdate;
  final Function(Sanction)? onViewMore;

  SanctionDataSource({
    required List<Sanction> sanctionEntries,
    bool showCheckbox = false,
    bool showActions = true,
    BuildContext? context,
    this.onView,
    this.onEdit,
    this.onUpdate,
    this.onViewMore,
  }) : _originalEntries = sanctionEntries,
       _showCheckbox = showCheckbox,
       _showActions = showActions,
       _context = context {
    _buildRows();
  }

  void _buildRows() {
    _sanctionEntries =
        _originalEntries
            .map<DataGridRow>((e) => DataGridRow(cells: _buildCells(e)))
            .toList();
  }

  List<DataGridCell> _buildCells(Sanction entry) {
    final cells = <DataGridCell>[];
    if (_showCheckbox) {
      cells.add(DataGridCell<bool>(columnName: 'checkbox', value: false));
    }
    cells.addAll([
      DataGridCell<int>(
        columnName: 'index',
        value: _originalEntries.indexOf(entry) + 1,
      ),
      DataGridCell<String>(columnName: 'vehicleId', value: entry.vehicleId),
      DataGridCell<String>(
        columnName: 'offenseNumber',
        value: entry.offenseNumber.toString(),
      ),
      DataGridCell<String>(columnName: 'sanctionType', value: entry.type.value),
      DataGridCell<String>(columnName: 'status', value: entry.status.value),
      DataGridCell<String>(
        columnName: 'startDate',
        value: DateTimeFormatter.formatFull(entry.startAt),
      ),
      DataGridCell<String>(
        columnName: 'endDate',
        value:
            entry.endAt != null
                ? DateTimeFormatter.formatFull(entry.endAt!)
                : 'N/A',
      ),
    ]);
    if (_showActions) {
      cells.add(DataGridCell<String>(columnName: 'actions', value: ''));
    }
    return cells;
  }

  List<DataGridRow> _sanctionEntries = [];

  @override
  List<DataGridRow> get rows => _sanctionEntries;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = _sanctionEntries.indexOf(row);
    final bool isEven = rowIndex % 2 == 0;
    final Sanction entry = _originalEntries[rowIndex];
    return DataGridRowAdapter(
      color:
          isEven
              ? AppColors.white
              : AppColors.dividerColor.withValues(alpha: 0.2),
      cells:
          row.getCells().map<Widget>((cell) {
            return _buildCellWidget(cell, entry);
          }).toList(),
    );
  }

  Widget _buildCellWidget(DataGridCell cell, Sanction entry) {
    switch (cell.columnName) {
      case 'checkbox':
        return BlocBuilder<SanctionCubit, SanctionState>(
          builder: (context, state) {
            final isSelected = state.selectedEntries.contains(entry);
            return Container(
              alignment: Alignment.center,
              child: CustomCheckbox(
                value: isSelected,
                onChanged: (value) {
                  context.read<SanctionCubit>().selectEntry(entry);
                },
              ),
            );
          },
        );
      case 'actions':
        return BlocBuilder<SanctionCubit, SanctionState>(
          builder: (context, state) {
            final rowIndex = _originalEntries.indexOf(entry);
            return Container(
              alignment: Alignment.center,
              child: SanctionActions(
                rowIndex: rowIndex,
                context: context,
                sanctionEntry: entry,
                onView: () => onView?.call(),
              ),
            );
          },
        );
      case 'vehicleId':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );
      case 'offenseNumber':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );
      case 'sanctionType':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );
      case 'status':
        final statusStr = cell.value.toString();
        final statusLower = statusStr.toLowerCase();
        final bool isActive = statusLower == 'active';
        final bool isExpired = statusLower == 'expired';
        final Color badgeBg =
            isActive
                ? AppColors.successLight
                : isExpired
                ? AppColors.chartOrange.withValues(alpha: 0.3)
                : AppColors.grey.withValues(alpha: 0.2);
        final Color textColor =
            isActive
                ? const Color.fromARGB(255, 31, 144, 11)
                : isExpired
                ? AppColors.chartOrange
                : AppColors.black;
        return CellBadge(
          horizontalPadding: 30,
          badgeBg: badgeBg,
          textColor: textColor,
          statusStr: statusStr,
          fontSize: AppFontSizes.small,
        );
      case 'startDate':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );
      case 'endDate':
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );
      default:
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFontSizes.small,
              fontFamily: 'Poppins',
            ),
          ),
        );
    }
  }
}
