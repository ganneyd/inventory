import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/search_results/cubit/search_results_cubit.dart';
import 'package:inventory_v1/presentation/pages/search_results/cubit/search_results_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../setup.dart';

//mocks
class MockGetPartByNSN extends Mock implements GetPartByNsnUseCase {}

class MockGetPartByName extends Mock implements GetPartByNameUseCase {}

class MockGetBySerial extends Mock implements GetPartBySerialNumberUsecase {}

class MockGetByPartNumber extends Mock implements GetPartByPartNumberUsecase {}

class MockTextEditingController extends Mock implements TextEditingController {}

class MockScrollController extends Mock implements ScrollController {}

void main() {
  late SearchPartCubit sut;
  late MockGetByPartNumber mockGetByPartNumber;
  late MockGetPartByNSN mockGetPartByNSN;
  late MockGetBySerial mockGetBySerial;
  late MockGetPartByName mockGetPartByName;
  late MockScrollController mockScrollController;
  late MockTextEditingController mockTextEditingController;
  late ValuesForTest valuesForTest;
  setUp(() {
    valuesForTest = ValuesForTest();
    mockGetByPartNumber = MockGetByPartNumber();
    mockGetBySerial = MockGetBySerial();
    mockGetPartByNSN = MockGetPartByNSN();
    mockGetPartByName = MockGetPartByName();
    mockScrollController = MockScrollController();
    mockTextEditingController = MockTextEditingController();
    sut = SearchPartCubit(
        editingController: mockTextEditingController,
        scrollController: mockScrollController,
        getPartByNameUseCase: mockGetPartByName,
        getPartByNsnUseCase: mockGetPartByNSN,
        getPartByPartNumberUsecase: mockGetByPartNumber,
        getPartBySerialNumberUsecase: mockGetBySerial);

    registerFallbackValue(const GetAllPartByNameParams(queryKey: ''));
    registerFallbackValue(const GetAllPartByNsnParams(queryKey: ''));
    registerFallbackValue(const GetAllPartByPartNumberParams(queryKey: ''));
    registerFallbackValue(const GetAllPartBySerialNumberParams(queryKey: ''));
  });

  List<Part> toPartList(List<PartEntity> list) {
    List<Part> partModel = [];
    for (var part in list) {
      partModel.add(PartAdapter.fromEntity(part));
    }
    return partModel;
  }

  group('SearchPartCubit() initial state', () {
    test('correct state', () {
      expect(sut.state.partsByName, <Part>[]);
      expect(sut.state.partsByNsn, <Part>[]);
      expect(sut.state.partsByPartNumber, <Part>[]);
      expect(sut.state.partsBySerialNumber, <Part>[]);
      expect(sut.state.error, 'no-error');
      expect(sut.state.status, SearchResultsStateStatus.loading);
      expect(sut.state.scrollController, isA<ScrollController>());
      expect(sut.state.searchBarController, isA<TextEditingController>());
    });
  });

  group('.searchParts()', () {
    void mockSetup() {
      when(() => mockTextEditingController.text)
          .thenAnswer((invocation) => 'key');
      when(() => mockGetByPartNumber
              .call(any(that: isA<GetAllPartByPartNumberParams>())))
          .thenAnswer((invocation) async =>
              Right<Failure, List<Part>>(toPartList(valuesForTest.parts())));
      when(() => mockGetBySerial
              .call(any(that: isA<GetAllPartBySerialNumberParams>())))
          .thenAnswer((invocation) async =>
              Right<Failure, List<Part>>(toPartList(valuesForTest.parts())));
      when(() => mockGetPartByNSN.call(any(that: isA<GetAllPartByNsnParams>())))
          .thenAnswer((invocation) async =>
              Right<Failure, List<Part>>(toPartList(valuesForTest.parts())));
      when(() =>
              mockGetPartByName.call(any(that: isA<GetAllPartByNameParams>())))
          .thenAnswer((invocation) async =>
              Right<Failure, List<Part>>(toPartList(valuesForTest.parts())));
    }

    test('all usecases complete successfully', () async {
      //setup
      mockSetup();
      //start stream listener before evoking function
      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            SearchResultsStateStatus.loading,
            SearchResultsStateStatus.loading,
            SearchResultsStateStatus.loading,
            SearchResultsStateStatus.loading,
            SearchResultsStateStatus.loading,
            SearchResultsStateStatus.searchSuccessful
          ])).then((value) {
        verify(() => mockGetByPartNumber
            .call(any(that: isA<GetAllPartByPartNumberParams>()))).called(1);
        verify(() => mockGetBySerial
            .call(any(that: isA<GetAllPartBySerialNumberParams>()))).called(1);
        verify(() =>
                mockGetPartByNSN.call(any(that: isA<GetAllPartByNsnParams>())))
            .called(1);
        verify(() => mockGetPartByName
            .call(any(that: isA<GetAllPartByNameParams>()))).called(1);
        verify(() => mockTextEditingController.text).called(5);

        //expectations
        //all the list should not be empty
        var expectedList = toPartList(valuesForTest.parts());
        expect(sut.state.partsByName, expectedList);
        expect(sut.state.partsByNsn, expectedList);
        expect(sut.state.partsByPartNumber, expectedList);
        expect(sut.state.partsBySerialNumber, expectedList);
      });
      sut.searchPart();
    });

    test('one or more usecases complete unsuccessfully', () async {
      //setup
      mockSetup();
      when(() =>
              mockGetPartByName.call(any(that: isA<GetAllPartByNameParams>())))
          .thenAnswer((invocation) async =>
              const Left<Failure, List<Part>>(GetFailure()));
      //start stream listener before evoking function
      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            SearchResultsStateStatus.loading,
            SearchResultsStateStatus.loading,
            SearchResultsStateStatus.loading,
            SearchResultsStateStatus.loading,
            SearchResultsStateStatus.searchUnsuccessful
          ])).then((value) {
        verify(() => mockGetByPartNumber
            .call(any(that: isA<GetAllPartByPartNumberParams>()))).called(1);
        verify(() => mockGetBySerial
            .call(any(that: isA<GetAllPartBySerialNumberParams>()))).called(1);
        verify(() =>
                mockGetPartByNSN.call(any(that: isA<GetAllPartByNsnParams>())))
            .called(1);
        verify(() => mockGetPartByName
            .call(any(that: isA<GetAllPartByNameParams>()))).called(1);
        verify(() => mockTextEditingController.text).called(5);

        //expectations
        //all the list should not be empty
        var expectedList = toPartList(valuesForTest.parts());
        expect(sut.state.partsByName, <Part>[]);
        expect(sut.state.partsByNsn, expectedList);
        expect(sut.state.partsByPartNumber, expectedList);
        expect(sut.state.partsBySerialNumber, expectedList);
      });
      sut.searchPart();
    });

    test('the search key is null', () {
      //setup
      mockSetup();
      when(() => mockTextEditingController.text).thenAnswer((invocation) => '');
      //start stream listener before evoking function
      expectLater(
          sut.stream.map((state) => state.status),
          emitsInOrder([
            SearchResultsStateStatus.loading,
            SearchResultsStateStatus.loadedUnsuccessfully
          ])).then((value) {
        verifyNever(() => mockGetByPartNumber
            .call(any(that: isA<GetAllPartByPartNumberParams>())));
        verifyNever(() => mockGetBySerial
            .call(any(that: isA<GetAllPartBySerialNumberParams>())));
        verifyNever(() =>
            mockGetPartByNSN.call(any(that: isA<GetAllPartByNsnParams>())));
        verifyNever(() =>
            mockGetPartByName.call(any(that: isA<GetAllPartByNameParams>())));
        verify(() => mockTextEditingController.text).called(1);

        //expectations
        //all the list should not be empty
        expect(sut.state.partsByName, <Part>[]);
        expect(sut.state.partsByNsn, <Part>[]);
        expect(sut.state.partsByPartNumber, <Part>[]);
        expect(sut.state.partsBySerialNumber, <Part>[]);
      });
      sut.searchPart();
    });
  });
}
