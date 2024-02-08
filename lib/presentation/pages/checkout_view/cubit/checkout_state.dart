import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';

part 'checkout_state.freezed.dart';

//the different states the add_part page can be in
enum CheckoutStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  checkingOut,
  checkedOutSuccessfully,
  checkedOutUnsuccessfully
}

@freezed
class CheckoutState with _$CheckoutState {
  factory CheckoutState({
    PartEntity? part,
    String? error,
    @Default(CheckoutStateStatus.loading)
    CheckoutStateStatus checkoutStateStatus,
  }) = _AddPartState;
}
