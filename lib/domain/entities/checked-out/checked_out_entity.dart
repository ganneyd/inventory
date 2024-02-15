import 'package:inventory_v1/domain/entities/part/part_entity.dart';

class CheckedOutEntity {
  ///Specify which part was taken out, how much and when
  CheckedOutEntity({
    required this.index,
    required this.quantityDiscrepancy,
    required this.checkedOutQuantity,
    required this.dateTime,
    required this.part,
    this.isVerified,
    this.verifiedDate,
  });
  final int index;

  ///The part that was checked out
  final PartEntity part;

  ///Quantity that the user took out
  final int checkedOutQuantity;

  ///Changes between the checked out quantity and the verified quantity
  final int quantityDiscrepancy;

  ///Time when the part was accessed
  final DateTime dateTime;

  ///If the checked out item has been verified
  final bool? isVerified;

  ///The date time when the checked out instance was verified
  final DateTime? verifiedDate;
}

extension CheckedOutEntityExtension on CheckedOutEntity {
  String extensionOverride() => 'over ride $checkedOutQuantity';
  CheckedOutEntity copyWith(
      {PartEntity? partEntity,
      int? index,
      int? checkedOutQuantity,
      bool? isVerified,
      DateTime? verifiedDate,
      DateTime? dateTime,
      int? quantityDiscrepancy}) {
    return CheckedOutEntity(
        quantityDiscrepancy: quantityDiscrepancy ?? this.quantityDiscrepancy,
        index: index ?? this.index,
        checkedOutQuantity: checkedOutQuantity ?? this.checkedOutQuantity,
        dateTime: dateTime ?? this.dateTime,
        part: partEntity ?? part,
        isVerified: isVerified ?? this.isVerified,
        verifiedDate: verifiedDate ?? this.verifiedDate);
  }
}
