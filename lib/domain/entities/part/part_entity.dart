import 'package:inventory_v1/core/util/util.dart';

///Part entity represents a part and its relevant info that is stored in
///the database
class PartEntity {
  PartEntity({
    required this.partID,
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
  final String partID;

  ///Name of the part
  final String name;

  ///NSN of the part
  final String nsn;

  ///Part number of the part
  final String partNumber;

  ///Location of the part
  final String location;

  ///Serial number of the part if any
  final String serialNumber;

  ///unit of issue of the part
  final UnitOfIssue unitOfIssue;

  ///Quantity of the part in the inventory
  final int quantity;

  ///requisition quantity of the part
  final int requisitionQuantity;

  ///requisition point of the part
  final int requisitionPoint;
}
