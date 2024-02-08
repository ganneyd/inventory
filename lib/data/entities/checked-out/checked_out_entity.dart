import 'package:inventory_v1/data/entities/part/part_entity.dart';

class CheckedOutEntity {
  ///Specify which part was taken out, how much and when
  CheckedOutEntity({
    required this.checkedOutQuantity,
    required this.dateTime,
    required this.part,
    required this.isVerified,
    required this.verifiedDate,
  });

  ///The part that was checked out
  final PartEntity part;

  ///Quantity that the user took out
  final int checkedOutQuantity;

  ///Time when the part was accessed
  final DateTime dateTime;

  ///If the checked out item has been verified
  final bool isVerified;

  ///The date time when the checked out instance was verified
  final DateTime verifiedDate;
}
