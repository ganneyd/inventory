import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/models/part/part_model.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:logging/logging.dart';

class GetPartBySerialNumberUsecase
    implements UseCase<List<Part>, GetAllPartBySerialNumberParams> {
  GetPartBySerialNumberUsecase(PartRepository partRepository)
      : _partRepository = partRepository,
        _logger = Logger('get-part-by-serial-number-usecase');

  final PartRepository _partRepository;
  final Logger _logger;
  @override
  Future<Either<Failure, List<Part>>> call(
      GetAllPartBySerialNumberParams params) async {
    _logger.finest('evoking call to part repo ${PartField.serialNumber}');
    Either<Failure, List<PartEntity>> usecase =
        await _partRepository.searchPartsByField(
            fieldName: PartField.serialNumber, queryKey: params.queryKey);

    return usecase.fold(
        (l) => const Left<Failure, List<Part>>(ReadDataFailure()),
        (List<PartEntity> parts) =>
            Right<Failure, List<Part>>(_partRepository.toPartList(parts)));
  }
}

class GetAllPartBySerialNumberParams extends Equatable {
  const GetAllPartBySerialNumberParams({required this.queryKey});
  final String queryKey;
  @override
  List<Object?> get props => <Object>[queryKey];
}
