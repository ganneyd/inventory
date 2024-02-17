import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/models/part_order/part_order_model.dart';
import 'package:inventory_v1/data/repositories/part_order_repository_implementation.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/repositories/part_order_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockBox extends Mock implements Box<OrderModel> {}

void main() {
  late MockBox mockBox;
  late PartOrderRepository sut;
  late OrderModel orderModel;

  setUp(() {
    orderModel = OrderModel(
        indexModel: 0,
        partModelIndex: 0,
        orderAmountModel: 30,
        orderDateModel: DateTime.now().subtract(const Duration(days: 20)),
        isFulfilledModel: false,
        fulfillmentDateModel: DateTime.now());
    mockBox = MockBox();
    sut = PartOrderRepositoryImplementation(mockBox);
    registerFallbackValue(orderModel);
  });

  group('.createPartOrder()', () {
    void mockSetup() {
      when(() => mockBox.length).thenAnswer(
        (invocation) => 1,
      );
      when(() => mockBox.add(any(that: isA<OrderModel>())))
          .thenAnswer((invocation) async => 0);
      when(() => mockBox.isEmpty).thenAnswer((invocation) => false);
    }

    test('should return Right', () async {
      mockSetup();
      var results = await sut.createPartOrder(OrderEntity(
          index: 1,
          partEntityIndex: 0,
          orderAmount: 30,
          orderDate: DateTime.now().subtract(const Duration(days: 20))));
      expect(results, const Right<Failure, void>(null));
      verify(() => mockBox.add(any(that: isA<OrderModel>()))).called(1);
    });

    test('should return left', () async {
      mockSetup();
      when(() => mockBox.length).thenThrow(Exception);
      var results = await sut.createPartOrder(OrderEntity(
          index: 1,
          partEntityIndex: 0,
          orderAmount: 30,
          orderDate: DateTime.now().subtract(const Duration(days: 20))));
      expect(results, const Left<Failure, void>(CreateDataFailure()));
      verifyNever(() => mockBox.add(any(that: isA<OrderModel>())));
    });
  });

  group('.deletePartOrder()', () {
    void mockSetup() {
      when(() => mockBox.deleteAt(1)).thenAnswer((invocation) async => ());
    }

    test('should return Right', () async {
      mockSetup();
      var results = await sut.deletePartOrder(OrderEntity(
          index: 1,
          partEntityIndex: 0,
          orderAmount: 30,
          orderDate: DateTime.now().subtract(const Duration(days: 20))));
      expect(results, const Right<Failure, void>(null));
      verify(() => mockBox.deleteAt(1)).called(1);
    });

    test('should return left', () async {
      when(() => mockBox.deleteAt(1)).thenThrow(Exception);
      var results = await sut.createPartOrder(OrderEntity(
          index: 1,
          partEntityIndex: 0,
          orderAmount: 30,
          orderDate: DateTime.now().subtract(const Duration(days: 20))));
      expect(results, const Left<Failure, void>(CreateDataFailure()));
      verifyNever(() => mockBox.add(any(that: isA<OrderModel>())));
    });
  });

  group('.editPartOrder()', () {
    void mockSetup() {
      when(() =>
              mockBox.put(any(that: isA<int>()), any(that: isA<OrderModel>())))
          .thenAnswer((invocation) async => ());
    }

    test('should return Right', () async {
      mockSetup();
      var results = await sut.editPartOrder(OrderEntity(
          index: 1,
          partEntityIndex: 0,
          orderAmount: 30,
          orderDate: DateTime.now().subtract(const Duration(days: 20))));
      expect(results, const Right<Failure, void>(null));
      verify(() =>
              mockBox.put(any(that: isA<int>()), any(that: isA<OrderModel>())))
          .called(1);
    });

    test('should return left', () async {
      when(() =>
              mockBox.put(any(that: isA<int>()), any(that: isA<OrderModel>())))
          .thenThrow(Exception);
      var results = await sut.editPartOrder(OrderEntity(
          index: 1,
          partEntityIndex: 0,
          orderAmount: 30,
          orderDate: DateTime.now().subtract(const Duration(days: 20))));
      expect(results, const Left<Failure, void>(UpdateDataFailure()));
      verify(() =>
              mockBox.put(any(that: isA<int>()), any(that: isA<OrderModel>())))
          .called(1);
    });
  });

  group('.getSpecificPart()', () {
    void mockSetup() {
      when(() => mockBox.length).thenAnswer((invocation) => 10);
      when(() => mockBox.getAt(any(that: isA<int>())))
          .thenAnswer((invocation) => orderModel);
    }

    test('should return Right', () async {
      mockSetup();
      var results = await sut.getSpecificPartOrder(1);
      expect(results, Right<Failure, OrderEntity>(orderModel));
    });
    test('should return Left when index negative', () async {
      mockSetup();
      var results = await sut.getSpecificPartOrder(-1);
      expect(results, const Left<Failure, OrderEntity>(ReadDataFailure()));
    });
    test('should return Left when index greater than database length',
        () async {
      mockSetup();
      var results = await sut.getSpecificPartOrder(12);
      expect(results, const Left<Failure, OrderEntity>(ReadDataFailure()));
    });
    test('should return Left when getAt() returns null', () async {
      mockSetup();
      when(() => mockBox.getAt(any(that: isA<int>()))).thenAnswer((_) => null);
      var results = await sut.getSpecificPartOrder(1);
      expect(results, const Left<Failure, OrderEntity>(ReadDataFailure()));
    });
  });

  group('.getAllPartOrders()', () {
    void mockSetup() {
      when(() => mockBox.length).thenAnswer((invocation) => 10);
      when(() => mockBox.valuesBetween(
              startKey: any(named: 'startKey'), endKey: any(named: 'endKey')))
          .thenAnswer(
              (invocation) => [orderModel, orderModel, orderModel, orderModel]);
    }

    test('should return the list with updated indexes', () async {
      mockSetup();
      var results = await sut.getAllPartOrders(0, 10);

      List<OrderEntity> list = [];
      results.fold((l) => null, (newList) => list.addAll(newList));
      expect(list.last.index, list.length - 1);
      expect(list.first.index, 0);
    });
    test(
        'should return an empty list when start index equals the database length',
        () async {
      mockSetup();
      var results = await sut.getAllPartOrders(10, 20);

      expect(results, const Right<Failure, List<OrderEntity>>([]));
    });
    test('should return an Left   when start index negative', () async {
      mockSetup();
      var results = await sut.getAllPartOrders(-1, 20);

      expect(
          results, const Left<Failure, List<OrderEntity>>(ReadDataFailure()));
    });
    test('should return an Left   when end index negative', () async {
      mockSetup();
      var results = await sut.getAllPartOrders(1, -20);

      expect(
          results, const Left<Failure, List<OrderEntity>>(ReadDataFailure()));
    });
    test('should return an Left   when start index greater than endIndex',
        () async {
      mockSetup();
      var results = await sut.getAllPartOrders(5, 5);

      expect(
          results, const Left<Failure, List<OrderEntity>>(ReadDataFailure()));
    });
  });
}
