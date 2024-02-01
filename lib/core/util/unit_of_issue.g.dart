// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_of_issue.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnitOfIssueAdapter extends TypeAdapter<UnitOfIssue> {
  @override
  final int typeId = 2;

  @override
  UnitOfIssue read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UnitOfIssue.EA;
      case 1:
        return UnitOfIssue.HD;
      case 2:
        return UnitOfIssue.QT;
      case 3:
        return UnitOfIssue.PT;
      case 4:
        return UnitOfIssue.LB;
      case 5:
        return UnitOfIssue.FT;
      case 6:
        return UnitOfIssue.NOT_SPECIFIED;
      default:
        return UnitOfIssue.EA;
    }
  }

  @override
  void write(BinaryWriter writer, UnitOfIssue obj) {
    switch (obj) {
      case UnitOfIssue.EA:
        writer.writeByte(0);
        break;
      case UnitOfIssue.HD:
        writer.writeByte(1);
        break;
      case UnitOfIssue.QT:
        writer.writeByte(2);
        break;
      case UnitOfIssue.PT:
        writer.writeByte(3);
        break;
      case UnitOfIssue.LB:
        writer.writeByte(4);
        break;
      case UnitOfIssue.FT:
        writer.writeByte(5);
        break;
      case UnitOfIssue.NOT_SPECIFIED:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnitOfIssueAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
