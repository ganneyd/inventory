// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 4;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      indexModel: fields[0] as int,
      partModelIndex: fields[1] as int,
      orderAmountModel: fields[2] as int,
      orderDateModel: fields[3] as DateTime,
      isFulfilledModel: fields[4] as bool,
      fulfillmentDateModel: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.indexModel)
      ..writeByte(1)
      ..write(obj.partModelIndex)
      ..writeByte(2)
      ..write(obj.orderAmountModel)
      ..writeByte(3)
      ..write(obj.orderDateModel)
      ..writeByte(4)
      ..write(obj.isFulfilledModel)
      ..writeByte(5)
      ..write(obj.fulfillmentDateModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
