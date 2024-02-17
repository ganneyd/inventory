import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';

class GetAllPartOrdersUsecase
    implements UseCase<List<OrderEntity>, GetAllPartOrdersParams> {
  const GetAllPartOrdersUsecase(PartOrderRepository partOrderRepository)
      : _partOrderRepository = partOrderRepository;
  final PartOrderRepository _partOrderRepository;
  @override
  Future<Either<Failure, List<OrderEntity>>> call(
      GetAllPartOrdersParams params) {
    var startIndex = params.currentOrderListLength;
    var endIndex = startIndex + params.fetchAmount;

    return _partOrderRepository.getAllPartOrders(startIndex, endIndex);
  }
}

class GetAllPartOrdersParams extends Equatable {
  const GetAllPartOrdersParams(
      {required this.currentOrderListLength, required this.fetchAmount});
  final int currentOrderListLength;
  final int fetchAmount;
  @override
  List<Object?> get props => [currentOrderListLength, fetchAmount];
}
