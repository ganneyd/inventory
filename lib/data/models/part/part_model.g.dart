// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartModelAdapter extends TypeAdapter<PartModel> {
  @override
  final int typeId = 1;

  @override
  PartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartModel(
      index: fields[0] as int,
      name: fields[1] as String,
      nsn: fields[2] as String,
      partNumber: fields[3] as String,
      location: fields[4] as String,
      quantity: fields[5] as int,
      requisitionPoint: fields[6] as int,
      requisitionQuantity: fields[7] as int,
      serialNumber: fields[8] as String,
      unitOfIssue: fields[9] as UnitOfIssue,
      checksum: fields[10] as int,
      isDiscontinued: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PartModel obj) {
    writer
      ..writeByte(12)
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
      ..writeByte(8)
      ..write(obj.serialNumber)
      ..writeByte(9)
      ..write(obj.unitOfIssue)
      ..writeByte(5)
      ..write(obj.quantity)
      ..writeByte(7)
      ..write(obj.requisitionQuantity)
      ..writeByte(6)
      ..write(obj.requisitionPoint)
      ..writeByte(10)
      ..write(obj.checksum)
      ..writeByte(11)
      ..write(obj.isDiscontinued);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartModelImpl _$$PartModelImplFromJson(Map<String, dynamic> json) =>
    _$PartModelImpl(
      index: json['index'] as int? ?? 0,
      name: json['name'] as String? ?? 'unknown_part',
      nsn: json['nsn'] as String? ?? 'unknown_part',
      partNumber: json['partNumber'] as String? ?? 'unknown_part',
      location: json['location'] as String? ?? 'unknown_part',
      quantity: json['quantity'] as int? ?? -1,
      requisitionPoint: json['requisitionPoint'] as int? ?? -1,
      requisitionQuantity: json['requisitionQuantity'] as int? ?? -1,
      serialNumber: json['serialNumber'] as String? ?? 'N/A',
      unitOfIssue:
          $enumDecodeNullable(_$UnitOfIssueEnumMap, json['unitOfIssue']) ??
              UnitOfIssue.NOT_SPECIFIED,
      checksum: json['checksum'] as int? ?? 0,
      isDiscontinued: json['isDiscontinued'] as bool? ?? false,
    );

Map<String, dynamic> _$$PartModelImplToJson(_$PartModelImpl instance) =>
    <String, dynamic>{
      'index': instance.index,
      'name': instance.name,
      'nsn': instance.nsn,
      'partNumber': instance.partNumber,
      'location': instance.location,
      'quantity': instance.quantity,
      'requisitionPoint': instance.requisitionPoint,
      'requisitionQuantity': instance.requisitionQuantity,
      'serialNumber': instance.serialNumber,
      'unitOfIssue': _$UnitOfIssueEnumMap[instance.unitOfIssue]!,
      'checksum': instance.checksum,
      'isDiscontinued': instance.isDiscontinued,
    };

const _$UnitOfIssueEnumMap = {
  UnitOfIssue.EA: 'EA',
  UnitOfIssue.HD: 'HD',
  UnitOfIssue.QT: 'QT',
  UnitOfIssue.PT: 'PT',
  UnitOfIssue.LB: 'LB',
  UnitOfIssue.FT: 'FT',
  UnitOfIssue.NOT_SPECIFIED: 'NOT_SPECIFIED',
};
