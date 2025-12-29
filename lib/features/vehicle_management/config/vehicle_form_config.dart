import 'package:cvms_desktop/core/widgets/app/custom_dropdown_field.dart';

class VehicleFormConfig {
  static const Map<String, String> fieldLabels = {
    'ownerName': 'Owner Name',
    'schoolID': 'School ID',
    'department': 'Department',
    'plateNumber': 'Plate Number',
    'vehicleType': 'Vehicle Type',
    'vehicleModel': 'Vehicle Model',
    'vehicleColor': 'Vehicle Color',
    'licenseNumber': 'License Number',
    'orNumber': 'OR Number',
    'crNumber': 'CR Number',
    'gender': 'Gender',
    'yearLevel': 'Year Level',
    'block': 'Block',
    'contact': 'Contact',
  };

  static const List<List<String>> fieldLayout = [
    ['ownerName', 'schoolID', 'department'],
    ['plateNumber', 'vehicleType', 'vehicleModel'],
    ['vehicleColor', 'licenseNumber', 'orNumber'],
    ['crNumber', 'gender', 'yearLevel'],
    ['block', 'contact'],
  ];

  static const Map<String, List<DropdownItem<String>>> dropdownOptions = {
    'vehicleType': [
      DropdownItem(value: 'two-wheeled', label: 'two-wheeled'),
      DropdownItem(value: 'four-wheeled', label: 'four-wheeled'),
    ],
    'department': [
      DropdownItem(value: 'CTED', label: 'CTED'),
      DropdownItem(value: 'CAF-SOE', label: 'CAF-SOE'),
      DropdownItem(value: 'CBA', label: 'CBA'),
      DropdownItem(value: 'SCJE', label: 'SCJE'),
      DropdownItem(value: 'CCS', label: 'CCS'),
      DropdownItem(value: 'LHS', label: 'LHS'),
    ],
    'vehicleColor': [
      DropdownItem(value: 'Red', label: 'Red'),
      DropdownItem(value: 'Yellow', label: 'Yellow'),
      DropdownItem(value: 'Green', label: 'Green'),
      DropdownItem(value: 'Orange', label: 'Orange'),
      DropdownItem(value: 'Pink', label: 'Pink'),
      DropdownItem(value: 'Black', label: 'Black'),
      DropdownItem(value: 'Blue', label: 'Blue'),
      DropdownItem(value: 'White', label: 'White'),
      DropdownItem(value: 'Silver', label: 'Silver'),
      DropdownItem(value: 'Gray', label: 'Gray'),
    ],
    // Status options kept for validation of existing vehicles
    // Status is not shown in form - it's set automatically when vehicle has first log
    'status': [
      DropdownItem(value: 'onsite', label: 'Onsite'),
      DropdownItem(value: 'offsite', label: 'Offsite'),
    ],
    'gender': [
      DropdownItem(value: 'Male', label: 'Male'),
      DropdownItem(value: 'Female', label: 'Female'),
      DropdownItem(value: 'Other', label: 'Other'),
    ],
    'yearLevel': [
      DropdownItem(value: '1st', label: '1st Year'),
      DropdownItem(value: '2nd', label: '2nd Year'),
      DropdownItem(value: '3rd', label: '3rd Year'),
      DropdownItem(value: '4th', label: '4th Year'),
    ],
    'block': [
      DropdownItem(value: 'A', label: 'Block A'),
      DropdownItem(value: 'B', label: 'Block B'),
      DropdownItem(value: 'C', label: 'Block C'),
      DropdownItem(value: 'D', label: 'Block D'),
      DropdownItem(value: 'E', label: 'Block E'),
      DropdownItem(value: 'F', label: 'Block F'),
      DropdownItem(value: 'G', label: 'Block G'),
      DropdownItem(value: 'H', label: 'Block H'),
    ],
  };
}
