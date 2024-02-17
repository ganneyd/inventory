import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';

class CreatePartOrderUsecase implements UseCase<void, CreatePartOrderParams> {
  CreatePartOrderUsecase(PartOrderRepository partOrderRepository)
      : _partOrderRepository = partOrderRepository;
  final PartOrderRepository _partOrderRepository;
  @override
  Future<Either<Failure, void>> call(CreatePartOrderParams params) async {
    return await _partOrderRepository.createPartOrder(params.orderEntity);
  }
}

class CreatePartOrderParams extends Equatable {
  const CreatePartOrderParams({required this.orderEntity});

  final OrderEntity orderEntity;

  @override
  List<Object?> get props => [orderEntity];
}
