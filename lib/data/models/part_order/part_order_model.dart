import 'package:hive/hive.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/entities/part_order/part_order_entity.dart';

part 'part_order_model.g.dart';

@HiveType(typeId: 4)
class PartOrderModel extends PartOrderEntity {
  PartOrderModel(
      {required this.indexModel,
      required this.partModel,
      required this.orderAmountModel,
      required this.orderDateModel,
      required this.isFulfilledModel,
      required this.fulfillmentDateModel})
      : super(
            index: indexModel,
            partEntity: partModel,
            orderAmount: orderAmountModel,
            orderDate: orderDateModel,
            isFulfilled: isFulfilledModel,
            fulfillmentDate: fulfillmentDateModel);
  @HiveField(0)
  final int indexModel;
  @HiveField(1)
  final PartModel partModel;
  @HiveField(2)
  final int orderAmountModel;
  @HiveField(3)
  final DateTime orderDateModel;
  @HiveField(4)
  final bool isFulfilledModel;
  @HiveField(5)
  final DateTime fulfillmentDateModel;
}
