import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventory_v1/data/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';

part 'checked_out_model.g.dart';

@HiveType(typeId: 3)
class CheckedOutModel extends CheckedOutEntity {
  ///Constructor
  CheckedOutModel({
    required this.checkedOutAmount,
    required this.dateTimeModel,
    required this.partModel,
    required this.isVerifiedModel,
    required this.verifiedDateModel,
  }) : super(
            checkedOutQuantity: checkedOutAmount,
            dateTime: dateTimeModel,
            part: partModel,
            isVerified: isVerifiedModel,
            verifiedDate: verifiedDateModel);

  ///Part that was checked out
  @HiveField(0)
  final Part partModel;

  ///When the part was checked out
  @HiveField(1)
  final int checkedOutAmount;

  ///How much was taken out
  @HiveField(2)
  final DateTime dateTimeModel;

  @HiveField(3)
  final bool isVerifiedModel;

  @HiveField(4)
  final DateTime verifiedDateModel;
}