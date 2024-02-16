import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';

class GetAllCheckoutParts
    implements UseCase<List<CheckedOutEntity>, GetAllCheckoutPartsParams> {
  const GetAllCheckoutParts(CheckedOutPartRepository checkedOutPartRepository)
      : _checkedOutPartRepository = checkedOutPartRepository;
  final CheckedOutPartRepository _checkedOutPartRepository;
  @override
  Future<Either<Failure, List<CheckedOutEntity>>> call(
      GetAllCheckoutPartsParams params) async {
    var lengthResult = await _checkedOutPartRepository.getDatabaseLength();
    int length = 0;
    lengthResult.fold((l) => null, (dbLength) => length = dbLength);
    var endIndex = length - params.currentListLength - params.fetchAmount;

    if (params.currentListLength >= length) {
      return const Right<Failure, List<CheckedOutEntity>>([]);
    }
    var results = await _checkedOutPartRepository.getCheckedOutItems(
        params.currentListLength, endIndex);

    return results.fold(
        (failure) => Left<Failure, List<CheckedOutEntity>>(failure),
        (checkoutParts) =>
            Right<Failure, List<CheckedOutEntity>>(checkoutParts));
  }
}

class GetAllCheckoutPartsParams extends Equatable {
  const GetAllCheckoutPartsParams(
      {required this.fetchAmount, required this.currentListLength});
  final int currentListLength;
  final int fetchAmount;

  @override
  List<Object?> get props => [fetchAmount, currentListLength];
}
