import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/usecases/usecases.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_cubit.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/cubit/manage_inventory_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../setup.dart';

class MockGetAllPartUsecase extends Mock implements GetAllPartsUsecase {}

class MockGetDatabaseLength extends Mock implements GetDatabaseLength {}

class MockScrollController extends Mock implements ScrollController {}

class MockScrollPosition extends Mock implements ScrollPosition {}

void main() {
  late MockGetAllPartUsecase mockGetAllPartUsecase;
  late MockGetDatabaseLength mockGetDatabaseLength;
  late MockScrollController mockScrollController;
  late MockScrollPosition mockScrollPosition;
  late ValuesForTest valuesForTest;
  late ManageInventoryCubit sut;

  setUp(() {
    valuesForTest = ValuesForTest();
    mockGetAllPartUsecase = MockGetAllPartUsecase();
    mockGetDatabaseLength = MockGetDatabaseLength();
    mockScrollController = MockScrollController();
    mockScrollPosition = MockScrollPosition();
    sut = ManageInventoryCubit(
        fetchPartAmount: 2,
        scrollController: mockScrollController,
        getAllPartsUsecase: mockGetAllPartUsecase,
        getDatabaseLength: mockGetDatabaseLength);

    registerFallbackValue(GetAllPartParams(
        pageIndex: sut.state.parts.length + sut.state.fetchPartAmount,
        startIndex: sut.state.parts.length));
  });

  group('ManageInventoryCubit()', () {
    test('initial state', () {
      expect(sut.state.fetchPartAmount, 2);
      expect(sut.state.databaseLength, 0);
      expect(sut.state.error, 'no error');
      expect(sut.state.parts, <Part>[]);
      expect(sut.state.scrollController, isA<MockScrollController>());
      expect(sut.state.status, ManageInventoryStateStatus.loading);
    });
  });

  group('.loadParts', () {
    List<Part> parts = [];
    void mockSetup(GetAllPartParams params) {
      when(() => mockGetAllPartUsecase.call(params))
          .thenAnswer((invocation) async {
        parts = [];
        for (int i = params.startIndex; i < params.pageIndex; i++) {
          parts.add(PartAdapter.fromEntity(valuesForTest.parts()[i]));
        }
        return Right<Failure, List<Part>>(parts);
      });

      when(() => mockGetDatabaseLength.call(NoParams())).thenAnswer(
          (invocation) async =>
              Right<Failure, int>(valuesForTest.parts().length));
    }

    test('should emit the first 10 in the set', () {
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
      expectLater(
          sut.stream.map((state) => state.parts), emitsInOrder([parts]));
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
              const Left<Failure, List<Part>>(ReadDataFailure()));
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
    List<Part> parts = [];
    void mockSetup(GetAllPartParams params) {
      when(() => mockGetAllPartUsecase.call(params))
          .thenAnswer((invocation) async {
        parts = [];
        for (int i = params.startIndex; i < params.pageIndex; i++) {
          parts.add(PartAdapter.fromEntity(valuesForTest.parts()[i]));
        }
        return Right<Failure, List<Part>>(parts);
      });

      when(() => mockGetDatabaseLength.call(NoParams())).thenAnswer(
          (invocation) async =>
              Right<Failure, int>(valuesForTest.parts().length));

      when(
        () => mockScrollController.addListener(() {}),
      ).thenAnswer((invocation) {});
    }

    //test
    test('part List should be returned ', () async {
      //setup
      GetAllPartParams params = GetAllPartParams(
          pageIndex: parts.length + sut.state.fetchPartAmount,
          startIndex: parts.length);
      mockSetup(params);
      sut.init();

      //expectations
      //use the then() since the functions evoked in the cubit return before completing their tasks
      expectLater(
          sut.stream.map((state) => state.databaseLength),
          emitsInOrder([
            valuesForTest.getPartList().length,
            valuesForTest.getPartList().length,
          ])).then((_) {
        //verify that both usecases were only called once each
        verify(() => mockGetAllPartUsecase.call(params)).called(1);
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
      parts.clear();
      GetAllPartParams params = GetAllPartParams(
          pageIndex: parts.length + sut.state.fetchPartAmount,
          startIndex: parts.length);
      mockSetup(params);

      when(() => mockGetDatabaseLength.call(NoParams())).thenAnswer(
          (invocation) async => const Left<Failure, int>(ReadDataFailure()));
      sut.init();

      expectLater(sut.stream.map((state) => state.databaseLength),
          emitsInOrder([0, 0]));
    });
  });

  group('Scroll Controller', () {
    List<Part> parts = [];
    VoidCallback? scrollCallback;

    void mockSetup() async {
      //usecase mock setup
      when(() => mockGetAllPartUsecase.call(any(that: isA<GetAllPartParams>())))
          .thenAnswer((invocation) async {
        //ensure the list is empty
        parts.clear();
        GetAllPartParams params =
            invocation.positionalArguments[0] as GetAllPartParams;
        for (int i = params.startIndex; i < params.pageIndex; i++) {
          parts.add(PartAdapter.fromEntity(valuesForTest.parts()[i]));
        }
        return Right<Failure, List<Part>>(parts);
      });
      //usecase mock setup
      when(() => mockGetDatabaseLength.call(NoParams())).thenAnswer(
          (invocation) async =>
              Right<Failure, int>(valuesForTest.parts().length));

      //scroll controller mock setup
      when(
        () => mockScrollController.addListener(any(that: isA<VoidCallback>())),
      ).thenAnswer((invocation) {
        scrollCallback = invocation.positionalArguments[0] as VoidCallback;
      });

      when(() => mockScrollController.position)
          .thenAnswer((_) => mockScrollPosition);
      when(() => mockScrollPosition.pixels).thenAnswer((_) => 100);
      when(() => mockScrollPosition.maxScrollExtent).thenAnswer((_) => 100);
    }

    test('Trigger the callback function and load more parts', () async {
      mockSetup();

      //our expectations. reason why its before the call to .init() is because
      //the method will emit stat changes, and placing the listener before the method
      //ensures that all state changes are able to be captured
      expectLater(
          sut.stream.map((event) => event.status),
          emitsInOrder([
            ManageInventoryStateStatus.loading,
            ManageInventoryStateStatus.fetchedDataSuccessfully,
            ManageInventoryStateStatus.fetchingData,
            ManageInventoryStateStatus.fetchedDataSuccessfully,
          ]));
      expectLater(
          sut.stream.map((event) => event.parts.length),
          emitsInOrder([
            //initial length of the parts list in the state should be 0
            sut.state.parts.length,
            //after .loadParts is evoked, the parts list in the state should be equal
            //to the state.fetchAmount
            sut.state.fetchPartAmount,
            //when then .scrollCallback is evoke another state is emitted
            //but it is state.copy so the old parts.length is emitted which should
            //still be state.fetchPartAmount
            sut.state.fetchPartAmount,
            //after .loadParts() is evoked for the second time. the parts list length should be
            //twice that of the state.fetchPartAmount
            sut.state.fetchPartAmount * 2
          ]));
      //evoke the function
      sut.init();
      //expectations immediately after evoking the function
      //await the normal init() function lifecycle to complete
      await expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.loading,
            ManageInventoryStateStatus.fetchedDataSuccessfully
          ])).then((_) {
        //after it completes mock the user scrolling to the end of the page
        //evoke the scroll controller addListener() callback function
        scrollCallback!.call();
      });

      //verifications
      //verify that a callback function was passed to the .addListener
      //verify that the position of the scroll controller was compared and
      //is objects were called the appropriate number of times
      verify(() =>
              mockScrollController.addListener(any(that: isA<VoidCallback>())))
          .called(1);
      verify(() => mockScrollController.position).called(2);
      verify(() => mockScrollPosition.pixels).called(1);
      verify(() => mockScrollPosition.maxScrollExtent).called(1);
      //verify that the database was called twice
      verify(
        () => mockGetAllPartUsecase.call(any(that: isA<GetAllPartParams>())),
      ).called(2);
    });

    test("Shouldn't load more parts when the scroll position isn't maxed out",
        () async {
      mockSetup();

      //override the position.pixel that is already defined int the mockSetup()
      // so that the condition is not true
      when(() => mockScrollPosition.pixels).thenAnswer((_) => 50);
      //our expectations. reason why its before the call to .init() is because
      //the method will emit stat changes, and placing the listener before the method
      //ensures that all state changes are able to be captured
      expectLater(
          sut.stream.map((event) => event.status),
          emitsInOrder([
            ManageInventoryStateStatus.loading,
            ManageInventoryStateStatus.fetchedDataSuccessfully,
          ]));
      expectLater(
          sut.stream.map((event) => event.parts.length),
          emitsInOrder([
            //initial length of the parts list in the state should be 0
            sut.state.parts.length,
            //after .loadParts is evoked, the parts list in the state should be equal
            //to the state.fetchAmount
            sut.state.fetchPartAmount,
          ]));
      //evoke the function
      sut.init();
      //expectations immediately after evoking the function
      //await the normal init() function lifecycle to complete
      await expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.loading,
            ManageInventoryStateStatus.fetchedDataSuccessfully
          ])).then((_) {
        //after it completes mock the user scrolling to the end of the page
        //evoke the scroll controller addListener() callback function
        scrollCallback!.call();
      });

      //verifications
      //verify that a callback function was passed to the .addListener
      //verify that the position of the scroll controller was compared and
      //is objects were called the appropriate number of times
      verify(() =>
              mockScrollController.addListener(any(that: isA<VoidCallback>())))
          .called(1);
      verify(() => mockScrollController.position).called(2);
      verify(() => mockScrollPosition.pixels).called(1);
      verify(() => mockScrollPosition.maxScrollExtent).called(1);

      //usecase should only have been called once
      verify(
        () => mockGetAllPartUsecase.call(any(that: isA<GetAllPartParams>())),
      ).called(1);
    });

    test("Shouldn't load more parts when all parts are loaded", () async {
      mockSetup();

      //close the old cubit and instantiate an new one with a fetchPartAmount that
      //will ensure that all parts be loaded from the database
      sut.close();
      sut = ManageInventoryCubit(
          fetchPartAmount: valuesForTest.parts().length,
          scrollController: mockScrollController,
          getAllPartsUsecase: mockGetAllPartUsecase,
          getDatabaseLength: mockGetDatabaseLength);
      //our expectations. reason why its before the call to .init() is because
      //the method will emit stat changes, and placing the listener before the method
      //ensures that all state changes are able to be captured
      expectLater(
          sut.stream.map((event) => event.status),
          emitsInOrder([
            ManageInventoryStateStatus.loading,
            ManageInventoryStateStatus.fetchedDataSuccessfully,
          ]));
      expectLater(
          sut.stream.map((event) => event.parts.length),
          emitsInOrder([
            //initial length of the parts list in the state should be 0
            sut.state.parts.length,
            //after .loadParts is evoked, the parts list in the state should be equal
            //to the state.fetchAmount
            sut.state.fetchPartAmount,
          ]));
      //evoke the function
      sut.init();
      //expectations immediately after evoking the function
      //await the normal init() function lifecycle to complete
      await expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            ManageInventoryStateStatus.loading,
            ManageInventoryStateStatus.fetchedDataSuccessfully
          ])).then((_) {
        //after it completes mock the user scrolling to the end of the page
        //evoke the scroll controller addListener() callback function
        scrollCallback!.call();
      });

      //verifications
      //verify that a callback function was passed to the .addListener
      //verify that the position of the scroll controller was compared and
      //is objects were called the appropriate number of times
      verify(() =>
              mockScrollController.addListener(any(that: isA<VoidCallback>())))
          .called(1);
      verify(() => mockScrollController.position).called(2);
      verify(() => mockScrollPosition.pixels).called(1);
      verify(() => mockScrollPosition.maxScrollExtent).called(1);

      //usecase should only have been called once
      verify(
        () => mockGetAllPartUsecase.call(any(that: isA<GetAllPartParams>())),
      ).called(1);

      //the length of the part list in the state should be equal that of the
      //testing part list
      expect(sut.state.parts.length, valuesForTest.parts().length);
    });
  });

  group('.close()', () {
    test('Ensure the scrollController is properly closed', () {
      when(() => mockScrollController.dispose()).thenReturn(null);
      sut.close();
      verify(() => mockScrollController.dispose()).called(1);
    });
  });
}
