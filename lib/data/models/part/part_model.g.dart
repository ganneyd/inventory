// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartModelImpl _$$PartModelImplFromJson(Map<String, dynamic> json) =>
    _$PartModelImpl(
      name: json['name'] as String,
      nsn: json['nsn'] as String,
      partNumber: json['partNumber'] as String,
      location: json['location'] as String,
      quantity: json['quantity'] as int,
      requisitionPoint: json['requisitionPoint'] as int,
      requisitionQuantity: json['requisitionQuantity'] as int,
      serialNumber: json['serialNumber'] as String,
      unitOfIssue: $enumDecode(_$UnitOfIssueEnumMap, json['unitOfIssue']),
    );

Map<String, dynamic> _$$PartModelImplToJson(_$PartModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'nsn': instance.nsn,
      'partNumber': instance.partNumber,
      'location': instance.location,
      'quantity': instance.quantity,
      'requisitionPoint': instance.requisitionPoint,
      'requisitionQuantity': instance.requisitionQuantity,
      'serialNumber': instance.serialNumber,
      'unitOfIssue': _$UnitOfIssueEnumMap[instance.unitOfIssue]!,
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
