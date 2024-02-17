import 'package:inventory_v1/data/models/part_order/part_order_model.dart';

class OrderEntity {
  OrderEntity(
      {required this.index,
      required this.partEntityIndex,
      required this.orderAmount,
      required this.orderDate,
      this.isFulfilled = false,
      this.fulfillmentDate});

  final int index;
  final int partEntityIndex;
  final int orderAmount;
  final DateTime orderDate;
  final bool isFulfilled;
  final DateTime? fulfillmentDate;
}

extension PartOrderExtension on OrderEntity {
  OrderEntity copyWith(
      {int? index,
      int? partEntityIndex,
      int? orderAmount,
      DateTime? orderDate,
      bool? isFulfilled,
      DateTime? fulfillmentDate}) {
    return OrderEntity(
        index: index ?? this.index,
        partEntityIndex: partEntityIndex ?? this.partEntityIndex,
        orderAmount: orderAmount ?? this.orderAmount,
        isFulfilled: isFulfilled ?? this.isFulfilled,
        orderDate: orderDate ?? this.orderDate);
  }

  OrderModel toModel() {
    return OrderModel(
        indexModel: index,
        partModelIndex: partEntityIndex,
        orderAmountModel: orderAmount,
        orderDateModel: orderDate,
        isFulfilledModel: isFulfilled,
        fulfillmentDateModel: fulfillmentDate ?? DateTime.now());
  }
}
