import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:logging/logging.dart';

class DiscontinuePartUsecase implements UseCase<void, DiscontinuePartParams> {
  DiscontinuePartUsecase(
      PartOrderRepository partOrderRepository, PartRepository partRepository)
      : _partOrderRepository = partOrderRepository,
        _partRepository = partRepository,
        _logger = Logger('discontinue-part-usecase');
  final PartRepository _partRepository;
  final PartOrderRepository _partOrderRepository;
  final Logger _logger;
  @override
  Future<Either<Failure, void>> call(DiscontinuePartParams params) async {
    bool success = true;
    var orderListResults = await _partOrderRepository
        .getEveryOrderThatMatchesPart(params.discontinuedPartEntity.index);
    if (orderListResults.isRight()) {
      var results = await _partRepository.editPart(
          params.discontinuedPartEntity.copyWith(isDiscontinued: true));
      if (results.isLeft()) {
        _logger.warning(
            'failure encounter while editing  part ${params.discontinuedPartEntity.index}');
        return const Left<Failure, void>(UpdateDataFailure());
      }
      _logger.finest('edited part successfully');
      var orderList = orderListResults.getOrElse(() => []);

      for (var order in orderList) {
        var deleteResults = await _partOrderRepository.deletePartOrder(order);
        success = deleteResults.isRight();
      }

      if (success) {
        _logger.finest('deleted all orders related to list');
        return const Right<Failure, void>(null);
      }
      _logger.warning(
          'failure encounter while deleting orders ${orderList.length}');
    }
    _logger.warning(
        'failure encounter while retrieving order list for part ${params.discontinuedPartEntity.index}');
    return const Left<Failure, void>(ReadDataFailure());
  }
}

class DiscontinuePartParams extends Equatable {
  const DiscontinuePartParams({required this.discontinuedPartEntity});
  final PartEntity discontinuedPartEntity;

  @override
  List<Object?> get props => [discontinuedPartEntity];
}
