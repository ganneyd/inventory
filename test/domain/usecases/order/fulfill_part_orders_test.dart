import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/order/fulfill_part_orders.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup.dart';

class MockPartRepo extends Mock implements PartRepository {}

class MockPartOrderRepo extends Mock implements PartOrderRepository {}

void main() {
  late MockPartOrderRepo mockPartOrderRepo;
  late MockPartRepo mockPartRepo;
  late FulfillPartOrdersUsecase sut;
  late ValuesForTest valuesForTest;
  late OrderEntity orderEntity;
  setUp(() {
    orderEntity = OrderEntity(
        index: 0,
        partEntityIndex: 0,
        orderAmount: 11,
        orderDate: DateTime.now());
    valuesForTest = ValuesForTest();
    mockPartOrderRepo = MockPartOrderRepo();
    mockPartRepo = MockPartRepo();
    sut = FulfillPartOrdersUsecase(mockPartRepo, mockPartOrderRepo);
    registerFallbackValue(orderEntity);
    registerFallbackValue(valuesForTest.parts()[0]);
  });

  group('.call()', () {
    void mockSetup() {
      when(() => mockPartRepo.getSpecificPart(any(that: isA<int>())))
          .thenAnswer((invocation) =>
              Right<Failure, PartEntity>(valuesForTest.parts()[0]));
      when(() => mockPartOrderRepo.editPartOrder(any(that: isA<OrderEntity>())))
          .thenAnswer((invocation) async {
        return const Right<Failure, void>(null);
      });
      when(() => mockPartRepo.editPart(any(that: isA<PartEntity>())))
          .thenAnswer((invocation) async {
        return const Right<Failure, void>(null);
      });
    }

    test('Should return right', () async {
      mockSetup();
      FulfillPartOrdersParams params =
          FulfillPartOrdersParams(fulfillmentEntities: [
        orderEntity,
        orderEntity,
        orderEntity,
        orderEntity,
        orderEntity,
      ]);
      var results = await sut.call(params);
      expect(results, const Right<Failure, void>(null));
      verify(() =>
              mockPartOrderRepo.editPartOrder(any(that: isA<OrderEntity>())))
          .called(params.fulfillmentEntities.length);
      verify(() => mockPartRepo.getSpecificPart(any(that: isA<int>())))
          .called(params.fulfillmentEntities.length);
      var captured = verify(
              () => mockPartRepo.editPart(captureAny(that: isA<PartEntity>())))
          .captured;
      expect(captured.length, 5);
      var part = captured.first as PartEntity;
      expect(part.quantity,
          valuesForTest.parts()[0].quantity + orderEntity.orderAmount);
    });

    test('Should return Right when .getSpecific() returns a left', () async {
      mockSetup();
      when(() => mockPartRepo.getSpecificPart(any(that: isA<int>())))
          .thenAnswer((invocation) {
        return const Left<Failure, PartEntity>(UpdateDataFailure());
      });
      FulfillPartOrdersParams params =
          FulfillPartOrdersParams(fulfillmentEntities: [
        orderEntity,
        orderEntity,
        orderEntity,
        orderEntity,
        orderEntity,
      ]);
      var results = await sut.call(params);
      expect(results, const Right<Failure, void>(null));
      verifyNever(
          () => mockPartOrderRepo.editPartOrder(any(that: isA<OrderEntity>())));
      verify(() => mockPartRepo.getSpecificPart(any(that: isA<int>())))
          .called(params.fulfillmentEntities.length);
      verifyNever(
          () => mockPartRepo.editPart(captureAny(that: isA<PartEntity>())));
    });

    test('Should return Right when .editParOrder() returns a left', () async {
      mockSetup();
      when(() => mockPartOrderRepo.editPartOrder(any(that: isA<OrderEntity>())))
          .thenAnswer((invocation) async {
        return const Left<Failure, PartEntity>(UpdateDataFailure());
      });
      FulfillPartOrdersParams params =
          FulfillPartOrdersParams(fulfillmentEntities: [orderEntity]);
      var results = await sut.call(params);
      expect(results, const Left<Failure, void>(UpdateDataFailure()));
      verify(() =>
              mockPartOrderRepo.editPartOrder(any(that: isA<OrderEntity>())))
          .called(params.fulfillmentEntities.length);
      verify(() => mockPartRepo.getSpecificPart(any(that: isA<int>())))
          .called(params.fulfillmentEntities.length);
      var capture = verify(
          () => mockPartRepo.editPart(captureAny(that: isA<PartEntity>())));

      var editedPart = capture.captured.first as PartEntity;
      var originalPart = capture.captured.last as PartEntity;

      expect(
          editedPart.quantity,
          valuesForTest
              .parts()[0]
              .copyWith(
                  quantity: valuesForTest.parts()[0].quantity +
                      orderEntity.orderAmount)
              .quantity);
      expect(originalPart, valuesForTest.parts()[0]);
    });
  });
}
