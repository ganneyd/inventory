import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';

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
    @Default(<CheckedOutEntity>[]) List<CheckedOutEntity> checkoutParts,
    @Default('') String error,
    @Default(CheckoutStateStatus.loading) CheckoutStateStatus status,
  }) = _AddPartState;
}
