import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:logging/logging.dart';

class GetPartByNsnUseCase
    implements UseCase<List<PartEntity>, GetAllPartByNsnParams> {
  GetPartByNsnUseCase(PartRepository partRepository)
      : _partRepository = partRepository,
        _logger = Logger('get-part-by-nsn-usecase');

  final PartRepository _partRepository;
  final Logger _logger;
  @override
  Future<Either<Failure, List<PartEntity>>> call(
      GetAllPartByNsnParams params) async {
    _logger.finest('evoking call to part repo ${PartField.nsn}');
    Either<Failure, List<PartEntity>> usecase =
        await _partRepository.searchPartsByField(
            fieldName: PartField.nsn, queryKey: params.queryKey);

    return usecase.fold(
        (l) => const Left<Failure, List<PartEntity>>(ReadDataFailure()),
        (List<PartEntity> parts) => Right<Failure, List<PartEntity>>(parts));
  }
}

class GetAllPartByNsnParams extends Equatable {
  const GetAllPartByNsnParams({required this.queryKey});
  final String queryKey;
  @override
  List<Object?> get props => <Object>[queryKey];
}
