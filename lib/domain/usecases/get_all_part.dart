import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

class GetAllPartsUsecase
    implements UseCase<List<PartEntity>, GetAllPartParams> {
  const GetAllPartsUsecase(PartRepository partRepository)
      : _partRepository = partRepository;

  final PartRepository _partRepository;
  @override
  Future<Either<Failure, List<PartEntity>>> call(
      GetAllPartParams params) async {
    Either<Failure, List<PartEntity>> usecase =
        await _partRepository.getAllParts(params.startIndex, params.pageIndex);

    return usecase
        .fold((l) => const Left<Failure, List<PartEntity>>(ReadDataFailure()),
            (List<PartEntity> parts) {
      return Right<Failure, List<PartEntity>>(parts);
    });
  }
}

class GetAllPartParams extends Equatable {
  const GetAllPartParams({required this.pageIndex, required this.startIndex});
  final int startIndex;
  final int pageIndex;
  @override
  List<Object?> get props => <Object>[startIndex, pageIndex];
}
