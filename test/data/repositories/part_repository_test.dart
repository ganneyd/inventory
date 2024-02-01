import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/exceptions.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/models/part/part_model.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../setup.dart';

class MockDatasource extends Mock implements Box<PartEntity> {}

// void main() {
//   late PartRepository sut;
//   late MockDatasource mockDatasource;
//   late PartEntity typicalPartEntity;
//   late Part typicalPart;
//   late ValuesForTest valuesForTest;
//   setUp(() {
//     valuesForTest = ValuesForTest();
//     typicalPart = Part.fromJson(valuesForTest.getPartList()[0]);
//     typicalPartEntity = PartEntity(
//         index: typicalPart.index,
//         nsn: typicalPart.nsn,
//         name: typicalPart.name,
//         serialNumber: typicalPart.serialNumber,
//         location: typicalPart.location,
//         requisitionPoint: typicalPart.requisitionPoint,
//         requisitionQuantity: typicalPart.requisitionQuantity,
//         quantity: typicalPart.quantity,
//         unitOfIssue: typicalPart.unitOfIssue,
//         partNumber: typicalPart.partNumber);
//     mockDatasource = MockDatasource();
//     sut = PartRepositoryImplementation(mockDatasource);
//   });

  ///Test the .create() method
  ///
  group('.create()', () {
    //setup mock calls for the test
    void mockSetup() {
      when(() =>
              mockDatasource.putAt(typicalPartEntity.index, typicalPartEntity))
          .thenAnswer((invocation) async {});
    }

    test('Should return a Right<Failure,void> on success', () async {
      mockSetup();
      var results = await sut.createPart(typicalPartEntity);
      //check tha† the return value matches the instance we expect
      expect(results, isA<Right<Failure, void>>());
      //verify that the datasource method was called only once
      verify(() =>
              mockDatasource.putAt(typicalPartEntity.index, typicalPartEntity))
          .called(1);
    });

    test('should return CreateDataFailure() on createDataException', () async {
      //throw an exception when the method is called
      when(() =>
              mockDatasource.putAt(typicalPartEntity.index, typicalPartEntity))
          .thenAnswer((invocation) async => throw CreateDataException());
      var results = await sut.createPart(typicalPartEntity);
      //check tha† the return value matches the instance we expect
      expect(results, isA<Left<Failure, void>>());
      //verify that the datasource method was called only once
      verify(() =>
              mockDatasource.putAt(typicalPartEntity.index, typicalPartEntity))
          .called(1);
    });

    test('should return CreateDataFailure() on Exception', () async {
      //throw an exception when the method is called
      when(() =>
              mockDatasource.putAt(typicalPartEntity.index, typicalPartEntity))
          .thenAnswer((invocation) async => throw Exception());
      var results = await sut.createPart(typicalPartEntity);
      //check tha† the return value matches the instance we expect
      expect(results, isA<Left<Failure, void>>());
      //verify that the datasource method was called only once
      verify(() =>
              mockDatasource.putAt(typicalPartEntity.index, typicalPartEntity))
          .called(1);
    });
  });

  group('getAllParts', () {
    //setup mock calls for the tests
    void mockSetup() {
      when(() => mockDatasource.length)
          .thenAnswer((invocation) => valuesForTest.parts().length);
      when(() => mockDatasource.getAt(any())).thenAnswer((invocation) {
        return valuesForTest.parts()[invocation.positionalArguments[0]];
      });
    }

    void mockSetupException({required bool readDataException}) {
      when(() => mockDatasource.length)
          .thenAnswer((invocation) => valuesForTest.parts().length);
      when(() => mockDatasource.getAt(any()))
          .thenThrow(readDataException ? Exception() : ReadDataException());
    }

    test('should return a List<PartEntity on success>', () async {
      //setup
      mockSetup();
      //indexes are within bounds of list
      int startIndex = 1;
      int pageIndex = startIndex + 5;
//get results from getAllParts() method
      var results = await sut.getAllParts(startIndex, pageIndex);
      List<PartEntity> rightRes = [];
      results.fold((l) => null, (r) => rightRes = r);
      //verify that the length was only retrieved once
      verify(() => mockDatasource.length).called(1);
      //verify that the getAt() method was called for the number of elements between startIndex and pageIndex
      verify(() => mockDatasource.getAt(any())).called(pageIndex);

//expectations
//the first element in the returned list should match the element at position startIndex in the test list
      expect(rightRes.first, valuesForTest.parts()[startIndex]);
      //the last element in the returned list should match the element at position pageIndex in the test list
      expect(rightRes.last, valuesForTest.parts()[pageIndex]);
      //the length of the list should be the difference between the startIndex and pageIndex +1
      expect(rightRes.length, equals(pageIndex - startIndex + 1));
    });

    //Exception testing

    test('Should return ReadDataFailure() on ReadDataException being thrown',
        () async {
      mockSetupException(readDataException: false);

      //indexes are within bounds of list
      int startIndex = 1;
      int pageIndex = startIndex + 5;
//get results from getAllParts() method
      var results = await sut.getAllParts(startIndex, pageIndex);
      var left = results.fold((l) => l, (r) => r);
      expect(results, isA<Left<Failure, List<PartEntity>>>());
      //the actual failure should be a ReadDataFailure()
      expect(left, const ReadDataFailure());
//the .length should only have been called once
      verify(() => mockDatasource.length).called(1);
      //the .getAt() should only have been called once before the exception was thrown
      verify(() => mockDatasource.getAt(startIndex)).called(1);
    });

    test(
        'Should return OutOfBoundsFailure() on IndexOutOfBoundsException being thrown',
        () async {
      mockSetup();
      //indexes are out of  bounds; startIndex should always be less than pageIndex
      //in this scenario it isn't so then an IndexOutOfBounds exception is thrown
      int startIndex = 10;
      int pageIndex = 5;
//get results from getAllParts() method
      var results = await sut.getAllParts(startIndex, pageIndex);
      var left = results.fold((l) => l, (r) => r);
      expect(results, isA<Left<Failure, List<PartEntity>>>());
      //the actual failure should be a ReadDataFailure()
      expect(left, OutOfBoundsFailure());
//the .length should only have been called once
      verify(() => mockDatasource.length).called(1);
      //the .getAt() should only have been called once before the exception was thrown
      verifyNever(() => mockDatasource.getAt(startIndex));
    });

    test('Should return GetFailure() on Exception being thrown', () async {
      mockSetupException(readDataException: true);

      //indexes are within bounds of list
      int startIndex = 1;
      int pageIndex = startIndex + 5;
//get results from getAllParts() method
      var results = await sut.getAllParts(startIndex, pageIndex);
      var left = results.fold((l) => l, (r) => r);
      expect(results, isA<Left<Failure, List<PartEntity>>>());
      //the actual failure should be a ReadDataFailure()
      expect(left, const GetFailure());
//the .length should only have been called once
      verify(() => mockDatasource.length).called(1);
      //the .getAt() should only have been called once before the exception was thrown
      verify(() => mockDatasource.getAt(startIndex)).called(1);
    });
  });
}
