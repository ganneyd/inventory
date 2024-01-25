import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

class GetPartBySerialNumberUseCase
    implements UseCase<List<PartEntity>, Params> {
  const GetPartBySerialNumberUseCase(PartRepository partRepository)
      : _partRepository = partRepository;

  final PartRepository _partRepository;
  @override
  Future<Either<Failure, List<PartEntity>>> call(Params params) async {
    Either<Failure, List<PartEntity>> usecase =
        await _partRepository.searchPartsByField(
            fieldName: PartRepository.partSerialNumberField,
            queryKey: params.queryKey);

    return usecase.fold(
        (l) => const Left<Failure, List<PartEntity>>(ReadDataFailure()),
        (List<PartEntity> parts) => Right<Failure, List<PartEntity>>(parts));
  }
}

class Params extends Equatable {
  const Params({required this.queryKey});
  final String queryKey;
  @override
  List<Object?> get props => <Object>[queryKey];
}
