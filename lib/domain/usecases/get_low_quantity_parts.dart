import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:logging/logging.dart';

class GetLowQuantityParts
    implements UseCase<List<PartEntity>, GetLowQuantityPartsParams> {
  GetLowQuantityParts(PartRepository partRepository)
      : _partRepository = partRepository,
        _logger = Logger('get-low-quantity-parts');

  final PartRepository _partRepository;
  final Logger _logger;
  @override
  Future<Either<Failure, List<PartEntity>>> call(
      GetLowQuantityPartsParams params) async {
    _logger.finest('i was called ');
    var results =
        await _partRepository.getAllParts(params.startIndex, params.endIndex);

    List<PartEntity> parts = [];
    Failure? failure;
    results.fold((fail) => failure = fail, (list) => parts = list);
    if (failure != null) {
      return Left<Failure, List<PartEntity>>(failure ?? const GetFailure());
    }

    List<PartEntity> lowQuantityParts = [];
    _logger.finest('parts length is ${parts.length}');
    for (var part in parts) {
      if (part.quantity <= part.requisitionPoint) {
        _logger.finest('${part.name} matches');
        lowQuantityParts.add(part);
      }
    }
    _logger.finest('retrieved ${lowQuantityParts.length} parts');
    return Right<Failure, List<PartEntity>>(lowQuantityParts);
  }
}

class GetLowQuantityPartsParams extends Equatable {
  const GetLowQuantityPartsParams(
      {required this.endIndex, required this.startIndex});
  final int startIndex;
  final int endIndex;

  @override
  List<Object?> get props => [startIndex, endIndex];
}
