// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartEntityAdapter extends TypeAdapter<PartEntity> {
  @override
  final int typeId = 1;

  @override
  PartEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartEntity(
      index: fields[0] == null ? -2 : fields[0] as int,
      name: fields[1] == null ? 'no_name_hive' : fields[1] as String,
      nsn: fields[2] == null ? 'no_nsn_hive' : fields[2] as String,
      partNumber: fields[3] == null ? 'no_part_no_hive' : fields[3] as String,
      location: fields[4] == null ? 'no_location_hive' : fields[4] as String,
      quantity: fields[7] == null ? -2 : fields[7] as int,
      requisitionPoint: fields[9] == null ? -2 : fields[9] as int,
      requisitionQuantity: fields[8] == null ? -2 : fields[8] as int,
      serialNumber: fields[5] == null ? 'no_serial_hive' : fields[5] as String,
      unitOfIssue: fields[6] == null
          ? UnitOfIssue.NOT_SPECIFIED
          : fields[6] as UnitOfIssue,
    );
  }

  @override
  void write(BinaryWriter writer, PartEntity obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.nsn)
      ..writeByte(3)
      ..write(obj.partNumber)
      ..writeByte(4)
      ..write(obj.location)
      ..writeByte(5)
      ..write(obj.serialNumber)
      ..writeByte(6)
      ..write(obj.unitOfIssue)
      ..writeByte(7)
      ..write(obj.quantity)
      ..writeByte(8)
      ..write(obj.requisitionQuantity)
      ..writeByte(9)
      ..write(obj.requisitionPoint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
