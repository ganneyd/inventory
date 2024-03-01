import 'package:hive/hive.dart';
part 'main_section_enum.g.dart';

@HiveType(typeId: 4)
enum MaintenanceSection {
  @HiveField(0)
  uh,
  @HiveField(1)
  chM,
  @HiveField(2)
  aH,
  @HiveField(3)
  civ,
}
