import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/discontinue_part.dart';
import 'package:mocktail/mocktail.dart';

import '../../setup.dart';

class MockPartRepository extends Mock implements PartRepository {}

class MockPartOrderRepository extends Mock implements PartOrderRepository {}

void main() {
  late MockPartRepository mockPartRepository;
  late MockPartOrderRepository mockPartOrderRepository;
  late DiscontinuePartUsecase sut;
  late ValuesForTest valuesForTest;
  late List<OrderEntity> typicalList;
  setUp(() {
    mockPartOrderRepository = MockPartOrderRepository();
    mockPartRepository = MockPartRepository();
    sut = DiscontinuePartUsecase(mockPartOrderRepository, mockPartRepository);

    valuesForTest = ValuesForTest();
    typicalList = valuesForTest.getOrders();
    registerFallbackValue(valuesForTest.parts()[0]);
    registerFallbackValue(valuesForTest.getOrders()[0]);
  });

  group('.call()', () {
    void mockSetup() {
      when(() => mockPartOrderRepository
              .getEveryOrderThatMatchesPart(any(that: isA<int>())))
          .thenAnswer(
              (_) async => Right<Failure, List<OrderEntity>>(typicalList));
      when(() => mockPartOrderRepository
              .deletePartOrder(any(that: isA<OrderEntity>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
      when(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
    }

    test('should return Right during normal scenario', () async {
      mockSetup();
      var discontinuedPart = valuesForTest.parts()[0];
      var results = await sut.call(
          DiscontinuePartParams(discontinuedPartEntity: discontinuedPart));

      expect(results, const Right<Failure, void>(null));
      var captureMatch = verify(() => mockPartOrderRepository
          .getEveryOrderThatMatchesPart(captureAny(that: isA<int>()))).captured;
      var capturePartEntity = verify(() =>
              mockPartRepository.editPart(captureAny(that: isA<PartEntity>())))
          .captured;
      verify(() => mockPartOrderRepository.deletePartOrder(
          any(that: isA<OrderEntity>()))).called(typicalList.length);
      var partIndex = captureMatch.first as int;
      var editedPart = capturePartEntity.first as PartEntity;
      expect(partIndex, discontinuedPart.index);
      expect(editedPart.isDiscontinued, true);
    });
    test('should return Right when returned list is empty', () async {
      mockSetup();
      when(() => mockPartOrderRepository
              .getEveryOrderThatMatchesPart(any(that: isA<int>())))
          .thenAnswer((_) async => const Right<Failure, List<OrderEntity>>([]));
      var discontinuedPart = valuesForTest.parts()[0];
      var results = await sut.call(
          DiscontinuePartParams(discontinuedPartEntity: discontinuedPart));

      expect(results, const Right<Failure, void>(null));
      var captureMatch = verify(() => mockPartOrderRepository
          .getEveryOrderThatMatchesPart(captureAny(that: isA<int>()))).captured;
      var capturePartEntity = verify(() =>
              mockPartRepository.editPart(captureAny(that: isA<PartEntity>())))
          .captured;
      verifyNever(() => mockPartOrderRepository
          .deletePartOrder(any(that: isA<OrderEntity>())));
      var partIndex = captureMatch.first as int;
      var editedPart = capturePartEntity.first as PartEntity;
      expect(partIndex, discontinuedPart.index);
      expect(editedPart.isDiscontinued, true);
    });

    test('should return Left when orderList results in Failure', () async {
      mockSetup();
      when(() => mockPartOrderRepository
              .getEveryOrderThatMatchesPart(any(that: isA<int>())))
          .thenAnswer((invocation) async =>
              const Left<Failure, List<OrderEntity>>(GetFailure()));
      var discontinuedPart = valuesForTest.parts()[0];
      var results = await sut.call(
          DiscontinuePartParams(discontinuedPartEntity: discontinuedPart));

      expect(results, const Left<Failure, void>(ReadDataFailure()));
      verify(() => mockPartOrderRepository.getEveryOrderThatMatchesPart(
          captureAny(that: isA<int>()))).called(1);
      verifyNever(() =>
          mockPartRepository.editPart(captureAny(that: isA<PartEntity>())));
      verifyNever(() => mockPartOrderRepository
          .deletePartOrder(any(that: isA<OrderEntity>())));
    });

    test('should return Left when editPart results in Failure', () async {
      mockSetup();
      when(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .thenAnswer(
              (invocation) async => const Left<Failure, void>(GetFailure()));
      var discontinuedPart = valuesForTest.parts()[0];
      var results = await sut.call(
          DiscontinuePartParams(discontinuedPartEntity: discontinuedPart));

      expect(results, const Left<Failure, void>(UpdateDataFailure()));
      verify(() => mockPartOrderRepository.getEveryOrderThatMatchesPart(
          captureAny(that: isA<int>()))).called(1);
      verify(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .called(1);
      verifyNever(() => mockPartOrderRepository
          .deletePartOrder(any(that: isA<OrderEntity>())));
    });

    test('should return Left when deleteOrder results in Failure', () async {
      mockSetup();
      when(() => mockPartOrderRepository
              .deletePartOrder(any(that: isA<OrderEntity>())))
          .thenAnswer(
              (invocation) async => const Left<Failure, void>(GetFailure()));
      var discontinuedPart = valuesForTest.parts()[0];
      var results = await sut.call(
          DiscontinuePartParams(discontinuedPartEntity: discontinuedPart));

      expect(results, const Left<Failure, void>(ReadDataFailure()));
      verify(() => mockPartOrderRepository.getEveryOrderThatMatchesPart(
          captureAny(that: isA<int>()))).called(1);
      verify(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .called(1);
      verify(() => mockPartOrderRepository.deletePartOrder(
          any(that: isA<OrderEntity>()))).called(typicalList.length);
    });
  });
}
