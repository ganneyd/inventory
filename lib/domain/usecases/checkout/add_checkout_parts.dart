import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/checked-out/cart_check_out_entity.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

import 'package:logging/logging.dart';

class AddCheckoutPart implements UseCase<void, AddCheckoutPartParams> {
  AddCheckoutPart(CheckedOutPartRepository checkedOutPartRepository,
      PartRepository partRepository)
      : _checkedOutPartRepository = checkedOutPartRepository,
        _partRepository = partRepository,
        _logger = Logger('add-checkout-parts-usecase');

  final CheckedOutPartRepository _checkedOutPartRepository;
  final PartRepository _partRepository;
  final Logger _logger;
  @override
  Future<Either<Failure, void>> call(AddCheckoutPartParams params) async {
    if (params.cartItems.isEmpty) {
      return const Right<Failure, void>(null);
    }
    for (var cartItem in params.cartItems) {
      _logger.finest(
          'adding ${cartItem.checkedOutEntity.checkoutUser} to checkout box');
      var editPartResults = await _partRepository.editPart(cartItem.partEntity
          .copyWith(
              quantity: cartItem.partEntity.quantity -
                  cartItem.checkedOutEntity.checkedOutQuantity));
      if (editPartResults.isLeft()) {
        _logger.warning('failed to edit part');
        continue;
      }
      var results = await _checkedOutPartRepository.createCheckOut(
          cartItem.checkedOutEntity.copyWith(dateTime: DateTime.now()));

      if (results.isLeft()) {
        _logger.warning('failed to create checkout entity');
        return const Left<Failure, void>(CreateDataFailure());
      }
      _logger.finest(
          ' created checkout entity belonging to ${cartItem.checkedOutEntity.checkoutUser}');
    }
    return const Right<Failure, void>(null);
  }
}

class AddCheckoutPartParams extends Equatable {
  const AddCheckoutPartParams({required this.cartItems});
  final List<CartCheckoutEntity> cartItems;

  @override
  List<Object?> get props => [cartItems];
}
