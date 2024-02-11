import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
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
      var newCheckoutPart = CheckedOutEntity(
          checkedOutQuantity: checkoutPart.checkedOutQuantity,
          dateTime: DateTime.now(),
          part: checkoutPart.part);

      var part = newCheckoutPart.part;
      var editPart = PartEntity(
          index: part.index,
          name: part.name,
          nsn: part.nsn,
          partNumber: part.partNumber,
          location: part.location,
          quantity: part.quantity - checkoutPart.checkedOutQuantity,
          requisitionPoint: part.requisitionPoint,
          requisitionQuantity: part.requisitionQuantity,
          serialNumber: part.serialNumber,
          unitOfIssue: part.unitOfIssue);

      var updatePartResults =
          await _editPartUsecase(EditPartParams(partEntity: editPart));
      if (updatePartResults.isLeft()) {
        return updatePartResults.fold((failure) => Left<Failure, void>(failure),
            (r) => const Right<Failure, void>(null));
      }
      updatePartResults.fold((failure) => null, (r) async {
        var results =
            await _checkedOutPartRepository.createCheckOut(newCheckoutPart);
        if (results.isLeft()) {
          return results.fold((failure) => Left<Failure, void>(failure),
              (r) => const Right<Failure, void>(null));
        }
      });
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
