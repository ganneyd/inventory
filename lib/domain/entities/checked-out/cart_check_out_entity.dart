import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';

///Holds a reference to a [PartEntity] and [CheckedOutEntity] to ensure data integretiy
class CartCheckoutEntity {
  CartCheckoutEntity(
      {required this.checkedOutEntity, required this.partEntity});
  final PartEntity partEntity;
  final CheckedOutEntity checkedOutEntity;
}

extension CartCheckoutEntityExtension on CartCheckoutEntity {
  CartCheckoutEntity copyWith(
      {PartEntity? partEntity, CheckedOutEntity? checkedOutEntity}) {
    return CartCheckoutEntity(
        checkedOutEntity: checkedOutEntity ?? this.checkedOutEntity,
        partEntity: partEntity ?? this.partEntity);
  }
}
