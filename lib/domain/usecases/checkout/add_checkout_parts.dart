import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/usecases/edit_part.dart';
import 'package:logging/logging.dart';

class AddCheckoutPart implements UseCase<void, AddCheckoutPartParams> {
  AddCheckoutPart(CheckedOutPartRepository checkedOutPartRepository,
      EditPartUsecase editPartUsecase)
      : _checkedOutPartRepository = checkedOutPartRepository,
        _editPartUsecase = editPartUsecase,
        _logger = Logger('add-checkout-parts-usecase');

  final CheckedOutPartRepository _checkedOutPartRepository;
  final EditPartUsecase _editPartUsecase;
  final Logger _logger;
  @override
  Future<Either<Failure, void>> call(AddCheckoutPartParams params) async {
    if (params.checkoutParts.isEmpty) {
      return const Right<Failure, void>(null);
    }
    for (var checkoutPart in params.checkoutParts) {
      _logger.finest('adding ${checkoutPart.part.name} to checkout box');

      var part = checkoutPart.part;
      var newPart = part.copyWith(
          quantity: part.quantity - checkoutPart.checkedOutQuantity);

      var updatePartResults = await _editPartUsecase(
          EditPartParams(partEntity: newPart.updateChecksum()));
      if (updatePartResults.isLeft()) {
        return Left<Failure, void>(CreateDataFailure());
      }

      var results = await _checkedOutPartRepository.createCheckOut(
          checkoutPart.copyWith(
              dateTime: DateTime.now(),
              partEntity: newPart,
              checkedOutQuantity: checkoutPart.checkedOutQuantity));
      if (results.isLeft()) {
        return Left<Failure, void>(CreateDataFailure());
      }
    }
    return const Right<Failure, void>(null);
  }
}

class AddCheckoutPartParams extends Equatable {
  const AddCheckoutPartParams({required this.checkoutParts});
  final List<CheckedOutEntity> checkoutParts;

  @override
  List<Object?> get props => [checkoutParts];
}
