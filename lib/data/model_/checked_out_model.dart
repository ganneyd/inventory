import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventory_v1/domain/entity_/checked_out/checked_out_entity.dart';
import 'package:inventory_v1/domain/models/part/part_model.dart';

part 'checked_out_model.g.dart';

@HiveType(typeId: 3)
class CheckedOutModel extends CheckedOutEntity {
  ///Constructor
  CheckedOutModel({
    required this.checkedOutAmount,
    required this.dateTimeModel,
    required this.partModel,
  }) : super(
            checkedOutQuantity: checkedOutAmount,
            dateTime: dateTimeModel,
            part: partModel);

  ///Part that was checked out
  @HiveField(0)
  final Part partModel;

  ///When the part was checked out
  @HiveField(1)
  final int checkedOutAmount;

  ///How much was taken out
  @HiveField(2)
  final DateTime dateTimeModel;
}
