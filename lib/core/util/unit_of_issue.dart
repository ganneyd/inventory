// ignore_for_file: constant_identifier_names

///Specifies the various units that a part
///may be package in/by
enum UnitOfIssue {
  ///USED IF A PART IS SINGULAR IN ISSUE
  EA,

  ///USED IF A PART IS ISSUED BY THE HUNDREDS
  HD,

  ///USED IF A PART IS ISSUED BY THE QUART
  QT,

  ///USED IF A PART IS ISSUED BY THE PINT
  PT,

  ///USED IF A PART IS ISSUED BY THE POUND
  LB,

  ///USED IF A PART IS ISSUED BY THE FOOT
  FT,

  ///USED IF A PART  ISSUE IS NOT SPECIFIED OR UNKNOWN
  NOT_SPECIFIED
}
