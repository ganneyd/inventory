// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_model.dart';

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
