// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'unit_of_issue.g.dart';

///Specifies the various units that a part
///may be package in/by
@HiveType(typeId: 2)
enum UnitOfIssue {
  ///USED IF A PART IS SINGULAR IN ISSUE
  @HiveField(0)
  EA,

  ///USED IF A PART IS ISSUED BY THE HUNDREDS
  @HiveField(1)
  HD,

  ///USED IF A PART IS ISSUED BY THE QUART
  @HiveField(2)
  QT,

  ///USED IF A PART IS ISSUED BY THE PINT
  @HiveField(3)
  PT,

  ///USED IF A PART IS ISSUED BY THE POUND
  @HiveField(4)
  LB,

  ///USED IF A PART IS ISSUED BY THE FOOT
  @HiveField(5)
  FT,

  ///USED IF A PART  ISSUE IS NOT SPECIFIED OR UNKNOWN
  @HiveField(6)
  NOT_SPECIFIED
}

extension UnitOfIssueExtension on UnitOfIssue {
  String get displayValue {
    return toString().split('.').last; // Returns only the enum value
  }

  static List<DropdownMenuEntry<UnitOfIssue>> enumToDropDownEntries() {
    var values = UnitOfIssue.values.toList();
    values.removeLast();
    return values.map((value) {
      return DropdownMenuEntry<UnitOfIssue>(
          value: value, label: value.displayValue);
    }).toList();
  }

  static UnitOfIssue fromDisplayValue(String displayValue) {
    switch (displayValue) {
      case 'EA':
        return UnitOfIssue.EA;
      case 'HD':
        return UnitOfIssue.HD;
      case 'QT':
        return UnitOfIssue.QT;
      case 'PT':
        return UnitOfIssue.PT;
      case 'LB':
        return UnitOfIssue.LB;
      case 'FT':
        return UnitOfIssue.FT;
      default:
        return UnitOfIssue.NOT_SPECIFIED;
    }
  }
}
