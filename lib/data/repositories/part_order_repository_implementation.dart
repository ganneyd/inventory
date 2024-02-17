import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/exceptions.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/models/part_order/part_order_model.dart';
import 'package:inventory_v1/domain/entities/part_order/part_order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:logging/logging.dart';

class PartOrderRepositoryImplementation extends PartOrderRepository {
  PartOrderRepositoryImplementation(Box<PartOrderModel> localDatasource)
      : _localDatasource = localDatasource,
        _logger = Logger('part-order-repo');
  final Box<PartOrderModel> _localDatasource;
  final Logger _logger;

  @override
  Future<Either<Failure, void>> createPartOrder(
      PartOrderEntity orderEntity) async {
    try {
      var index = _localDatasource.isEmpty ? 0 : _localDatasource.length;
      _logger.finest('added $orderEntity to database');
      _localDatasource.add(orderEntity.copyWith(index: index).toModel());
      return const Right<Failure, void>(null);
    } catch (e) {
      return const Left<Failure, void>(CreateDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePartOrder(
      PartOrderEntity orderEntity) async {
    try {
      _localDatasource.deleteAt(orderEntity.index);
      return const Right<Failure, void>(null);
    } catch (e) {
      return const Left<Failure, void>(DeleteDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editPartOrder(
      PartOrderEntity orderEntity) async {
    try {
      _localDatasource.put(orderEntity.index, orderEntity.toModel());
      return const Right<Failure, void>(null);
    } catch (e) {
      return const Left<Failure, void>(UpdateDataFailure());
    }
  }

  @override
  Future<Either<Failure, List<PartOrderEntity>>> getAllPartOrders(
      int startIndex, int endIndex) async {
    try {
      if (startIndex > endIndex ||
          startIndex.isNegative ||
          endIndex.isNegative) {
        throw IndexOutOfBounds;
      }
      var orderList = _localDatasource.valuesBetween(
          startKey: startIndex, endKey: endIndex);
      var updatedIndexList = orderList
          .map((order) => order.copyWith(index: startIndex++))
          .toList();
      return Right<Failure, List<PartOrderEntity>>(updatedIndexList);
    } catch (e) {
      return const Left<Failure, List<PartOrderEntity>>(ReadDataFailure());
    }
  }

  @override
  Future<Either<Failure, PartOrderEntity>> getSpecificPartOrder(
      int orderEntityIndex) async {
    try {
      if (orderEntityIndex.isNegative ||
          orderEntityIndex > _localDatasource.length) {
        throw IndexOutOfBounds;
      }
      var order = _localDatasource.getAt(orderEntityIndex);
      if (order != null) {
        return Right<Failure, PartOrderEntity>(order);
      }
      throw Exception;
    } catch (e) {
      return const Left<Failure, PartOrderEntity>(ReadDataFailure());
    }
  }
}
