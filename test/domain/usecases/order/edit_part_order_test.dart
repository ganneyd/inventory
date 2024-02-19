import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:inventory_v1/domain/usecases/order/edit_part_order.dart';
import 'package:mocktail/mocktail.dart';

class MockPartOrderRepo extends Mock implements PartOrderRepository {}

void main() {
  late MockPartOrderRepo mockPartOrderRepo;
  late EditPartOrderUsecase sut;
  late OrderEntity orderEntity;

  setUp(() {
    mockPartOrderRepo = MockPartOrderRepo();
    orderEntity = OrderEntity(
        index: 0,
        partEntityIndex: 0,
        orderAmount: 20,
        orderDate: DateTime.now());

    sut = EditPartOrderUsecase(mockPartOrderRepo);
  });

  group('.call()', () {
    test('should return right', () async {
      when(() => mockPartOrderRepo.editPartOrder(orderEntity))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));

      var results =
          await sut.call(EditPartOrderParams(orderEntity: orderEntity));

      verify(() => mockPartOrderRepo.editPartOrder(orderEntity)).called(1);
      expect(results, const Right<Failure, void>(null));
    });

    test('should return left', () async {
      when(() => mockPartOrderRepo.editPartOrder(orderEntity)).thenAnswer(
          (invocation) async => const Left<Failure, void>(UpdateDataFailure()));

      var results =
          await sut.call(EditPartOrderParams(orderEntity: orderEntity));

      verify(() => mockPartOrderRepo.editPartOrder(orderEntity)).called(1);
      expect(results, const Left<Failure, void>(UpdateDataFailure()));
    });
  });
}
