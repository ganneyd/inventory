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
      partModel: fields[0] as Part,
      isVerifiedModel: fields[3] as bool,
      verifiedDateModel: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CheckedOutModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.partModel)
      ..writeByte(1)
      ..write(obj.checkedOutAmount)
      ..writeByte(2)
      ..write(obj.dateTimeModel)
      ..writeByte(3)
      ..write(obj.isVerifiedModel)
      ..writeByte(4)
      ..write(obj.verifiedDateModel)
      ..writeByte(5)
      ..write(obj.indexModel);
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
