import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';

class VerifyCheckoutPart implements UseCase<void, VerifyCheckoutPartParams> {
  const VerifyCheckoutPart(CheckedOutPartRepository checkedOutPartRepository)
      : _checkedOutPartRepository = checkedOutPartRepository;
  final CheckedOutPartRepository _checkedOutPartRepository;
  @override
  Future<Either<Failure, void>> call(VerifyCheckoutPartParams params) async {
    var updatedCheckoutPart = CheckedOutEntity(
        checkedOutQuantity: params.checkedOutEntity.checkedOutQuantity,
        dateTime: params.checkedOutEntity.dateTime,
        part: params.checkedOutEntity.part,
        isVerified: true,
        verifiedDate: DateTime.now());

    var results =
        await _checkedOutPartRepository.editCheckedOutItem(updatedCheckoutPart);

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
