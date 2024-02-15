import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../setup.dart';

class MockGetAllPartUsecase extends Mock implements GetAllPartsUsecase {}

class MockGetDatabaseLength extends Mock implements GetDatabaseLength {}

class MockGetLowQuantityParts extends Mock implements GetLowQuantityParts {}

class MockVerifyCheckOutPart extends Mock implements VerifyCheckoutPart {}

class MockGetUnverifiedParts extends Mock
    implements GetUnverifiedCheckoutParts {}

class MockGetAllCheckoutParts extends Mock implements GetAllCheckoutParts {}

class MockScrollController extends Mock implements ScrollController {}

class MockScrollPosition extends Mock implements ScrollPosition {}

void main() {
  late MockVerifyCheckOutPart mockVerifyCheckOutPart;
  late MockGetAllPartUsecase mockGetAllPartUsecase;
  late MockGetDatabaseLength mockGetDatabaseLength;
  late MockGetLowQuantityParts mockGetLowQuantityParts;
  late MockGetUnverifiedParts mockGetUnverifiedParts;
  late MockGetAllCheckoutParts mockGetAllCheckoutParts;

  late ValuesForTest valuesForTest;
  late ManageInventoryCubit sut;

  setUp(() {
    valuesForTest = ValuesForTest();
    mockVerifyCheckOutPart = MockVerifyCheckOutPart();
    mockGetAllPartUsecase = MockGetAllPartUsecase();
    mockGetDatabaseLength = MockGetDatabaseLength();
    mockGetLowQuantityParts = MockGetLowQuantityParts();
    mockGetUnverifiedParts = MockGetUnverifiedParts();
    mockGetAllCheckoutParts = MockGetAllCheckoutParts();

    sut = ManageInventoryCubit(
        verifyCheckoutPartUsecase: mockVerifyCheckOutPart,
        getAllCheckoutParts: mockGetAllCheckoutParts,
        getLowQuantityParts: mockGetLowQuantityParts,
        getUnverifiedCheckoutParts: mockGetUnverifiedParts,
        fetchPartAmount: 2,
        getAllPartsUsecase: mockGetAllPartUsecase,
        getDatabaseLength: mockGetDatabaseLength);
    registerFallbackValue(VerifyCheckoutPartParams(
        checkedOutEntityList: valuesForTest.createCheckedOutList()));
    registerFallbackValue(GetAllCheckoutPartsParams(
        endIndex: sut.state.checkedOutParts.length + sut.state.fetchPartAmount,
        startIndex: sut.state.checkedOutParts.length));

    registerFallbackValue(GetAllPartParams(
        pageIndex: sut.state.parts.length + sut.state.fetchPartAmount,
        startIndex: sut.state.parts.length));
  });

  group('ManageInventoryCubit()', () {
    test('initial state', () {
      expect(sut.state.fetchPartAmount, 2);
      expect(sut.state.databaseLength, 0);
      expect(sut.state.error, 'no error');
      expect(sut.state.parts, <PartModel>[]);
      expect(sut.state.status, ManageInventoryStateStatus.loading);
      expect(sut.state.lowQuantityParts, <PartModel>[]);
      expect(sut.state.newlyVerifiedParts, <CheckedOutEntity>[]);
      expect(sut.state.unverifiedParts, <CheckedOutEntity>[]);
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

      when(() => mockGetDatabaseLength.call(NoParams())).thenAnswer(
          (invocation) async =>
              Right<Failure, int>(valuesForTest.parts().length));
    }

    test('should emit the first 10 in the set', () {
      var expectedPartList = valuesForTest.parts();

      //setup
      GetAllPartParams params = GetAllPartParams(
          pageIndex: sut.state.databaseLength + sut.state.fetchPartAmount,
          startIndex: sut.state.databaseLength);
      mockSetup(params);
      //evoke the function
      sut.loadParts();
      //usecase should only be called once
      verify(
        () => mockGetAllPartUsecase.call(params),
      ).called(1);

      //expect that the state is emitted with the parts gotten from the usecase
      expectLater(sut.stream.map((state) => state.parts),
          emitsInOrder([expectedPartList]));
      //expect that the state is later emitted with the status
      expectLater(sut.stream.map((state) => state.status),
          emitsInOrder([ManageInventoryStateStatus.fetchedDataSuccessfully]));
    });

    test('should emit error message', () {
      //setup
      GetAllPartParams params = GetAllPartParams(
          pageIndex: sut.state.databaseLength + sut.state.fetchPartAmount,
          startIndex: sut.state.databaseLength);
      when(() => mockGetAllPartUsecase.call(params)).thenAnswer(
          (invocation) async =>
              const Left<Failure, List<PartModel>>(ReadDataFailure()));
      //evoke the function
      sut.loadParts();
      //usecase should only be called once
      verify(
        () => mockGetAllPartUsecase.call(params),
      ).called(1);

      //expect that the state is emitted with the error message from the Failure
      expectLater(sut.stream.map((state) => state.error),
          emitsInOrder([const ReadDataFailure().errorMessage]));
      //expect that the state is later emitted with the status
      expectLater(sut.stream.map((state) => state.status),
          emitsInOrder([ManageInventoryStateStatus.fetchedDataUnsuccessfully]));
    });
  });

  group('.init()', () {
    void mockSetup() {
      when(() => mockGetAllCheckoutParts
              .call(any(that: isA<GetAllCheckoutPartsParams>())))
          .thenAnswer((_) async => Right<Failure, List<CheckedOutEntity>>(
              valuesForTest.createCheckedOutList()));
      when(() => mockGetAllPartUsecase.call(any(that: isA<GetAllPartParams>())))
          .thenAnswer((invocation) async =>
              Right<Failure, List<PartEntity>>(valuesForTest.parts()));

      when(() => mockGetDatabaseLength.call(NoParams())).thenAnswer(
          (invocation) async =>
              Right<Failure, int>(valuesForTest.parts().length));
    }

    //test
    test('part List should be returned ', () async {
      //expectations
      mockSetup();
      sut.init();
      //use the then() since the functions evoked in the cubit return before completing their tasks
      expectLater(
          sut.stream.map((state) => state.databaseLength),
          emitsInOrder([
            valuesForTest.getPartList().length,
            valuesForTest.getPartList().length,
          ])).then((_) {
        //verify that both usecases were only called once each
        verify(() =>
                mockGetAllPartUsecase.call(any(that: isA<GetAllPartParams>())))
            .called(1);
        verify(() => mockGetDatabaseLength.call(NoParams())).called(1);
      });

      //verify that the correct statues were emitted
      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.loading,
            ManageInventoryStateStatus.fetchedDataSuccessfully
          ]));
    });

    test('state should emit 0 when getDatabaseLength returns an error', () {
//setup

      mockSetup();

      when(() => mockGetDatabaseLength.call(NoParams())).thenAnswer(
          (invocation) async => const Left<Failure, int>(ReadDataFailure()));
      sut.init();

      expectLater(sut.stream.map((state) => state.databaseLength),
          emitsInOrder([0, 0]));
    });
  });

  group('.filterUnverifiedParts()', () {
    void mockSetup() {
      sut.emit(sut.state.copyWith(
          parts: valuesForTest.parts(),
          checkedOutParts: valuesForTest.createCheckedOutList(),
          newlyVerifiedParts: [],
          unverifiedParts: []));
      when(() => mockGetAllCheckoutParts
              .call(any(that: isA<GetAllCheckoutPartsParams>())))
          .thenAnswer((invocation) async =>
              Right<Failure, List<CheckedOutEntity>>(
                  valuesForTest.createCheckedOutList()));
    }

    test(
        'should update the part quantity for edited parts in the checkoutPartList',
        () async {
      mockSetup();
      expectLater(
          sut.stream.map((state) => state.parts[0].quantity),
          emitsInOrder([
            30,
            31,
            31,
            32,
            32,
            31,
          ]));

      expectLater(
          sut.stream.map((state) => state.checkedOutParts[0].isVerified),
          emitsInOrder([
            false,
            true,
            true,
            true,
            true,
            true,
          ]));

      expectLater(
          sut.stream.map((state) => state.checkedOutParts[1].isVerified),
          emitsInOrder([
            false,
            false,
            false,
            true,
            true,
            true,
          ]));

      expectLater(
          sut.stream.map((state) => state.checkedOutParts[2].isVerified),
          emitsInOrder([
            false,
            false,
            false,
            false,
            false,
            true,
          ]));
      expectLater(
          sut.stream.map((state) => state.checkedOutParts[2].part.quantity),
          emitsInOrder([
            30,
            31,
            31,
            32,
            31,
            31,
          ]));

      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[0], quantityChange: -1);
      sut.verifyPart(checkedOutEntity: sut.state.checkedOutParts[0]);
      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[1], quantityChange: -1);
      sut.verifyPart(checkedOutEntity: sut.state.checkedOutParts[1]);
      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[2], quantityChange: 1);
      sut.verifyPart(checkedOutEntity: sut.state.checkedOutParts[2]);
    });
    test('should filter the list', () async {
      sut.emit(sut.state.copyWith(
          parts: valuesForTest.parts(),
          checkedOutParts: [],
          newlyVerifiedParts: [],
          unverifiedParts: []));
      when(() => mockGetAllCheckoutParts
              .call(any(that: isA<GetAllCheckoutPartsParams>())))
          .thenAnswer((invocation) async =>
              Right<Failure, List<CheckedOutEntity>>(
                  valuesForTest.createCheckedOutList()));
      expectLater(sut.stream.map((state) => state.unverifiedParts.length),
          emitsInOrder([10]));
      sut.loadCheckedOutParts();
    });
  });

  group('updateCheckoutQuantity', () {
    void mockSetup() {
      sut.emit(sut.state.copyWith(
          checkedOutParts: valuesForTest.createCheckedOutList(),
          newlyVerifiedParts: [],
          parts: valuesForTest.parts()));
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

      expectLater(
          sut.stream.map((event) => event.checkedOutParts[index].part.quantity),
          emitsInOrder([
            checkoutPart.part.quantity + 1,
            checkoutPart.part.quantity + 2,
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

      expectLater(
          sut.stream.map((event) => event.checkedOutParts[index].part.quantity),
          emitsInOrder([29]));
      sut.updateCheckoutQuantity(
          checkoutPart: sut.state.checkedOutParts[index], quantityChange: 1);
    });
  });

  group('.verifyPart()', () {
    void mockSetup() {
      sut.emit(sut.state.copyWith(
          parts: valuesForTest.parts(),
          newlyVerifiedParts: [],
          checkedOutParts: valuesForTest.createCheckedOutList()));
    }

    test('should verify the check out part and update the part quantity', () {
      mockSetup();
      var index = 0;
      var checkoutPart = valuesForTest.createCheckedOutList()[index];
      expectLater(
          sut.stream.map((state) => state.parts[index].quantity),
          emitsInOrder([
            checkoutPart.part.quantity,
            checkoutPart.part.quantity,
            checkoutPart.part.quantity + 2,
          ]));

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
      expectLater(
          sut.stream.map((state) => state.parts[index].quantity),
          emitsInOrder([
            checkoutPart.part.quantity,
            checkoutPart.part.quantity,
            checkoutPart.part.quantity,
            checkoutPart.part.quantity,
            checkoutPart.part.quantity + 2,
          ]));
//check that the other checkout part's quantity was messed with
      expectLater(
          sut.stream
              .map((state) => state.checkedOutParts[index + 1].part.quantity),
          emitsInOrder([
            checkoutPart.part.quantity,
            checkoutPart.part.quantity - 1,
            checkoutPart.part.quantity - 2,
            checkoutPart.part.quantity - 2,
          ]));

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
  group('.updateDatabaseWithVerifiedParts()', () {
    void mockSetup() {
      sut.emit(sut.state
          .copyWith(newlyVerifiedParts: valuesForTest.createCheckedOutList()));
    }

    test('should emit a new part list', () {});
    test('should emit verifiedSuccessfully', () async {
      //setup
      mockSetup();
      when(() => mockVerifyCheckOutPart(
              any(that: isA<VerifyCheckoutPartParams>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));

      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.verifyingPart,
          ])).then((value) => verify(
            () => mockVerifyCheckOutPart
                .call(any(that: isA<VerifyCheckoutPartParams>())),
          ).called(1));

      await sut.updateDatabaseWithVerifiedParts();
    });

    test('should emit verifiedUnsuccessfully', () async {
      //setup
      when(() =>
          mockVerifyCheckOutPart(
              any(that: isA<VerifyCheckoutPartParams>()))).thenAnswer(
          (invocation) async => const Left<Failure, void>(ReadDataFailure()));

      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.verifyingPart,
          ])).then((value) => verify(
            () => mockVerifyCheckOutPart
                .call(any(that: isA<VerifyCheckoutPartParams>())),
          ).called(1));
      await sut.updateDatabaseWithVerifiedParts();
    });
  });
}
