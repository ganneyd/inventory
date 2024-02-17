class PartOrderEntity {
  PartOrderEntity(
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

extension PartOrderExtension on PartOrderEntity {
  PartOrderEntity copyWith(
      {int? index,
      int? partEntityIndex,
      int? orderAmount,
      DateTime? orderDate,
      bool? isFulfilled,
      DateTime? fulfillmentDate}) {
    return PartOrderEntity(
        index: index ?? this.index,
        partEntityIndex: partEntityIndex ?? this.partEntityIndex,
        orderAmount: orderAmount ?? this.orderAmount,
        isFulfilled: isFulfilled ?? this.isFulfilled,
        orderDate: orderDate ?? this.orderDate);
  }
}
