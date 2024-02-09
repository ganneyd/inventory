import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';

class GetUnverifiedCheckoutParts
    implements UseCase<List<CheckedOutEntity>, UnverifiedCheckoutPartsParams> {
  const GetUnverifiedCheckoutParts(
      CheckedOutPartRepository checkedOutPartRepository)
      : _checkedOutPartRepository = checkedOutPartRepository;
  final CheckedOutPartRepository _checkedOutPartRepository;
  @override
  Future<Either<Failure, List<CheckedOutEntity>>> call(
      UnverifiedCheckoutPartsParams params) async {
    List<CheckedOutEntity> unverifiedCheckoutParts = [];
    var results = await _checkedOutPartRepository.getCheckedOutItems(
        params.startIndex, params.endIndex);
    return results
        .fold((failure) => Left<Failure, List<CheckedOutEntity>>(failure),
            (checkoutParts) {
      for (var item in checkoutParts) {
        if (item.isVerified ?? false) {
          unverifiedCheckoutParts.add(item);
        }
      }
      return Right<Failure, List<CheckedOutEntity>>(unverifiedCheckoutParts);
    });
  }
}

class UnverifiedCheckoutPartsParams extends Equatable {
  const UnverifiedCheckoutPartsParams(
      {required this.endIndex, required this.startIndex});
  final int startIndex;
  final int endIndex;

  @override
  List<Object?> get props => [startIndex, endIndex];
}
