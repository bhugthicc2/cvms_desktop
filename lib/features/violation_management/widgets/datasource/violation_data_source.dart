// VEHICLE ID REFERENCE UPDATE MARKER
import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:cvms_desktop/core/widgets/table/cell_badge.dart';
import 'package:cvms_desktop/features/violation_management/bloc/violation_cubit.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_enums.dart';
import 'package:cvms_desktop/features/violation_management/models/violation_model.dart';
import 'package:cvms_desktop/features/violation_management/widgets/actions/violation_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ViolationDataSource extends DataGridSource {
  final List<ViolationEntry> _originalEntries;
  final bool _showCheckbox;
  final bool _showActions;
  // ignore: unused_field
  final BuildContext? _context;
  final VoidCallback? onReject;
  final Function(ViolationEntry)? onEdit;
  final Function(ViolationEntry)? onUpdate;
  final Function(ViolationEntry)? onViewMore;

  ViolationDataSource({
    required List<ViolationEntry> violationEntries,
    bool showCheckbox = false,
    bool showActions = true,
    BuildContext? context,
    this.onReject,
    this.onEdit,
    this.onUpdate,
    this.onViewMore,
  }) : _originalEntries = violationEntries,
       _showCheckbox = showCheckbox,
       _showActions = showActions,
       _context = context {
    _buildRows();
  }

  void _buildRows() {
    _violationEntries =
        _originalEntries
            .map<DataGridRow>((e) => DataGridRow(cells: _buildCells(e)))
            .toList();
  }

  List<DataGridCell> _buildCells(ViolationEntry entry) {
    final cells = <DataGridCell>[];
    if (_showCheckbox) {
      cells.add(DataGridCell<bool>(columnName: 'checkbox', value: false));
    }
    cells.addAll([
      DataGridCell<int>(
        columnName: 'index',
        value: _originalEntries.indexOf(entry) + 1,
      ),
      DataGridCell<String>(
        columnName: 'dateTime',
        value: DateTimeFormatter.formatFull(entry.reportedAt.toDate()),
      ),
      DataGridCell<String>(columnName: 'reportedBy', value: entry.fullname),
      DataGridCell<String>(columnName: 'plateNumber', value: entry.plateNumber),
      DataGridCell<String>(columnName: 'owner', value: entry.ownerName),
      DataGridCell<String>(columnName: 'violation', value: entry.violationType),
      DataGridCell<String>(columnName: 'status', value: entry.status.name),
    ]);
    if (_showActions) {
      cells.add(DataGridCell<String>(columnName: 'actions', value: ''));
    }
    return cells;
  }

  List<DataGridRow> _violationEntries = [];

  @override
  List<DataGridRow> get rows => _violationEntries;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = _violationEntries.indexOf(row);
    final bool isEven = rowIndex % 2 == 0;
    final ViolationEntry entry = _originalEntries[rowIndex];
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

  Widget _buildCellWidget(DataGridCell cell, ViolationEntry entry) {
    switch (cell.columnName) {
      case 'checkbox':
        return BlocBuilder<ViolationCubit, ViolationState>(
          builder: (context, state) {
            final isSelected = state.selectedEntries.contains(entry);
            return Container(
              alignment: Alignment.center,
              child: CustomCheckbox(
                value: isSelected,
                onChanged: (value) {
                  context.read<ViolationCubit>().selectEntry(entry);
                },
              ),
            );
          },
        );
      case 'actions':
        return BlocBuilder<ViolationCubit, ViolationState>(
          builder: (context, state) {
            final rowIndex = _originalEntries.indexOf(entry);
            return Container(
              alignment: Alignment.center,
              child: ViolationActions(
                rowIndex: rowIndex,
                context: context,
                plateNumber: entry.plateNumber,
                isResolved: entry.status == ViolationStatus.confirmed,
                violationEntry: entry,
                onReject: () => onReject?.call(),
                onEdit: () => onEdit?.call(entry),
                onUpdate: () => onUpdate?.call(entry),
                onViewMore: () => onViewMore?.call(entry),
              ),
            );
          },
        );
      case 'dateTime':
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
      case 'reportedBy':
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
      case 'violation':
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
      case 'owner':
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
      case 'plateNumber':
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
        final bool isConfirmed = statusLower == 'confirmed';
        final bool isPending = statusLower == 'pending';
        final Color badgeBg =
            isConfirmed
                ? AppColors.successLight
                : isPending
                ? AppColors.chartOrange.withValues(alpha: 0.3)
                : AppColors.grey.withValues(alpha: 0.2);
        final Color textColor =
            isConfirmed
                ? const Color.fromARGB(255, 31, 144, 11)
                : isPending
                ? AppColors.chartOrange
                : AppColors.black;
        return CellBadge(
          horizontalPadding: 30,
          badgeBg: badgeBg,
          textColor: textColor,
          statusStr: statusStr,
          fontSize: AppFontSizes.small,
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
