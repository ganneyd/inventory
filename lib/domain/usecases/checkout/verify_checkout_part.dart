import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/usecases/edit_part.dart';
import 'package:logging/logging.dart';

class VerifyCheckoutPart implements UseCase<void, VerifyCheckoutPartParams> {
  VerifyCheckoutPart(CheckedOutPartRepository checkedOutPartRepository,
      EditPartUsecase editPartUsecase)
      : _checkedOutPartRepository = checkedOutPartRepository,
        _editPartUsecase = editPartUsecase,
        _logger = Logger('verify-part-usecase');
  final CheckedOutPartRepository _checkedOutPartRepository;
  final EditPartUsecase _editPartUsecase;
  final Logger _logger;

  @override
  Future<Either<Failure, void>> call(VerifyCheckoutPartParams params) async {
    for (var checkoutPart in params.checkedOutEntityList) {
      PartEntity updatedPart = checkoutPart.part;

      var updatePartResults =
          await _editPartUsecase.call(EditPartParams(partEntity: updatedPart));
      if (updatePartResults.isLeft()) {
        _logger.warning('error encounter when updating part');
        return const Left<Failure, void>(UpdateDataFailure());
      }

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
