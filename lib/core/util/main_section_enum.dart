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
}
