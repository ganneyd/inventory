import 'package:inventory_v1/core/util/util.dart';

///Part entity represents a part and its relevant info that is stored in
///the database
class PartEntity {
  PartEntity(
      {required this.index,
      required this.name,
      required this.nsn,
      required this.partNumber,
      required this.location,
      required this.quantity,
      required this.requisitionPoint,
      required this.requisitionQuantity,
      required this.serialNumber,
      required this.unitOfIssue,
      required this.checksum,
      required this.isDiscontinued});

  ///The document ID of the part as specified by the database
  final int index;

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

  ///tracks the version of the part
  final int checksum;

  //tracks if the part is discontinued or not
  final bool isDiscontinued;
}

extension PartEntityExtension on PartEntity {
  PartEntity copyWith(
      {String? name,
      String? nsn,
      String? location,
      String? partNumber,
      String? serialNumber,
      UnitOfIssue? unitOfIssue,
      int? quantity,
      int? requisitionQuantity,
      int? requisitionPoint,
      bool? isDiscontinued}) {
    return PartEntity(
        index: index,
        name: name ?? this.name,
        nsn: nsn ?? this.nsn,
        partNumber: partNumber ?? this.partNumber,
        location: location ?? this.location,
        quantity: quantity ?? this.quantity,
        requisitionPoint: requisitionPoint ?? this.requisitionPoint,
        requisitionQuantity: requisitionQuantity ?? this.requisitionQuantity,
        serialNumber: serialNumber ?? this.serialNumber,
        unitOfIssue: unitOfIssue ?? this.unitOfIssue,
        checksum: checksum,
        isDiscontinued: isDiscontinued ?? this.isDiscontinued);
  }

  PartEntity updateChecksum() {
    return PartEntity(
        isDiscontinued: isDiscontinued,
        index: index,
        name: name,
        nsn: nsn,
        partNumber: partNumber,
        location: location,
        quantity: quantity,
        requisitionPoint: requisitionPoint,
        requisitionQuantity: requisitionQuantity,
        serialNumber: serialNumber,
        unitOfIssue: unitOfIssue,
        checksum: checksum + 1);
  }
}
