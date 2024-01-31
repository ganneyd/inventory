// ignore_for_file: constant_identifier_names

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
