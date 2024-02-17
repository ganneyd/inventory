import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';

class GetPartOrderUsecase implements UseCase<OrderEntity, GetPartOrderParams> {
  GetPartOrderUsecase(PartOrderRepository partOrderRepository)
      : _partOrderRepository = partOrderRepository;

  final PartOrderRepository _partOrderRepository;
  @override
  Future<Either<Failure, OrderEntity>> call(params) {
    return _partOrderRepository.getSpecificPartOrder(params.index);
  }
}

class GetPartOrderParams extends Equatable {
  const GetPartOrderParams({required this.index});
  final int index;

  @override
  List<Object?> get props => [index];
}
