//REFACTORED DB REFERENCE

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
            .map<DataGridRow>(
              (e) => DataGridRow(
                cells: [
                  if (_showCheckbox)
                    const DataGridCell<bool>(
                      columnName: 'checkbox',
                      value: false,
                    ),
                  DataGridCell<int>(
                    columnName: 'index',
                    value: _originalEntries.indexOf(e) + 1,
                  ),
                  DataGridCell<String>(
                    columnName: 'ownerName',
                    value: e.vehicleId, // Will be resolved by cubit
                  ),
                  DataGridCell<String>(
                    columnName: 'vehicle',
                    value: e.vehicleId,
                  ), // Will be resolved by cubit
                  DataGridCell<String>(
                    columnName: 'plateNumber',
                    value: e.vehicleId, // Will be resolved by cubit
                  ),
                  DataGridCell<String>(
                    columnName: 'updatedBy',
                    value: e.updatedByUserId, // Will be resolved by cubit
                  ),
                  DataGridCell<String>(columnName: 'status', value: e.status),
                  DataGridCell<String>(
                    columnName: 'timeIn',
                    value: DateTimeFormatter.formatNumeric(e.timeIn.toDate()),
                  ),
                  DataGridCell<String>(
                    columnName: 'timeOut',
                    value:
                        e.timeOut != null
                            ? DateTimeFormatter.formatNumeric(
                              e.timeOut!.toDate(),
                            )
                            : "Still onsite",
                  ),
                  DataGridCell<String>(
                    columnName: 'duration',
                    value:
                        e.timeOut != null && e.durationMinutes != null
                            ? e.formattedDuration
                            : 'N/A',
                  ),
                  const DataGridCell<String>(columnName: 'actions', value: ''),
                ],
              ),
            )
            .toList();
  }

  @override
  List<DataGridRow> get rows => _vehicleLogEntries;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final rowIndex = _vehicleLogEntries.indexOf(row);
    if (rowIndex < 0 || rowIndex >= _originalEntries.length) {
      return null;
    }

    final entry = _originalEntries[rowIndex];
    final isEven = rowIndex.isEven;

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
    return BlocBuilder<VehicleLogsCubit, VehicleLogsState>(
      builder: (context, state) {
        final cubit = context.read<VehicleLogsCubit>();

        switch (cell.columnName) {
          case 'checkbox':
            final isSelected = state.selectedEntries.contains(entry);
            return Center(
              child: CustomCheckbox(
                value: isSelected,
                onChanged: (_) => cubit.selectEntry(entry),
              ),
            );

          case 'ownerName':
            return _text(cubit.resolveOwnerName(entry));

          case 'vehicle':
            return _text(
              cubit.vehiclesById[entry.vehicleId]?['vehicleModel']
                      ?.toString() ??
                  '—',
            );

          case 'plateNumber':
            return _text(cubit.resolvePlateNumber(entry));

          case 'updatedBy':
            return _text(cubit.resolveUpdatedBy(entry));

          case 'status':
            final status = entry.status.toLowerCase();
            final isOnsite = status == 'onsite';

            return CellBadge(
              badgeBg: isOnsite ? AppColors.successLight : AppColors.errorLight,
              textColor:
                  isOnsite
                      ? const Color.fromARGB(255, 31, 144, 11)
                      : AppColors.error,
              statusStr: entry.status,
              fontSize: AppFontSizes.small,
            );

          case 'actions':
            if (!state.isBulkModeEnabled) {
              return VehicleLogsActionsMenu(
                vehicleLog: entry,
                rowIndex: _originalEntries.indexOf(entry),
                context: context,
              );
            }
            return const Icon(Icons.more_horiz, size: 20);

          default:
            return _text(cell.value.toString());
        }
      },
    );
  }

  Widget _text(String value) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        value,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: const TextStyle(
          fontSize: AppFontSizes.small,
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
