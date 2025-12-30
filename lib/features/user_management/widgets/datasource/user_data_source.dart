import 'package:cvms_desktop/core/theme/app_colors.dart';
import 'package:cvms_desktop/core/theme/app_font_sizes.dart';
import 'package:cvms_desktop/core/utils/date_time_formatter.dart';
import 'package:cvms_desktop/core/widgets/app/custom_checkbox.dart';
import 'package:cvms_desktop/core/widgets/table/cell_badge.dart';
import 'package:cvms_desktop/features/user_management/bloc/user_cubit.dart';
import 'package:cvms_desktop/features/user_management/models/user_model.dart';
import 'package:cvms_desktop/features/user_management/widgets/actions/user_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class UserDataSource extends DataGridSource {
  final List<UserEntry> _originalEntries;
  final bool _showCheckbox;
  // ignore: unused_field
  final BuildContext? _context;

  UserDataSource({
    required List<UserEntry> userEntries,
    bool showCheckbox = false,
    BuildContext? context,
  }) : _originalEntries = userEntries,
       _showCheckbox = showCheckbox,
       _context = context {
    _buildRows();
  }

  void _buildRows() {
    _userEntries =
        _originalEntries
            .map<DataGridRow>((e) => DataGridRow(cells: _buildCells(e)))
            .toList();
  }

  List<DataGridCell> _buildCells(UserEntry entry) {
    final cells = <DataGridCell>[];

    if (_showCheckbox) {
      cells.add(DataGridCell<bool>(columnName: 'checkbox', value: false));
    }

    cells.addAll([
      DataGridCell<int>(
        columnName: 'index',
        value: _originalEntries.indexOf(entry) + 1,
      ),
      DataGridCell<String>(columnName: 'Fullname', value: entry.fullname),
      DataGridCell<String>(columnName: 'email', value: entry.email),
      DataGridCell<String>(columnName: 'role', value: entry.role),
      DataGridCell<String>(columnName: 'status', value: entry.status),
      DataGridCell<String>(
        columnName: 'lastLogin',
        value: DateTimeFormatter.formatFull(entry.lastLogin),
      ),
      DataGridCell<String>(columnName: 'password', value: entry.password),
      DataGridCell<String>(columnName: 'actions', value: ''),
    ]);

    return cells;
  }

  List<DataGridRow> _userEntries = [];

  @override
  List<DataGridRow> get rows => _userEntries;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    final int rowIndex = _userEntries.indexOf(row);
    final bool isEven = rowIndex % 2 == 0;
    final UserEntry entry = _originalEntries[rowIndex];

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

  Widget _buildCellWidget(DataGridCell cell, UserEntry entry) {
    switch (cell.columnName) {
      case 'checkbox':
        return BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            final isSelected = state.selectedEntries.contains(entry);
            return Container(
              alignment: Alignment.center,
              child: CustomCheckbox(
                value: isSelected,
                onChanged: (value) {
                  context.read<UserCubit>().selectEntry(entry);
                },
              ),
            );
          },
        );

      case 'actions':
        return BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            final rowIndex = _originalEntries.indexOf(entry);
            return Container(
              alignment: Alignment.center,
              child: UserActions(
                rowIndex: rowIndex,
                context: context,
                email: entry.email,
                uid: entry.id,
                fullname: entry.fullname,
              ),
            );
          },
        );

      case 'email':
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

      case 'Fullname':
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
        final bool isInactive = statusLower == 'inactive';

        final Color badgeBg =
            isActive
                ? AppColors.successLight
                : isInactive
                ? AppColors.errorLight
                : AppColors.grey.withValues(alpha: 0.2);

        final Color textColor =
            isActive
                ? const Color.fromARGB(255, 31, 144, 11)
                : isInactive
                ? AppColors.error
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
