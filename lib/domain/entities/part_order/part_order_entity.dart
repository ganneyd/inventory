import 'package:inventory_v1/domain/entities/part/part_entity.dart';

class PartOrderEntity {
  PartOrderEntity(
      {required this.index,
      required this.partEntity,
      required this.orderAmount,
      required this.orderDate,
      this.isFulfilled = false,
      this.fulfillmentDate});

  final int index;
  final PartEntity partEntity;
  final int orderAmount;
  final DateTime orderDate;
  final bool isFulfilled;
  final DateTime? fulfillmentDate;
}

extension PartOrderExtension on PartOrderEntity {
  PartOrderEntity copyWith(
      {int? index,
      PartEntity? partEntity,
      int? orderAmount,
      DateTime? orderDate,
      bool? isFulfilled,
      DateTime? fulfillmentDate}) {
    return PartOrderEntity(
        index: index ?? this.index,
        partEntity: partEntity ?? this.partEntity,
        orderAmount: orderAmount ?? this.orderAmount,
        isFulfilled: isFulfilled ?? this.isFulfilled,
        orderDate: orderDate ?? this.orderDate);
  }
}
