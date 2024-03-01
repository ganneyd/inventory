// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checked_out_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckedOutModelAdapter extends TypeAdapter<CheckedOutModel> {
  @override
  final int typeId = 3;

  @override
  CheckedOutModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckedOutModel(
      indexModel: fields[5] as int,
      checkedOutAmount: fields[1] as int,
      dateTimeModel: fields[2] as DateTime,
      partModelIndex: fields[0] as int,
      isVerifiedModel: fields[3] as bool,
      verifiedDateModel: fields[4] as DateTime,
      quantityDiscrepancyModel: fields[6] as int,
      aircraftTailNumberModel: fields[9] as String,
      checkoutUserModel: fields[8] as String,
      sectionModel: fields[10] as MaintenanceSection,
      taskNameModel: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CheckedOutModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.partModelIndex)
      ..writeByte(1)
      ..write(obj.checkedOutAmount)
      ..writeByte(2)
      ..write(obj.dateTimeModel)
      ..writeByte(3)
      ..write(obj.isVerifiedModel)
      ..writeByte(4)
      ..write(obj.verifiedDateModel)
      ..writeByte(5)
      ..write(obj.indexModel)
      ..writeByte(6)
      ..write(obj.quantityDiscrepancyModel)
      ..writeByte(7)
      ..write(obj.taskNameModel)
      ..writeByte(8)
      ..write(obj.checkoutUserModel)
      ..writeByte(9)
      ..write(obj.aircraftTailNumberModel)
      ..writeByte(10)
      ..write(obj.sectionModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckedOutModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
