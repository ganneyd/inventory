class CheckedOutEntity {
  ///Specify which part was taken out, how much and when
  CheckedOutEntity({
    required this.index,
    required this.quantityDiscrepancy,
    required this.checkedOutQuantity,
    required this.dateTime,
    required this.partEntityIndex,
    this.isVerified,
    this.verifiedDate,
  });
  final int index;

  ///The part that was checked out
  final int partEntityIndex;

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CheckedOutEntity &&
        other.index == index &&
        other.partEntityIndex == partEntityIndex &&
        other.checkedOutQuantity == checkedOutQuantity &&
        other.quantityDiscrepancy == quantityDiscrepancy &&
        other.dateTime == dateTime &&
        other.isVerified == isVerified &&
        other.verifiedDate == verifiedDate;
  }

  @override
  int get hashCode {
    return index.hashCode ^
        partEntityIndex.hashCode ^
        checkedOutQuantity.hashCode ^
        quantityDiscrepancy.hashCode ^
        dateTime.hashCode ^
        isVerified.hashCode ^
        verifiedDate.hashCode;
  }
}

extension CheckedOutEntityExtension on CheckedOutEntity {
  String extensionOverride() => 'over ride $checkedOutQuantity';
  CheckedOutEntity copyWith(
      {int? partEntityIndex,
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
        partEntityIndex: partEntityIndex ?? this.partEntityIndex,
        isVerified: isVerified ?? this.isVerified,
        verifiedDate: verifiedDate ?? this.verifiedDate);
  }
}
