import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

class GetAllPartsUsecase
    implements UseCase<List<PartEntity>, GetAllPartParams> {
  const GetAllPartsUsecase(PartRepository partRepository)
      : _partRepository = partRepository;

  final PartRepository _partRepository;
  @override
  Future<Either<Failure, List<PartEntity>>> call(
      GetAllPartParams params) async {
    var startIndex = params.currentDatabaseLength;
    var endIndex = startIndex + params.fetchAmount;
    var results = await _partRepository.getAllParts(startIndex, endIndex);

    return results
        .fold((l) => const Left<Failure, List<PartEntity>>(ReadDataFailure()),
            (List<PartEntity> parts) {
      return Right<Failure, List<PartEntity>>(parts);
    });
  }
}

class GetAllPartParams extends Equatable {
  const GetAllPartParams(
      {required this.currentDatabaseLength, required this.fetchAmount});
  final int currentDatabaseLength;
  final int fetchAmount;
  @override
  List<Object?> get props => <Object>[currentDatabaseLength, fetchAmount];
}
