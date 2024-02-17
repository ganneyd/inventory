import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:logging/logging.dart';

class VerifyCheckoutPart implements UseCase<void, VerifyCheckoutPartParams> {
  VerifyCheckoutPart(CheckedOutPartRepository checkedOutPartRepository,
      PartRepository partRepository)
      : _checkedOutPartRepository = checkedOutPartRepository,
        _partRepository = partRepository,
        _logger = Logger('verify-part-usecase');
  final CheckedOutPartRepository _checkedOutPartRepository;
  final PartRepository _partRepository;
  final Logger _logger;

  @override
  Future<Either<Failure, void>> call(VerifyCheckoutPartParams params) async {
    for (var checkoutPart in params.checkedOutEntityList) {
      var getPart =
          await _partRepository.getSpecificPart(checkoutPart.partEntityIndex);
      if (getPart.isLeft()) {
        return const Left<Failure, void>(ReadDataFailure());
      }

      getPart.fold((l) => null, (updatedPart) async {
        _partRepository.editPart(updatedPart.copyWith(
            quantity: updatedPart.quantity - checkoutPart.quantityDiscrepancy));
      });

      var updatedCheckoutPart =
          checkoutPart.copyWith(verifiedDate: DateTime.now(), isVerified: true);
      var result = await _checkedOutPartRepository
          .editCheckedOutItem(updatedCheckoutPart);
      if (result.isLeft()) {
        _logger.warning('error encounter when updating check out part');
        return const Left<Failure, void>(UpdateDataFailure());
      }
    }

    return const Right<Failure, void>(null);
  }
}

class VerifyCheckoutPartParams extends Equatable {
  const VerifyCheckoutPartParams({
    required this.checkedOutEntityList,
  });
  final List<CheckedOutEntity> checkedOutEntityList;
  @override
  List<Object?> get props => [checkedOutEntityList];
}
