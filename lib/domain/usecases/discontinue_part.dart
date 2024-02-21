import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

class DiscontinuePartUsecase implements UseCase<void, DiscontinuePartParams> {
  const DiscontinuePartUsecase(
      PartOrderRepository partOrderRepository, PartRepository partRepository)
      : _partOrderRepository = partOrderRepository,
        _partRepository = partRepository;
  final PartRepository _partRepository;
  final PartOrderRepository _partOrderRepository;
  @override
  Future<Either<Failure, void>> call(DiscontinuePartParams params) async {
    bool success = true;
    var orderListResults = await _partOrderRepository
        .getEveryOrderThatMatchesPart(params.discontinuedPartEntity.index);
    if (orderListResults.isRight()) {
      var results = await _partRepository.editPart(
          params.discontinuedPartEntity.copyWith(isDiscontinued: true));
      if (results.isLeft()) {
        return const Left<Failure, void>(UpdateDataFailure());
      }
      var orderList = orderListResults.getOrElse(() => []);

      for (var order in orderList) {
        var deleteResults = await _partOrderRepository.deletePartOrder(order);
        success = deleteResults.isRight();
      }

      if (success) {
        return const Right<Failure, void>(null);
      }
    }
    return const Left<Failure, void>(ReadDataFailure());
  }
}

class DiscontinuePartParams extends Equatable {
  const DiscontinuePartParams({required this.discontinuedPartEntity});
  final PartEntity discontinuedPartEntity;

  @override
  List<Object?> get props => [discontinuedPartEntity];
}
