import 'package:hive_flutter/hive_flutter.dart';
import 'package:inventory_v1/core/util/main_section_enum.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';

part 'checked_out_model.g.dart';

@HiveType(typeId: 3)
class CheckedOutModel extends CheckedOutEntity {
  ///Constructor
  CheckedOutModel({
    required this.indexModel,
    required this.checkedOutAmount,
    required this.dateTimeModel,
    required this.partModelIndex,
    required this.isVerifiedModel,
    required this.verifiedDateModel,
    required this.quantityDiscrepancyModel,
    required this.aircraftTailNumberModel,
    required this.checkoutUserModel,
    required this.sectionModel,
    required this.taskNameModel,
  }) : super(
            section: sectionModel,
            taskName: taskNameModel,
            checkoutUser: checkoutUserModel,
            aircraftTailNumber: aircraftTailNumberModel,
            quantityDiscrepancy: quantityDiscrepancyModel,
            index: indexModel,
            checkedOutQuantity: checkedOutAmount,
            dateTime: dateTimeModel,
            partEntityIndex: partModelIndex,
            isVerified: isVerifiedModel,
            verifiedDate: verifiedDateModel);

  ///Part that was checked out
  @HiveField(0)
  final int partModelIndex;

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

  @HiveField(5)
  final int indexModel;

  @HiveField(6)
  final int quantityDiscrepancyModel;

  @HiveField(7)
  final String taskNameModel;
  @HiveField(8)
  final String checkoutUserModel;
  @HiveField(9)
  final String aircraftTailNumberModel;
  @HiveField(10)
  final MaintenanceSection sectionModel;
}
