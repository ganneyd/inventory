import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/domain/entities/checked-out/cart_check_out_entity.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/checkout/cubit/checkout_state.dart';
import 'package:logging/logging.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({
    required AddCheckoutPart addCheckoutPart,
    required List<CartCheckoutEntity> cartItems,
  })  : _addCheckoutPart = addCheckoutPart,
        _logger = Logger('checkout-part-cubit'),
        super(CheckoutState(cartItems: cartItems));

  final AddCheckoutPart _addCheckoutPart;
  final Logger _logger;
  void init() {
    if (state.cartItems.isEmpty) {
      emit(state.copyWith(status: CheckoutStateStatus.loadedUnsuccessfully));
    }
    emit(state.copyWith(
        error: 'no-parts', status: CheckoutStateStatus.loadedSuccessfully));
  }

  void checkoutCart() async {
    emit(state.copyWith(status: CheckoutStateStatus.checkingOut));
    _logger.finest('checking out ${state.cartItems.length} parts');
    var results = await _addCheckoutPart
        .call(AddCheckoutPartParams(cartItems: state.cartItems));

    results.fold(
        (failure) => emit(state.copyWith(
            status: CheckoutStateStatus.checkedOutUnsuccessfully,
            error: failure.errorMessage)),
        (_) => emit(state.copyWith(
            isCheckoutCompleted: true,
            status: CheckoutStateStatus.checkedOutSuccessfully)));
  }

  void partRetrievalCompleted() {
    emit(state.copyWith(
        cartItems: [],
        isCheckoutCompleted: true,
        status: CheckoutStateStatus.completed));
  }

  void removeCheckoutPart(int checkoutPartIndex) {
    List<CartCheckoutEntity> newCartList = state.cartItems.toList();

    newCartList.removeAt(checkoutPartIndex);

    emit(state.copyWith(cartItems: newCartList));
  }

  void updateCheckoutQuantity(
      {required int cartItemIndex, required int newQuantity}) {
    var cartItem = state.cartItems[cartItemIndex];

    var newCartItem = cartItem.copyWith(
        checkedOutEntity: cartItem.checkedOutEntity
            .copyWith(checkedOutQuantity: newQuantity));
    List<CartCheckoutEntity> newCartList = state.cartItems.toList();
    newCartList[cartItemIndex] = newCartItem;
    emit(state.copyWith(cartItems: newCartList));
  }
}
