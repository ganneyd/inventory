import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';

class AddCheckoutPart implements UseCase<void, AddCheckoutPartParams> {
  const AddCheckoutPart(CheckedOutPartRepository checkedOutPartRepository)
      : _checkedOutPartRepository = checkedOutPartRepository;

  final CheckedOutPartRepository _checkedOutPartRepository;
  @override
  Future<Either<Failure, void>> call(AddCheckoutPartParams params) async {
    var results =
        await _checkedOutPartRepository.createCheckOut(params.checkedOutEntity);
    return results.fold((failure) => Left<Failure, void>(failure),
        (r) => const Right<Failure, void>(null));
  }
}

class AddCheckoutPartParams extends Equatable {
  const AddCheckoutPartParams({required this.checkedOutEntity});
  final CheckedOutEntity checkedOutEntity;

  @override
  List<Object?> get props => [checkedOutEntity];
}
