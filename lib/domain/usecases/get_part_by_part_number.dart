import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

class GetPartByPartNumberUsecase
    implements UseCase<List<PartEntity>, GetAllPartByPartNumberParams> {
  const GetPartByPartNumberUsecase(PartRepository partRepository)
      : _partRepository = partRepository;

  final PartRepository _partRepository;
  @override
  Future<Either<Failure, List<PartEntity>>> call(
      GetAllPartByPartNumberParams params) async {
    Either<Failure, List<PartEntity>> usecase =
        await _partRepository.searchPartsByField(
            fieldName: PartRepository.partNumberField,
            queryKey: params.queryKey);

    return usecase.fold(
        (l) => const Left<Failure, List<PartEntity>>(ReadDataFailure()),
        (List<PartEntity> parts) => Right<Failure, List<PartEntity>>(parts));
  }
}

class GetAllPartByPartNumberParams extends Equatable {
  const GetAllPartByPartNumberParams({required this.queryKey});
  final String queryKey;
  @override
  List<Object?> get props => <Object>[queryKey];
}
