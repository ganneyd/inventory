import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part_order/part_order_entity.dart';

abstract class PartOrderRepository {
  Future<Either<Failure, void>> createPartOrder(PartOrderEntity orderEntity);
  Future<Either<Failure, PartOrderEntity>> getSpecificPartOrder(
      int orderEntityIndex);
  Future<Either<Failure, List<PartOrderEntity>>> getAllPartOrders(
      int startIndex, int endIndex);
  Future<Either<Failure, void>> editPartOrder(PartOrderEntity orderEntity);
  Future<Either<Failure, void>> deletePartOrder(PartOrderEntity orderEntity);
}
