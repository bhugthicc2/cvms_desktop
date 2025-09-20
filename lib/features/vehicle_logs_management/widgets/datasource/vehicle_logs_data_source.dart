import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:cvms_desktop/core/widgets/table/cell_badge.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_cubit.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/bloc/vehicle_logs_state.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/models/vehicle_log_model.dart';
import 'package:cvms_desktop/features/vehicle_logs_management/widgets/actions/vehiclelogs_actions_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VehicleLogsDataSource extends DataGridSource {
  final List<VehicleLogModel> _originalEntries;
  final bool _showCheckbox;
  late List<DataGridRow> _vehicleLogEntries;
  VehicleLogsDataSource({
    required List<VehicleLogModel> vehicleLogEntries,
    bool showCheckbox = false,
  }) : _originalEntries = vehicleLogEntries,
       _showCheckbox = showCheckbox {
    _buildRows();
  }

  void _buildRows() {
    _vehicleLogEntries =
        _originalEntries
            .map<DataGridRow>((e) => DataGridRow(cells: _buildCells(e)))
            .toList();
  }

  List<DataGridCell> _buildCells(VehicleLogModel entry) {
    final cells = <DataGridCell>[];

    if (_showCheckbox) {
      cells.add(DataGridCell<bool>(columnName: 'checkbox', value: false));
    }

    cells.addAll([
      DataGridCell<int>(
        columnName: 'index',
        value: _originalEntries.indexOf(entry) + 1,
      ),
      DataGridCell<String>(columnName: 'ownerName', value: entry.ownerName),
      DataGridCell<String>(columnName: 'vehicle', value: entry.vehicleModel),
      DataGridCell<String>(columnName: 'plateNumber', value: entry.plateNumber),
      DataGridCell<String>(columnName: 'updatedBy', value: entry.updatedBy),
      DataGridCell<String>(columnName: 'status', value: entry.status),
      DataGridCell<String>(
        columnName: 'timeIn',
        value: DateTimeFormatter.formatNumeric(entry.timeIn.toDate()),
      ),
      DataGridCell<String>(
        columnName: 'timeOut',
        value:
            entry.timeOut != null
                ? DateTimeFormatter.formatNumeric(entry.timeOut!.toDate())
                : "Still inside",
      ),
      DataGridCell<String>(
        columnName: 'duration',
        value:
            entry.timeOut != null && entry.durationMinutes != null
                ? entry.formattedDuration
                : 'N/A',
      ),

      DataGridCell<String>(columnName: 'actions', value: ''),
    ]);

    return cells;
  }

  @override
  List<DataGridRow> get rows => _vehicleLogEntries;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = _vehicleLogEntries.indexOf(row);
    if (rowIndex < 0 || rowIndex >= _originalEntries.length) {
      return null;
    }
    final bool isEven = rowIndex % 2 == 0;
    final VehicleLogModel entry = _originalEntries[rowIndex];

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

  Widget _buildCellWidget(DataGridCell cell, VehicleLogModel entry) {
    switch (cell.columnName) {
      case 'checkbox':
        return Container(
          alignment: Alignment.center,
          child: CustomCheckbox(
            value: false,
            onChanged: (value) {
              // todo Implement selection functionality when needed
            },
          ),
        );

      case 'actions':
        return BlocBuilder<VehicleLogsCubit, VehicleLogsState>(
          builder: (context, state) {
            if (!state.isBulkModeEnabled) {
              final rowIndex = _originalEntries.indexOf(entry);
              return Container(
                alignment: Alignment.center,
                child: VehicleLogsActionsMenu(
                  vehicleLog: entry,
                  rowIndex: rowIndex,
                  context: context,
                ),
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: const Icon(Icons.more_horiz, size: 20),
              );
            }
          },
        );

      case 'ownerName':
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
              fontFamily: 'Sora',
            ),
          ),
        );
      case 'status':
        final statusStr = cell.value.toString();
        final statusLower = statusStr.toLowerCase();
        final bool isInside = statusLower == 'inside';
        final bool isOutside = statusLower == 'outside';

        final Color badgeBg =
            isInside
                ? AppColors.successLight
                : isOutside
                ? AppColors.errorLight
                : AppColors.grey.withValues(alpha: 0.2);

        final Color textColor =
            isInside
                ? const Color.fromARGB(255, 31, 144, 11)
                : isOutside
                ? AppColors.error
                : AppColors.black;

        return CellBadge(
          badgeBg: badgeBg,
          textColor: textColor,
          statusStr: statusStr,
          fontSize: AppFontSizes.small,
        );
      case 'timeOut':
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
              fontFamily: 'Sora',
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
              fontFamily: 'Sora',
            ),
          ),
        );
    }
  }
}
