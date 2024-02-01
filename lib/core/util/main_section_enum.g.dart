// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_section_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MaintenanceSectionAdapter extends TypeAdapter<MaintenanceSection> {
  @override
  final int typeId = 5;

  @override
  MaintenanceSection read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MaintenanceSection.uh;
      case 1:
        return MaintenanceSection.chM;
      case 2:
        return MaintenanceSection.aH;
      case 3:
        return MaintenanceSection.civ;
      case 4:
        return MaintenanceSection.unknown;
      default:
        return MaintenanceSection.uh;
    }
  }

  @override
  void write(BinaryWriter writer, MaintenanceSection obj) {
    switch (obj) {
      case MaintenanceSection.uh:
        writer.writeByte(0);
        break;
      case MaintenanceSection.chM:
        writer.writeByte(1);
        break;
      case MaintenanceSection.aH:
        writer.writeByte(2);
        break;
      case MaintenanceSection.civ:
        writer.writeByte(3);
        break;
      case MaintenanceSection.unknown:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MaintenanceSectionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
