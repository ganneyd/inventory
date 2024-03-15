import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../setup.dart';

class MockGetAllPartUsecase extends Mock implements GetAllPartsUsecase {}

class MockGetLowQuantityParts extends Mock implements GetLowQuantityParts {}

class MockVerifyCheckOutPart extends Mock implements VerifyCheckoutPart {}

class MockEditPartUsecase extends Mock implements EditPartUsecase {}

class MockExportExcelUsecase extends Mock implements ExportToExcelUsecase {}

class MockImportFromExcelUsecase extends Mock
    implements ImportFromExcelUsecase {}

class MockGetSpecificPartUsecase extends Mock
    implements GetPartByIndexUsecase {}

class MockDiscontinuePartUsecase extends Mock
    implements DiscontinuePartUsecase {}

class MockDeletePartOrderUsecase extends Mock
    implements DeletePartOrderUsecase {}

class MockFulfillPartOrders extends Mock implements FulfillPartOrdersUsecase {}

class MockCreatePartOrder extends Mock implements CreatePartOrderUsecase {}

class MockGetAllPartOrdersUsecase extends Mock
    implements GetAllPartOrdersUsecase {}

class MockGetUnverifiedParts extends Mock
    implements GetUnverifiedCheckoutParts {}

class MockGetAllCheckoutParts extends Mock implements GetAllCheckoutParts {}

class MockScrollController extends Mock implements ScrollController {}

class MockScrollPosition extends Mock implements ScrollPosition {}

void main() {
  late MockGetSpecificPartUsecase mockGetSpecificPartUsecase;
  late MockImportFromExcelUsecase mockImportFromExcelUsecase;
  late MockExportExcelUsecase mockExportExcelUsecase;
  late MockEditPartUsecase mockEditPartUsecase;
  late MockDiscontinuePartUsecase mockDiscontinuePartUsecase;
  late MockDeletePartOrderUsecase mockDeletePartOrderUsecase;
  late MockGetAllPartOrdersUsecase mockGetAllPartOrdersUsecase;
  late MockVerifyCheckOutPart mockVerifyCheckOutPartUsecase;
  late MockGetAllPartUsecase mockGetAllPartUsecase;
  late MockGetLowQuantityParts mockGetLowQuantityParts;
  late MockGetUnverifiedParts mockGetUnverifiedParts;
  late MockGetAllCheckoutParts mockGetAllCheckoutParts;
  late MockCreatePartOrder mockCreatePartOrder;
  late MockFulfillPartOrders mockFulfillPartOrdersUsecase;
  late ValuesForTest valuesForTest;
  late ManageInventoryCubit sut;

  setUp(() {
    valuesForTest = ValuesForTest();
    mockGetSpecificPartUsecase = MockGetSpecificPartUsecase();
    mockImportFromExcelUsecase = MockImportFromExcelUsecase();
    mockDiscontinuePartUsecase = MockDiscontinuePartUsecase();
    mockEditPartUsecase = MockEditPartUsecase();
    mockDeletePartOrderUsecase = MockDeletePartOrderUsecase();
    mockGetAllPartOrdersUsecase = MockGetAllPartOrdersUsecase();
    mockCreatePartOrder = MockCreatePartOrder();
    mockFulfillPartOrdersUsecase = MockFulfillPartOrders();
    mockVerifyCheckOutPartUsecase = MockVerifyCheckOutPart();
    mockGetAllPartUsecase = MockGetAllPartUsecase();
    mockGetLowQuantityParts = MockGetLowQuantityParts();
    mockGetUnverifiedParts = MockGetUnverifiedParts();
    mockGetAllCheckoutParts = MockGetAllCheckoutParts();
    mockExportExcelUsecase = MockExportExcelUsecase();

    sut = ManageInventoryCubit(
      getPartByIndexUsecase: mockGetSpecificPartUsecase,
      importFromExcelUsecase: mockImportFromExcelUsecase,
      exportToExcelUsecase: mockExportExcelUsecase,
      editPartUsecase: mockEditPartUsecase,
      discontinuePartUsecase: mockDiscontinuePartUsecase,
      deletePartOrderUsecase: mockDeletePartOrderUsecase,
      getAllPartOrdersUsecase: mockGetAllPartOrdersUsecase,
      createPartOrderUsecase: mockCreatePartOrder,
      fulfillPartOrdersUsecase: mockFulfillPartOrdersUsecase,
      verifyCheckoutPartUsecase: mockVerifyCheckOutPartUsecase,
      getAllCheckoutParts: mockGetAllCheckoutParts,
      getLowQuantityParts: mockGetLowQuantityParts,
      getUnverifiedCheckoutParts: mockGetUnverifiedParts,
      fetchPartAmount: 2,
      getAllPartsUsecase: mockGetAllPartUsecase,
    );
    registerFallbackValue(VerifyCheckoutPartParams(
        checkedOutEntityList: valuesForTest.createCheckedOutList()));
    registerFallbackValue(GetAllCheckoutPartsParams(
        currentListLength: sut.state.checkedOutParts.length,
        fetchAmount: sut.state.fetchPartAmount));

    registerFallbackValue(GetAllPartParams(
        currentDatabaseLength: sut.state.allParts.length,
        fetchAmount: sut.state.fetchPartAmount));
    registerFallbackValue(FulfillPartOrdersParams(
        fulfillmentEntities: valuesForTest.getOrders()));

    registerFallbackValue(DiscontinuePartParams(
        discontinuedPartEntity: valuesForTest.parts()[0]));

    registerFallbackValue(const GetAllPartOrdersParams(
        currentOrderListLength: 0, fetchAmount: 20));
    registerFallbackValue(EditPartParams(partEntity: valuesForTest.parts()[0]));
    registerFallbackValue(
        DeletePartOrderParams(orderEntity: valuesForTest.getOrders()[0]));
    registerFallbackValue(CreatePartOrderParams(
        orderEntity: OrderEntity(
            index: 0,
            partEntityIndex: 0,
            orderAmount: 23,
            orderDate: DateTime.now())));
  });

  group('ManageInventoryCubit()', () {
    test('initial state', () {
      expect(sut.state.fetchPartAmount, 2);
      expect(sut.state.error, 'no error');
      expect(sut.state.allParts, <PartEntity>[]);
      expect(sut.state.checkedOutParts, <CheckedOutEntity>[]);
      expect(sut.state.newlyVerifiedParts, <CheckedOutEntity>[]);
      expect(sut.state.allPartOrders, <OrderEntity>[]);
      expect(sut.state.newlyFulfilledPartOrders, <OrderEntity>[]);
      expect(sut.state.status, ManageInventoryStateStatus.loading);
    });
  });

  group('.init()', () {
    void mockSetup() {
      when(() => mockGetAllPartOrdersUsecase
              .call(any(that: isA<GetAllPartOrdersParams>())))
          .thenAnswer((invocation) async =>
              Right<Failure, List<OrderEntity>>(valuesForTest.getOrders()));
      when(() => mockGetAllCheckoutParts
              .call(any(that: isA<GetAllCheckoutPartsParams>())))
          .thenAnswer((_) async => Right<Failure, List<CheckedOutEntity>>(
              valuesForTest.createCheckedOutList()));
      when(() => mockGetAllPartUsecase.call(any(that: isA<GetAllPartParams>())))
          .thenAnswer((invocation) async =>
              Right<Failure, List<PartEntity>>(valuesForTest.parts()));
    }

    //test
    test('part List should be returned ', () async {
      //expectations
      mockSetup();

      //use the then() since the functions evoked in the cubit return before completing their tasks
      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.loading,
            ManageInventoryStateStatus.fetchedDataSuccessfully,
            ManageInventoryStateStatus.fetchedDataSuccessfully,
            ManageInventoryStateStatus.fetchedDataSuccessfully,
          ])).then((_) {
        //verify that both usecases were only called once each
        verify(() =>
                mockGetAllPartUsecase.call(any(that: isA<GetAllPartParams>())))
            .called(1);
        verify(() => mockGetAllCheckoutParts
            .call(any(that: isA<GetAllCheckoutPartsParams>()))).called(1);
        verify(() => mockGetAllPartOrdersUsecase
            .call(any(that: isA<GetAllPartOrdersParams>()))).called(1);
      });
      sut.init();
    });
  });
  group('.loadParts', () {
    void mockSetup(GetAllPartParams params) {
      when(() => mockGetAllCheckoutParts
              .call(any(that: isA<GetAllCheckoutPartsParams>())))
          .thenAnswer((_) async => Right<Failure, List<CheckedOutEntity>>(
              valuesForTest.createCheckedOutList()));
      when(() => mockGetAllPartUsecase.call(params)).thenAnswer(
          (_) async => Right<Failure, List<PartEntity>>(valuesForTest.parts()));
    }

    test('should emit the FetchDataSuccessfully 10', () {
      //setup
      GetAllPartParams params = GetAllPartParams(
          fetchAmount: sut.state.fetchPartAmount,
          currentDatabaseLength: sut.state.allParts.length);
      mockSetup(params);
      //expect that the state is later emitted with the status
      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder(
              [ManageInventoryStateStatus.fetchedDataSuccessfully])).then((_) {
        //usecase should only be called once
        var captured = verify(
          () => mockGetAllPartUsecase
              .call(captureAny(that: isA<GetAllPartParams>())),
        ).captured;

        var capturedParams = captured.first as GetAllPartParams;
        expect(capturedParams.currentDatabaseLength, 0);
        expect(capturedParams.fetchAmount, sut.state.fetchPartAmount);
        expect(sut.state.allParts.length, valuesForTest.parts().length);
      });
      //evoke the function
      sut.loadParts();
    });

    test('should emit status as FetchDataUnsuccessfully', () {
      //setup
      GetAllPartParams params = GetAllPartParams(
          currentDatabaseLength: sut.state.allParts.length,
          fetchAmount: sut.state.fetchPartAmount);
      when(() => mockGetAllPartUsecase.call(params)).thenAnswer(
          (invocation) async =>
              const Left<Failure, List<PartModel>>(ReadDataFailure()));
      //expect that the state is later emitted with the status
      expectLater(
              sut.stream.map((state) => state.status),
              emitsInOrder(
                  [ManageInventoryStateStatus.fetchedDataUnsuccessfully]))
          .then((_) {
        //usecase should only be called once
        var captured = verify(
          () => mockGetAllPartUsecase
              .call(captureAny(that: isA<GetAllPartParams>())),
        ).captured;

        var capturedParams = captured.first as GetAllPartParams;
        expect(capturedParams.currentDatabaseLength, 0);
        expect(capturedParams.fetchAmount, sut.state.fetchPartAmount);
        expect(sut.state.allParts.length, 0);
      });
      //evoke the function
      sut.loadParts();
    });
  });

  group('.loadCheckedOutParts()', () {
    test('should emit the FetchDataSuccessfully', () {
      //setup
      when(() => mockGetAllCheckoutParts
              .call(any(that: isA<GetAllCheckoutPartsParams>())))
          .thenAnswer((_) async => Right<Failure, List<CheckedOutEntity>>(
              valuesForTest.createCheckedOutList()));

      //expect that the state is later emitted with the status
      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder(
              [ManageInventoryStateStatus.fetchedDataSuccessfully])).then((_) {
        //usecase should only be called once
        var captured = verify(
          () => mockGetAllCheckoutParts
              .call(captureAny(that: isA<GetAllCheckoutPartsParams>())),
        ).captured;

        var capturedParams = captured.first as GetAllCheckoutPartsParams;
        expect(capturedParams.currentListLength, 0);
        expect(capturedParams.fetchAmount, sut.state.fetchPartAmount);
        expect(sut.state.checkedOutParts.length,
            valuesForTest.createCheckedOutList().length);
      });
      //evoke the function
      sut.loadCheckedOutParts();
    });

    test('should emit status as FetchDataUnsuccessfully', () {
      //setup

      when(() => mockGetAllCheckoutParts
              .call(any(that: isA<GetAllCheckoutPartsParams>())))
          .thenAnswer((invocation) async =>
              const Left<Failure, List<CheckedOutEntity>>(ReadDataFailure()));
      //expect that the state is later emitted with the status
      expectLater(
              sut.stream.map((state) => state.status),
              emitsInOrder(
                  [ManageInventoryStateStatus.fetchedDataUnsuccessfully]))
          .then((_) {
        //usecase should only be called once
        var captured = verify(
          () => mockGetAllCheckoutParts
              .call(captureAny(that: isA<GetAllCheckoutPartsParams>())),
        ).captured;

        var capturedParams = captured.first as GetAllCheckoutPartsParams;
        expect(capturedParams.currentListLength, 0);
        expect(capturedParams.fetchAmount, sut.state.fetchPartAmount);
        expect(sut.state.checkedOutParts.length, 0);
      });
      //evoke the function
      sut.loadCheckedOutParts();
    });
  });

  group('.loadPartOrders()', () {
    test('should emit the FetchDataSuccessfully', () {
      //setup
      when(() => mockGetAllPartOrdersUsecase
              .call(any(that: isA<GetAllPartOrdersParams>())))
          .thenAnswer((_) async =>
              Right<Failure, List<OrderEntity>>(valuesForTest.getOrders()));

      //expect that the state is later emitted with the status
      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder(
              [ManageInventoryStateStatus.fetchedDataSuccessfully])).then((_) {
        //usecase should only be called once
        var captured = verify(
          () => mockGetAllPartOrdersUsecase
              .call(captureAny(that: isA<GetAllPartOrdersParams>())),
        ).captured;

        var capturedParams = captured.first as GetAllPartOrdersParams;
        expect(capturedParams.currentOrderListLength, 0);
        expect(capturedParams.fetchAmount, sut.state.fetchPartAmount);
        expect(
            sut.state.allPartOrders.length, valuesForTest.getOrders().length);
      });
      //evoke the function
      sut.loadPartOrders();
    });

    test('should emit status as FetchDataUnsuccessfully', () {
      //setup
      when(() => mockGetAllPartOrdersUsecase
              .call(any(that: isA<GetAllPartOrdersParams>())))
          .thenAnswer((_) async =>
              const Left<Failure, List<OrderEntity>>(ReadDataFailure()));

      //expect that the state is later emitted with the status
      expectLater(
              sut.stream.map((state) => state.status),
              emitsInOrder(
                  [ManageInventoryStateStatus.fetchedDataUnsuccessfully]))
          .then((_) {
        //usecase should only be called once
        var captured = verify(
          () => mockGetAllPartOrdersUsecase
              .call(captureAny(that: isA<GetAllPartOrdersParams>())),
        ).captured;

        var capturedParams = captured.first as GetAllPartOrdersParams;
        expect(capturedParams.currentOrderListLength, 0);
        expect(capturedParams.fetchAmount, sut.state.fetchPartAmount);
        expect(sut.state.allPartOrders.length, 0);
      });
      //evoke the function
      sut.loadPartOrders();
    });
  });

  group('.filterLowQuantityParts()', () {
    test(
        'should return list where part.quantity is less than requisition point',
        () {
      var returnedList = sut.filterLowQuantityParts(valuesForTest.parts());
      expect(returnedList.length, 4);
    });

    test('should return an empty list', () {
      var returnedList = sut.filterLowQuantityParts([]);
      expect(returnedList.length, 0);
    });
  });
  group('.filterUnverifiedParts()', () {
    test('should return list where checkoutPart.isVerified is false or null',
        () {
      var returnedList =
          sut.filterUnverifiedParts(valuesForTest.createCheckedOutList());
      expect(returnedList.length, 10);
    });

    test('should return an empty list', () {
      var returnedList = sut.filterUnverifiedParts([]);
      expect(returnedList.length, 0);
    });
  });

  group('.filterUnfulfilledPartOrders()', () {
    test('should return list where partOrder.isFulfilled is false', () {
      var returnedList =
          sut.filterUnfulfilledPartOrders(valuesForTest.getOrders());
      expect(returnedList.length, 6);
    });

    test('should return an empty list', () {
      var returnedList = sut.filterUnfulfilledPartOrders([]);
      expect(returnedList.length, 0);
    });
  });
  group('updateCheckoutQuantity', () {
    void mockSetup() {
      sut.emit(sut.state.copyWith(
          checkedOutParts: valuesForTest.createCheckedOutList(),
          newlyVerifiedParts: [],
          allParts: valuesForTest.parts()));
    }

    test('should update the check out quantity when subtracting 1', () async {
      mockSetup();
      var index = 0;

      var checkoutPart = valuesForTest.createCheckedOutList()[index];

      expectLater(
          sut.stream
              .map((event) => event.checkedOutParts[index].checkedOutQuantity),
          emitsInOrder([
            checkoutPart.checkedOutQuantity - 1,
            checkoutPart.checkedOutQuantity - 2,
          ]));

      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[index], quantityChange: -1);
      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[index], quantityChange: -1);
    });

    test('should update the check out quantity when adding 1', () {
      mockSetup();
      var index = 0;

      expectLater(
          sut.stream
              .map((event) => event.checkedOutParts[index].quantityDiscrepancy),
          emitsInOrder([1]));

      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[index], quantityChange: 1);
    });
  });

  group('.verifyPart()', () {
    void mockSetup() {
      sut.emit(sut.state.copyWith(
          allParts: valuesForTest.parts(),
          newlyVerifiedParts: [],
          checkedOutParts: valuesForTest.createCheckedOutList()));
    }

    test('should verify the check out part and update the part quantity', () {
      mockSetup();
      var index = 0;
      var checkoutPart = valuesForTest.createCheckedOutList()[index];
      expectLater(
          sut.stream.map((state) => state.checkedOutParts[0].isVerified),
          emitsInOrder([false, false, true])).then((_) {
        expect(sut.state.allParts[checkoutPart.partEntityIndex].quantity,
            valuesForTest.parts()[checkoutPart.partEntityIndex].quantity + 2);
      });

      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[index], quantityChange: -1);
      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[index], quantityChange: -1);
      sut.verifyPart(checkedOutEntity: sut.state.checkedOutParts[index]);
    });

    test(
        'should verify the check out part and update the part quantity even if its been change but not verified in another checked out part',
        () {
      mockSetup();
      var index = 0;
      var checkoutPart = valuesForTest.createCheckedOutList()[index];

//check that the other checkout part's quantity was messed with
      expectLater(
          sut.stream.map((state) => state.checkedOutParts[0].isVerified),
          emitsInOrder([false, false, false, false, true])).then((_) {
        expect(sut.state.allParts[checkoutPart.partEntityIndex].quantity,
            valuesForTest.parts()[checkoutPart.partEntityIndex].quantity + 2);
      });
      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[index], quantityChange: -1);
      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[index + 1],
          quantityChange: 1);
      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[index + 1],
          quantityChange: 1);
      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[index], quantityChange: -1);
      sut.verifyPart(checkedOutEntity: sut.state.checkedOutParts[index]);
    });
  });

  group('.fulfillPartOrder()', () {
    void mockSetup() {
      sut.emit(sut.state.copyWith(
        allPartOrders: valuesForTest.getOrders(),
        allParts: valuesForTest.parts(),
      ));
    }

    test('should emit the part order as fulfilled', () async {
      expectLater(
          sut.stream.map((state) => state.allParts[0].quantity),
          emitsInOrder([
            valuesForTest.parts()[0].quantity,
            valuesForTest.parts()[0].quantity +
                valuesForTest.getOrders()[0].orderAmount
          ])).then((_) {
        expect(sut.state.newlyFulfilledPartOrders.length, 1);
        expect(sut.state.allPartOrders[0].isFulfilled, true);
      });
      mockSetup();
      sut.fulfillPartOrder(orderEntity: sut.state.allPartOrders[0]);
    });
  });
  group('.orderPart()', () {
    void mockSetup() {
      sut.emit(sut.state.copyWith());
      when(() =>
              mockCreatePartOrder.call(any(that: isA<CreatePartOrderParams>())))
          .thenAnswer((_) async =>
              Right<Failure, OrderEntity>(valuesForTest.getOrders()[0]));
    }

    test('should return right', () async {
      mockSetup();
      CreatePartOrderParams params = CreatePartOrderParams(
          orderEntity: OrderEntity(
              index: 0,
              partEntityIndex: 0,
              orderAmount: 20,
              orderDate: DateTime.now()));

      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.creatingPartOrder,
            ManageInventoryStateStatus.createdPartOrderSuccessfully
          ])).then((_) {
        expect(sut.state.allPartOrders.length, 1);
        verify(() => mockCreatePartOrder
            .call(any(that: isA<CreatePartOrderParams>()))).called(1);
      });

      sut.orderPart(
          orderAmount: params.orderEntity.orderAmount,
          partEntityIndex: params.orderEntity.partEntityIndex);
    });

    test('should emit createdPartOrderUnsuccessfully', () async {
      mockSetup();
      when(() =>
              mockCreatePartOrder.call(any(that: isA<CreatePartOrderParams>())))
          .thenAnswer(
              (_) async => const Left<Failure, OrderEntity>(GetFailure()));
      CreatePartOrderParams params = CreatePartOrderParams(
          orderEntity: OrderEntity(
              index: 0,
              partEntityIndex: 0,
              orderAmount: 20,
              orderDate: DateTime.now()));

      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.creatingPartOrder,
            ManageInventoryStateStatus.createdPartOrderUnsuccessfully
          ])).then((_) {
        expect(sut.state.allPartOrders.length, 0);
        verify(() => mockCreatePartOrder
            .call(any(that: isA<CreatePartOrderParams>()))).called(1);
      });

      sut.orderPart(
          orderAmount: params.orderEntity.orderAmount,
          partEntityIndex: params.orderEntity.partEntityIndex);
    });
  });

  group('.deletePartOrder()', () {
    test('should emit .deletedPartOrderSuccessfully', () {
      //setup
      var orderList = valuesForTest.getOrders();
      sut.emit(sut.state.copyWith(allPartOrders: orderList));
      var deleteOrderEntity = orderList[2];
      when(() => mockDeletePartOrderUsecase
              .call(any(that: isA<DeletePartOrderParams>())))
          .thenAnswer((_) async => const Right(null));

      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.deletingPartOrder,
            ManageInventoryStateStatus.deletedPartOrderSuccessfully
          ])).then((_) {
        verify(() => mockDeletePartOrderUsecase
            .call(any(that: isA<DeletePartOrderParams>()))).called(1);
        expect(sut.state.allPartOrders.contains(deleteOrderEntity), false);
        expect(sut.state.allPartOrders.length, orderList.length - 1);
        expect(orderList.contains(deleteOrderEntity), true);
      });

      //evoke
      sut.deletePartOrder(orderEntity: deleteOrderEntity);
    });

    test('should emit .deletedPartOrderUnsuccessfully', () {
      //setup
      var orderList = valuesForTest.getOrders();
      sut.emit(sut.state.copyWith(allPartOrders: orderList));
      var deleteOrderEntity = orderList[2];
      when(() => mockDeletePartOrderUsecase
              .call(any(that: isA<DeletePartOrderParams>())))
          .thenAnswer((_) async => const Left(GetFailure()));

      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.deletingPartOrder,
            ManageInventoryStateStatus.deletedPartOrderUnsuccessfully
          ])).then((_) {
        verify(() => mockDeletePartOrderUsecase
            .call(any(that: isA<DeletePartOrderParams>()))).called(1);
        expect(sut.state.allPartOrders.contains(deleteOrderEntity), true);
        expect(sut.state.allPartOrders.length, orderList.length);
        expect(orderList.contains(deleteOrderEntity), true);
      });

      //evoke
      sut.deletePartOrder(orderEntity: deleteOrderEntity);
    });
  });

  group('.discontinuePart()', () {
    test('should set partEntity.isDiscontinued to true', () {
      sut.emit(sut.state.copyWith(
          allParts: valuesForTest.parts(),
          allPartOrders: valuesForTest.getOrders()));
      var partEntity = valuesForTest.parts()[1];
      when(() => mockDiscontinuePartUsecase
              .call(any(that: isA<DiscontinuePartParams>())))
          .thenAnswer((_) async => const Right(null));
      when(() => mockGetAllPartOrdersUsecase
              .call(any(that: isA<GetAllPartOrdersParams>())))
          .thenAnswer((_) async =>
              Right<Failure, List<OrderEntity>>(valuesForTest.getOrders()));
      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.updatedDataSuccessfully,
            ManageInventoryStateStatus.fetchedDataSuccessfully
          ])).then((_) {
        verify(() => mockDiscontinuePartUsecase
            .call(captureAny(that: isA<DiscontinuePartParams>()))).called(1);
        expect(sut.state.allParts[1].isDiscontinued, true);
        expect(sut.state.allPartOrders.length, 10);
      });

      sut.discontinuePart(partEntity: partEntity);
    });
    test('should not set partEntity.isDiscontinued to true', () {
      sut.emit(sut.state.copyWith(allParts: valuesForTest.parts()));
      var partEntity = valuesForTest.parts()[1];
      when(() => mockDiscontinuePartUsecase
              .call(any(that: isA<DiscontinuePartParams>())))
          .thenAnswer((_) async => const Left(GetFailure()));
      expectLater(
              sut.stream.map((state) => state.status),
              emitsInOrder(
                  [ManageInventoryStateStatus.updatedDataUnsuccessfully]))
          .then((_) {
        verify(() => mockDiscontinuePartUsecase
            .call(captureAny(that: isA<DiscontinuePartParams>()))).called(1);
        expect(sut.state.allParts[1].isDiscontinued, false);
        verifyNever(() => mockGetAllPartOrdersUsecase
            .call(any(that: isA<GetAllPartOrdersParams>())));
      });

      sut.discontinuePart(partEntity: partEntity);
    });
  });

  group('.restockPart()', () {
    void mockSetup() {
      sut.emit(sut.state.copyWith(allParts: valuesForTest.parts()));
      when(() => mockEditPartUsecase.call(any(that: isA<EditPartParams>())))
          .thenAnswer((invocation) async => const Right(null));
    }

    test('should emit updatedDataSuccessfully', () {
      //setup
      mockSetup();

      var restockPart =
          valuesForTest.parts()[0].copyWith(isDiscontinued: true, quantity: 0);
      var newQuantity = 10;
      //verifications
      expectLater(
          sut.stream.map((state) => state.status),
          emitsInAnyOrder([
            ManageInventoryStateStatus.updatingData,
            ManageInventoryStateStatus.updatedDataSuccessfully
          ])).then((_) {
        var capture = verify(() => mockEditPartUsecase
            .call(captureAny(that: isA<EditPartParams>()))).captured;
        var capturedPart = capture.first as EditPartParams;
        expect(capturedPart.partEntity.isDiscontinued, false);
        expect(capturedPart.partEntity.quantity, newQuantity);
        expect(sut.state.allParts[restockPart.index].isDiscontinued, false);
        expect(sut.state.allParts[restockPart.index].quantity, newQuantity);
      });
      sut.restockPart(partEntity: restockPart, newQuantity: newQuantity);
    });

    test('should emit updatedDataUnsuccessfully', () {
      //setup
      mockSetup();
      when(() => mockEditPartUsecase.call(any(that: isA<EditPartParams>())))
          .thenAnswer((invocation) async => const Left(GetFailure()));
      var restockPart =
          valuesForTest.parts()[0].copyWith(isDiscontinued: true, quantity: 0);
      var newQuantity = 10;
      //verifications
      expectLater(
          sut.stream.map((state) => state.status),
          emitsInAnyOrder([
            ManageInventoryStateStatus.updatingData,
            ManageInventoryStateStatus.updatedDataUnsuccessfully
          ])).then((_) {
        var capture = verify(() => mockEditPartUsecase
            .call(captureAny(that: isA<EditPartParams>()))).captured;
        var capturedPart = capture.first as EditPartParams;
        expect(capturedPart.partEntity.isDiscontinued, false);
        expect(capturedPart.partEntity.quantity, newQuantity);
        expect(sut.state.allParts[restockPart.index].isDiscontinued, true);
      });
      sut.restockPart(partEntity: restockPart, newQuantity: newQuantity);
    });
  });
  group('.close()', () {
    void mockSetup() {
      when(() => mockVerifyCheckOutPartUsecase
              .call(any(that: isA<VerifyCheckoutPartParams>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
      when(() => mockFulfillPartOrdersUsecase
              .call(any(that: isA<FulfillPartOrdersParams>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
    }

    test('should evoke _updateDatabase() ', () async {
      mockSetup();

      var expectedFulfilledList = valuesForTest.getOrders();
      var expectedVerifiedList = valuesForTest.createCheckedOutList();

      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.loading,
            ManageInventoryStateStatus.verifyingPart
          ]));

      //setup state
      sut.emit(sut.state.copyWith(
          newlyFulfilledPartOrders: expectedFulfilledList,
          newlyVerifiedParts: expectedVerifiedList));
      await sut.close();
      var verifyCapture = verify(() => mockVerifyCheckOutPartUsecase
          .call(captureAny(that: isA<VerifyCheckoutPartParams>()))).captured;
      var fulfillCapture = verify(() => mockFulfillPartOrdersUsecase
          .call(captureAny(that: isA<FulfillPartOrdersParams>()))).captured;

      var verifyList = verifyCapture.first as VerifyCheckoutPartParams;
      var fulfillList = fulfillCapture.first as FulfillPartOrdersParams;

      expect(verifyList.checkedOutEntityList, expectedVerifiedList);
      expect(fulfillList.fulfillmentEntities, expectedFulfilledList);
    });
  });
}
