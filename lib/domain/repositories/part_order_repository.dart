import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';

abstract class PartOrderRepository {
  ///creates a order part in the repo
  Future<Either<Failure, void>> createPartOrder(OrderEntity orderEntity);

  ///retrieves a specific order from the database based on the index
  Future<Either<Failure, OrderEntity>> getSpecificPartOrder(
      int orderEntityIndex);

  ///retrieves all the orders between the [startIndex] anf [endIndex]
  Future<Either<Failure, List<OrderEntity>>> getAllPartOrders(
      int startIndex, int endIndex);

  ///edits the [orderEntity] in the database
  Future<Either<Failure, void>> editPartOrder(OrderEntity orderEntity);

  ///deletes the particular orderEntity in the database
  Future<Either<Failure, void>> deletePartOrder(OrderEntity orderEntity);
}
