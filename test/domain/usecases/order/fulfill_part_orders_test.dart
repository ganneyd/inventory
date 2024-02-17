import 'dart:math';

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
        orderAmount: 10,
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
          .thenAnswer((invocation) async =>
              Right<Failure, PartEntity>(valuesForTest.parts()[0]));
      when(() => mockPartOrderRepo.editPartOrder(any(that: isA<OrderEntity>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
      when(() => mockPartRepo.editPart(any(that: isA<PartEntity>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
    }

    test('Should return right', () async {
      mockSetup();
      FulfillPartOrdersParams params = FulfillPartOrdersParams(
          fulfillmentEntities: [
            orderEntity,
            orderEntity,
            orderEntity,
            orderEntity,
            orderEntity
          ]);
      var results = await sut.call(params);
      expect(results, const Right<Failure, void>(null));
      verify(() =>
              mockPartOrderRepo.editPartOrder(any(that: isA<OrderEntity>())))
          .called(params.fulfillmentEntities.length);
      verify(() => mockPartRepo.getSpecificPart(any(that: isA<int>())))
          .called(params.fulfillmentEntities.length);
      verify(() => mockPartRepo.editPart(any(that: isA<PartEntity>())))
          .called(params.fulfillmentEntities.length);
    });
  });
}
