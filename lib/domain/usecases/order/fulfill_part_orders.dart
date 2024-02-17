import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

class FulfillPartOrdersUsecase
    implements UseCase<void, FulfillPartOrdersParams> {
  const FulfillPartOrdersUsecase(
      PartRepository partRepository, PartOrderRepository partOrderRepository)
      : _partOrderRepository = partOrderRepository,
        _partRepository = partRepository;
  final PartOrderRepository _partOrderRepository;
  final PartRepository _partRepository;
  @override
  Future<Either<Failure, void>> call(FulfillPartOrdersParams params) async {
    if (params.fulfillmentEntities.isEmpty) {
      return const Right<Failure, void>(null);
    }
    for (var orderEntity in params.fulfillmentEntities) {
      var getPartResults =
          await _partRepository.getSpecificPart(orderEntity.partEntityIndex);
      if (getPartResults.isLeft()) {
        continue;
      }

      await getPartResults.fold((l) => null, (part) async {
        await _partRepository.editPart(
            part.copyWith(quantity: part.quantity + orderEntity.orderAmount));
      });

      var orderUpdateResults = await _partOrderRepository.editPartOrder(
          orderEntity.copyWith(
              isFulfilled: true, fulfillmentDate: DateTime.now()));
      if (orderUpdateResults.isLeft()) {
        return const Left<Failure, void>(UpdateDataFailure());
      }
    }

    return const Right<Failure, void>(null);
  }
}

class FulfillPartOrdersParams extends Equatable {
  const FulfillPartOrdersParams({required this.fulfillmentEntities});
  final List<OrderEntity> fulfillmentEntities;

  @override
  List<Object?> get props => [fulfillmentEntities];
}
