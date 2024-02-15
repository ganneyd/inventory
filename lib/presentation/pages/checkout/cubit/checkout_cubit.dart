import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/checkout/cubit/checkout_state.dart';
import 'package:logging/logging.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit(
      {required AddCheckoutPart addCheckoutPart,
      required List<CheckedOutEntity> cartItems})
      : _addCheckoutPart = addCheckoutPart,
        _cartItems = cartItems,
        _logger = Logger('checkout-part-cubit'),
        super(CheckoutState());

  final AddCheckoutPart _addCheckoutPart;
  final Logger _logger;
  final List<CheckedOutEntity> _cartItems;

  void init() {
    emit(state.copyWith(
        status: CheckoutStateStatus.loadedSuccessfully,
        checkoutParts: _cartItems));
  }

  void checkoutCart() async {
    emit(state.copyWith(status: CheckoutStateStatus.checkingOut));
    _logger.finest('checking out ${state.checkoutParts.length} parts');
    var results = await _addCheckoutPart
        .call(AddCheckoutPartParams(checkoutParts: state.checkoutParts));

    results.fold(
        (failure) => emit(state.copyWith(
            status: CheckoutStateStatus.checkedOutUnsuccessfully,
            error: failure.errorMessage)),
        (_) => emit(state.copyWith(
            checkoutParts: [],
            status: CheckoutStateStatus.checkedOutSuccessfully)));
  }

  void removeCheckoutPart(int checkoutPartIndex) {
    List<CheckedOutEntity> newCartList = state.checkoutParts.toList();

    newCartList.removeAt(checkoutPartIndex);

    emit(state.copyWith(checkoutParts: newCartList));
  }

  void updateCheckoutQuantity(
      {required int checkoutPartIndex, required int newQuantity}) {
    var checkoutPart = state.checkoutParts[checkoutPartIndex];

    var newCheckOutPart =
        checkoutPart.copyWith(checkedOutQuantity: newQuantity);
    List<CheckedOutEntity> newCartList = state.checkoutParts.toList();
    newCartList[checkoutPartIndex] = newCheckOutPart;
    emit(state.copyWith(checkoutParts: newCartList));
  }
}
