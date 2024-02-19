import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:inventory_v1/domain/usecases/order/get_part_order.dart';
import 'package:mocktail/mocktail.dart';

class MockPartOrderRepo extends Mock implements PartOrderRepository {}

void main() {
  late MockPartOrderRepo mockPartOrderRepo;
  late GetPartOrderUsecase sut;
  late OrderEntity orderEntity;
  setUp(() {
    mockPartOrderRepo = MockPartOrderRepo();
    sut = GetPartOrderUsecase(mockPartOrderRepo);
    orderEntity = OrderEntity(
        index: 0,
        partEntityIndex: 0,
        orderAmount: 10,
        orderDate: DateTime.now());
    registerFallbackValue(orderEntity);
  });

  group('.call()', () {
    test('should return right', () async {
      when(() => mockPartOrderRepo.getSpecificPartOrder(any(that: isA<int>())))
          .thenAnswer(
              (invocation) async => Right<Failure, OrderEntity>(orderEntity));
      var results = await sut.call(const GetPartOrderParams(index: 0));
      expect(results, Right<Failure, OrderEntity>(orderEntity));
      verify(() =>
              mockPartOrderRepo.getSpecificPartOrder(any(that: isA<int>())))
          .called(1);
    });
    test('should return left', () async {
      when(() => mockPartOrderRepo.getSpecificPartOrder(any(that: isA<int>())))
          .thenAnswer((invocation) async =>
              const Left<Failure, OrderEntity>(ReadDataFailure()));
      var results = await sut.call(const GetPartOrderParams(index: 0));
      expect(results, const Left<Failure, OrderEntity>(ReadDataFailure()));
      verify(() =>
              mockPartOrderRepo.getSpecificPartOrder(any(that: isA<int>())))
          .called(1);
    });
  });
}
