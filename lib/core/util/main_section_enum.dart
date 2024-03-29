import 'package:hive/hive.dart';
part 'main_section_enum.g.dart';

@HiveType(typeId: 5)
enum MaintenanceSection {
  @HiveField(0)
  uh,
  @HiveField(1)
  chM,
  @HiveField(2)
  aH,
  @HiveField(3)
  civ,
  @HiveField(4)
  unknown
}

extension MaintenanceSectionExtension on MaintenanceSection {
  String enumToString() {
    switch (this) {
      case MaintenanceSection.aH:
        return '64 Maint';
      case MaintenanceSection.uh:
        return '60 Maint';
      case MaintenanceSection.chM:
        return '47 Maint';
      case MaintenanceSection.civ:
        return 'Civilian';
      default:
        return 'Not Sure';
    }
  }

  static MaintenanceSection fromDisplayValue(String displayValue) {
    switch (displayValue) {
      case '64 Maint':
        return MaintenanceSection.aH;
      case '60 Maint':
        return MaintenanceSection.uh;
      case '47 Maint':
        return MaintenanceSection.chM;
      case 'Civilian':
        return MaintenanceSection.civ;
      default:
        return MaintenanceSection.unknown;
    }
  }
}
