import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/exceptions.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/models/part_order/part_order_model.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:logging/logging.dart';

class PartOrderRepositoryImplementation extends PartOrderRepository {
  PartOrderRepositoryImplementation(Box<OrderModel> localDatasource)
      : _localDatasource = localDatasource,
        _logger = Logger('part-order-repo');
  final Box<OrderModel> _localDatasource;
  final Logger _logger;

  @override
  Future<Either<Failure, void>> createPartOrder(OrderEntity orderEntity) async {
    try {
      await _localDatasource.put(orderEntity.index, orderEntity.toModel());
      _logger.finest(
          'added $orderEntity index: ${orderEntity.index} to database database length is ${_localDatasource.length}');
      return const Right<Failure, void>(null);
    } catch (e) {
      _logger.warning('exception occurred ${e.toString()}');
      return const Left<Failure, void>(CreateDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePartOrder(OrderEntity orderEntity) async {
    try {
      _logger.finest('deleting ${orderEntity.index}  ');

      if (_localDatasource.containsKey(orderEntity.index)) {
        await _localDatasource.delete(orderEntity.index);

        return const Right<Failure, void>(null);
      }
      _logger.warning(
          'box does not contain key ${orderEntity.index} only ${_localDatasource.keys}');
      throw Exception();
    } catch (e) {
      return const Left<Failure, void>(DeleteDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editPartOrder(OrderEntity orderEntity) async {
    try {
      await _localDatasource.put(orderEntity.index, orderEntity.toModel());
      _logger.finest(
          'edited ${orderEntity.index} with fulfillment date ${orderEntity.fulfillmentDate}');
      return const Right<Failure, void>(null);
    } catch (e) {
      return const Left<Failure, void>(UpdateDataFailure());
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getAllPartOrders(
      int startIndex, int endIndex) async {
    try {
      if (startIndex >= _localDatasource.length) {
        return const Right<Failure, List<OrderEntity>>([]);
      }
      _logger.finest(endIndex);
      var end = _localDatasource.length - endIndex.abs();
      var upperBound = _localDatasource.length - 1 - startIndex.abs();
      var lowerBound = 0 > end ? 0 : end;

      _logger.finest(
          'getting all parts lowerBound is $lowerBound and upperBound is $upperBound');

      if (lowerBound >= upperBound) {
        _logger.severe(
            'lowerBound is greater than upperBound, throwing exception... ');
        throw IndexOutOfBounds();
      }

      List<OrderEntity> orderList = [];
      for (int i = upperBound; i >= lowerBound; i--) {
        var order = _localDatasource.getAt(i);
        var key = _localDatasource.keyAt(i);
        if (order != null) {
          orderList.add(order.copyWith(index: key));
        }
      }
      _logger.finest('got ${orderList.length} parts from database');

      return Right<Failure, List<OrderEntity>>(orderList.toList());
    } catch (e) {
      return const Left<Failure, List<OrderEntity>>(ReadDataFailure());
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getSpecificPartOrder(
      int orderEntityIndex) async {
    try {
      if (orderEntityIndex.isNegative ||
          orderEntityIndex > _localDatasource.length) {
        throw IndexOutOfBounds;
      }
      var order = _localDatasource.getAt(orderEntityIndex);
      if (order != null) {
        return Right<Failure, OrderEntity>(order);
      }
      throw Exception;
    } catch (e) {
      return const Left<Failure, OrderEntity>(ReadDataFailure());
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getEveryOrderThatMatchesPart(
      int partEntityIndex) async {
    try {
      var orderList = _localDatasource.values
          .where((order) =>
              order.partModelIndex == partEntityIndex &&
              !order.isFulfilledModel)
          .toList();

      return Right<Failure, List<OrderEntity>>(orderList);
    } catch (e) {
      return const Left<Failure, List<OrderEntity>>(ReadDataFailure());
    }
  }
}
