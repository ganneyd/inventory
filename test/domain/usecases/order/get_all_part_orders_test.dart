import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:inventory_v1/domain/usecases/order/get_all_part_orders.dart';
import 'package:mocktail/mocktail.dart';

class MockPartOrderRepo extends Mock implements PartOrderRepository {}

void main() {
  late MockPartOrderRepo mockPartOrderRepo;
  late GetAllPartOrdersUsecase sut;
  late List<OrderEntity> orderEntityList;

  setUp(() {
    mockPartOrderRepo = MockPartOrderRepo();
    orderEntityList = [
      OrderEntity(
          index: 0,
          partEntityIndex: 0,
          orderAmount: 0,
          orderDate: DateTime.now())
    ];

    sut = GetAllPartOrdersUsecase(mockPartOrderRepo);
  });

  group('.call()', () {
    test('should return right', () async {
      when(() => mockPartOrderRepo.getAllPartOrders(
              any(that: isA<int>()), any(that: isA<int>())))
          .thenAnswer((invocation) async =>
              Right<Failure, List<OrderEntity>>(orderEntityList));
      GetAllPartOrdersParams params = const GetAllPartOrdersParams(
          currentOrderListLength: 10, fetchAmount: 20);
      var results = await sut.call(params);

      var capture = verify(() => mockPartOrderRepo.getAllPartOrders(
          captureAny(that: isA<int>()), captureAny(that: isA<int>()))).captured;
      expect(results, Right<Failure, List<OrderEntity>>(orderEntityList));
      expect(capture.first, params.currentOrderListLength);
      expect(capture.last, params.fetchAmount + params.currentOrderListLength);
    });

    test('should return left', () async {
      when(() => mockPartOrderRepo.getAllPartOrders(
              any(that: isA<int>()), any(that: isA<int>())))
          .thenAnswer((invocation) async =>
              const Left<Failure, List<OrderEntity>>(ReadDataFailure()));
      GetAllPartOrdersParams params = const GetAllPartOrdersParams(
          currentOrderListLength: 10, fetchAmount: 20);
      var results = await sut.call(params);

      var capture = verify(() => mockPartOrderRepo.getAllPartOrders(
          captureAny(that: isA<int>()), captureAny(that: isA<int>()))).captured;
      expect(
          results, const Left<Failure, List<OrderEntity>>(ReadDataFailure()));
      expect(capture.first, params.currentOrderListLength);
      expect(capture.last, params.fetchAmount + params.currentOrderListLength);
    });
  });
}
