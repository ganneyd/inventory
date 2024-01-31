import 'package:inventory_v1/core/util/util.dart';
import 'package:hive/hive.dart';
part 'part_entity.g.dart';

///Part entity represents a part and its relevant info that is stored in
///the database
@HiveType(typeId: 1)
class PartEntity {
  PartEntity({
    required this.index,
    required this.name,
    required this.nsn,
    required this.partNumber,
    required this.location,
    required this.quantity,
    required this.requisitionPoint,
    required this.requisitionQuantity,
    required this.serialNumber,
    required this.unitOfIssue,
  });

  ///The document ID of the part as specified by the database
  @HiveField(0, defaultValue: -2)
  final int index;

  ///Name of the part
  @HiveField(1, defaultValue: 'no_name_hive')
  final String name;

  ///NSN of the part
  @HiveField(2, defaultValue: 'no_nsn_hive')
  final String nsn;

  ///Part number of the part
  @HiveField(3, defaultValue: 'no_part_no_hive')
  final String partNumber;

  ///Location of the part
  @HiveField(4, defaultValue: 'no_location_hive')
  final String location;

  ///Serial number of the part if any
  @HiveField(5, defaultValue: 'no_serial_hive')
  final String serialNumber;

  ///unit of issue of the part
  @HiveField(6, defaultValue: UnitOfIssue.NOT_SPECIFIED)
  final UnitOfIssue unitOfIssue;

  ///Quantity of the part in the inventory
  @HiveField(7, defaultValue: -2)
  final int quantity;

  ///requisition quantity of the part
  @HiveField(8, defaultValue: -2)
  final int requisitionQuantity;

  ///requisition point of the part
  @HiveField(9, defaultValue: -2)
  final int requisitionPoint;
}
