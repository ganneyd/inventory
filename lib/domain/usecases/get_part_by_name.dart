import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:logging/logging.dart';

class GetPartByNameUseCase
    implements UseCase<List<PartEntity>, GetAllPartByNameParams> {
  GetPartByNameUseCase(PartRepository partRepository)
      : _partRepository = partRepository,
        _logger = Logger('get-part-by-name-usecase');

  final PartRepository _partRepository;
  final Logger _logger;
  @override
  Future<Either<Failure, List<PartEntity>>> call(
      GetAllPartByNameParams params) async {
    _logger.finest('evoking call to part repo ${PartField.name}');
    Either<Failure, List<PartEntity>> usecase =
        await _partRepository.searchPartsByField(
            fieldName: PartField.name, queryKey: params.queryKey);

    return usecase.fold(
        (l) => const Left<Failure, List<PartEntity>>(ReadDataFailure()),
        (List<PartEntity> parts) => Right<Failure, List<PartEntity>>(parts));
  }
}

class GetAllPartByNameParams extends Equatable {
  const GetAllPartByNameParams({required this.queryKey});
  final String queryKey;
  @override
  List<Object?> get props => <Object>[queryKey];
}
