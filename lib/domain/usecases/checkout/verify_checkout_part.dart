import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:logging/logging.dart';

class VerifyCheckoutPart implements UseCase<void, VerifyCheckoutPartParams> {
  VerifyCheckoutPart(CheckedOutPartRepository checkedOutPartRepository)
      : _checkedOutPartRepository = checkedOutPartRepository,
        _logger = Logger('verify-part-usecase');
  final CheckedOutPartRepository _checkedOutPartRepository;
  final Logger _logger;
  @override
  Future<Either<Failure, void>> call(VerifyCheckoutPartParams params) async {
    var date = DateTime.now();
    var updatedCheckoutPart = CheckedOutEntity(
        index: params.checkedOutEntity.index,
        checkedOutQuantity: params.checkedOutEntity.checkedOutQuantity,
        dateTime: params.checkedOutEntity.dateTime,
        part: params.checkedOutEntity.part,
        isVerified: true,
        verifiedDate: DateTime(
          date.year,
          date.month,
          date.day,
          date.hour,
        ));

    var results = await _checkedOutPartRepository.editCheckedOutItem(
      updatedCheckoutPart,
    );
    _logger.finest('verified $updatedCheckoutPart');
    return results.fold((failure) => Left<Failure, void>(failure),
        (r) => const Right<Failure, void>(null));
  }
}

class VerifyCheckoutPartParams extends Equatable {
  const VerifyCheckoutPartParams({required this.checkedOutEntity});
  final CheckedOutEntity checkedOutEntity;

  @override
  List<Object?> get props => [checkedOutEntity];
}
