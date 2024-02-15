import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/exceptions.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../setup.dart';

class MockDatasource extends Mock implements Box<PartModel> {}

void main() {
  late PartRepository sut;
  late MockDatasource mockDatasource;
  late PartEntity typicalPartEntity;
  late PartModel typicalPart;
  late ValuesForTest valuesForTest;
  setUp(() {
    valuesForTest = ValuesForTest();
    typicalPart = PartModel.fromJson(valuesForTest.getPartList()[0]);
    typicalPartEntity = PartEntity(
        checksum: 0,
        index: typicalPart.index,
        nsn: typicalPart.nsn,
        name: typicalPart.name,
        serialNumber: typicalPart.serialNumber,
        location: typicalPart.location,
        requisitionPoint: typicalPart.requisitionPoint,
        requisitionQuantity: typicalPart.requisitionQuantity,
        quantity: typicalPart.quantity,
        unitOfIssue: typicalPart.unitOfIssue,
        partNumber: typicalPart.partNumber);
    mockDatasource = MockDatasource();
    sut = PartRepositoryImplementation(mockDatasource);
    registerFallbackValue(typicalPartEntity);
  });

  ///Test the .create() method
  ///
  group('.create()', () {
    //setup mock calls for the test
    void mockSetup() {
      when(() => mockDatasource.isEmpty).thenAnswer((_) => false);
      when(() => mockDatasource.length)
          .thenAnswer((_) => valuesForTest.parts().length);

      when(() => mockDatasource.add(any(that: isA<PartEntity>())))
          .thenAnswer((_) async => 0);
    }

    test('Should return a Right<Failure,void> on success', () async {
      mockSetup();
      var results = await sut.createPart(typicalPartEntity);
      //check tha† the return value matches the instance we expect
      expect(results, isA<Right<Failure, void>>());
      //verify that the datasource method was called only once
      verify(() => mockDatasource.isEmpty).called(1);
      verify(() => mockDatasource.length).called(1);
      verify(() => mockDatasource.add(any())).called(1);
    });

    test('should return CreateDataFailure() on createDataException', () async {
      mockSetup();
      //throw an exception when the method is called
      when(() => mockDatasource.add(any(that: isA<PartEntity>())))
          .thenAnswer((invocation) async => throw CreateDataException());
      var results = await sut.createPart(typicalPartEntity);
      //check tha† the return value matches the instance we expect
      expect(results, isA<Left<Failure, void>>());
      verify(() => mockDatasource.isEmpty).called(1);
      verify(() => mockDatasource.length).called(1);
      verify(() => mockDatasource.add(any())).called(1);
    });

    test('should return CreateDataFailure() on Exception', () async {
      mockSetup();
      //throw an exception when the method is called
      when(() => mockDatasource.add(any(that: isA<PartEntity>())))
          .thenAnswer((invocation) async => throw Exception());
      var results = await sut.createPart(typicalPartEntity);
      //check tha† the return value matches the instance we expect
      expect(results, isA<Left<Failure, void>>());
      //verify that the datasource method was called only once
      verify(() => mockDatasource.isEmpty).called(1);
      verify(() => mockDatasource.length).called(1);
      verify(() => mockDatasource.add(any())).called(1);
    });
  });

  group('getAllParts()', () {
    //setup mock calls for the tests
    void mockSetup() {
      when(() => mockDatasource.length)
          .thenAnswer((invocation) => valuesForTest.parts().length);
      when(() => mockDatasource.getAt(any())).thenAnswer((invocation) {
        return PartEntityToModelAdapter.fromEntity(
            valuesForTest.parts()[invocation.positionalArguments[0]]);
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
      expect(left, IndexOutOfBoundsFailure());
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

  group('.getDatabaseLength()', () {
    test('Should return the length of the database', () async {
      //setup
      when(() => mockDatasource.length)
          .thenAnswer((invocation) => valuesForTest.parts().length);

      var results = await sut.getDatabaseLength();
      int length = 0;

      results.fold((l) => null, (r) => length = r);
      //results should be a Right
      expect(results, isA<Right<Failure, int>>());
      //the returned length should be equal to the .parts() length
      expect(length, valuesForTest.parts().length);

      //verify that the datasource length was called
      verify(() => mockDatasource.length).called(1);
    });

    test('Should return ReadDataFailure()', () async {
      //setup
      when(() => mockDatasource.length)
          .thenAnswer((invocation) => throw Exception());

      var results = await sut.getDatabaseLength();

      //results should be a Left
      expect(results, isA<Left<Failure, int>>());

      //verify that the datasource length was called
      verify(() => mockDatasource.length).called(1);
    });
  });

  group('.editPart()', () {
    test('Should return Right<Failure,void>', () async {
      when(() => mockDatasource.putAt(
              any(that: isA<int>()), any(that: isA<PartEntity>())))
          .thenAnswer((invocation) async {});
      var results = await sut.editPart(typicalPartEntity);
      expect(results, isA<Right<Failure, void>>());
      verify(() => mockDatasource.putAt(any(), any())).called(1);
    });

    test('Should return UpdateFailure on UpdateException', () async {
      //setup to throw an UpdateDataException()
      when(() => mockDatasource.putAt(
              any(that: isA<int>()), any(that: isA<PartEntity>())))
          .thenAnswer((invocation) async => throw UpdateDataException());
      //setup checks
      Failure failure = const GetFailure();
      //await the call to the repo
      var results = await sut.editPart(typicalPartEntity);
      //unfold the results
      results.fold((l) => failure = l, (_) => null);
      //check that the return type is a Left
      expect(results, isA<Left<Failure, void>>());
      //check that we got a UpdateFailure()
      expect(failure, const UpdateDataFailure());
      //the .putAt() should still be called
      verify(() => mockDatasource.putAt(any(), any())).called(1);
    });
    test('Should return UpdateFailure() on Exception', () async {
      //setup to throw an Exception()
      when(() => mockDatasource.putAt(
              any(that: isA<int>()), any(that: isA<PartEntity>())))
          .thenAnswer((invocation) async => throw Exception());
      //setup checks
      Failure failure = const GetFailure();
      //await the call to the repo
      var results = await sut.editPart(typicalPartEntity);
      //unfold the results
      results.fold((l) => failure = l, (_) => null);
      //check that the return type is a Left
      expect(results, isA<Left<Failure, void>>());
      //check that we got a UpdateFailure()
      expect(failure, const UpdateDataFailure());
      //the .putAt() should still be called
      verify(() => mockDatasource.putAt(any(), any())).called(1);
    });
  });
  group('.deletePart()', () {
    test('Should return Right<Failure,void>', () async {
      //setup .delete() mock method
      when(() => mockDatasource.delete(any(that: isA<int>())))
          .thenAnswer((invocation) async {});
      //await the results
      var results = await sut.deletePart(typicalPartEntity);
      //result should be of type Right
      expect(results, isA<Right<Failure, void>>());
      verify(() => mockDatasource.delete(
            any(),
          )).called(1);
    });

    test('Should return DeleteDataFailure() on DeleteDataException()',
        () async {
      //setup to throw an DeleteDataException()
      when(() => mockDatasource.delete(any(that: isA<int>())))
          .thenAnswer((invocation) async => throw DeleteDataException());
      //setup checks
      Failure failure = const GetFailure();
      //await the call to the repo
      var results = await sut.deletePart(typicalPartEntity);
      //unfold the results
      results.fold((l) => failure = l, (_) => null);
      //check that the return type is a Left
      expect(results, isA<Left<Failure, void>>());
      //check that we got a UpdateFailure()
      expect(failure, const DeleteDataFailure());
      //the .putAt() should still be called
      verify(() => mockDatasource.delete(any())).called(1);
    });
    test('Should return DeleteDataFailure() on Exception', () async {
      //setup to throw an Exception()
      when(() => mockDatasource.delete(any(that: isA<int>())))
          .thenAnswer((invocation) async => throw Exception());
      //setup checks
      Failure failure = const GetFailure();
      //await the call to the repo
      var results = await sut.deletePart(typicalPartEntity);
      //unfold the results
      results.fold((l) => failure = l, (_) => null);
      //check that the return type is a Left
      expect(results, isA<Left<Failure, void>>());
      //check that we got a DeleteDataFailure()
      expect(failure, const DeleteDataFailure());
      //the .putAt() should still be called
      verify(() => mockDatasource.delete(any())).called(1);
    });
  });
  group('.searchPartsByField() nsn', () {
    void mockSetUp() {
      when(() => mockDatasource.values)
          .thenAnswer((invocation) => valuesForTest.partModels());
    }

    test('matches the query nsn 9878', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.nsn, queryKey: '9878');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is only 3 parts that match the query
      expect(resultPartList.length, 3);
      expect(resultPartList[0], valuesForTest.parts()[0]);
      expect(resultPartList[1], valuesForTest.parts()[2]);
      expect(resultPartList[2], valuesForTest.parts()[5]);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('matches the query regardless of letters', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.nsn, queryKey: '9878');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is only 3 parts that match the query
      expect(resultPartList.length, 3);
      expect(resultPartList[0], valuesForTest.parts()[0]);
      expect(resultPartList[1], valuesForTest.parts()[2]);
      expect(resultPartList[2], valuesForTest.parts()[5]);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });
    test('matches the query regardless of special characters ', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.nsn, queryKey: '#*@#-0-024-98(*78');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is only 2 parts that match the query
      expect(resultPartList.length, 2);
      expect(resultPartList[0], valuesForTest.parts()[0]);
      expect(resultPartList[1], valuesForTest.parts()[2]);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('no match found', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.nsn, queryKey: '7634829048');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is no parts that matches the query
      expect(resultPartList.length, 0);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('no match found when query is all letters', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.nsn, queryKey: 'no-match');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is no parts that matches the query
      expect(resultPartList.length, 0);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('Exception() handling', () async {
      //setup
      mockSetUp();
      when(() => mockDatasource.values)
          .thenAnswer((invocation) => throw Exception());
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.nsn, queryKey: 'no-match');

      Failure resultFailure = const GetFailure();

      results.fold((l) => resultFailure = l, (r) => null);
      //based on the query provided and the data we have in the setup
      //there is no parts that matches the query
      expect(resultFailure, const ReadDataFailure());
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });
  });

  group('.searchPartsByField() name', () {
    void mockSetUp() {
      when(() => mockDatasource.containsKey(PartField.name))
          .thenAnswer((invocation) => true);

      when(() => mockDatasource.values)
          .thenAnswer((invocation) => valuesForTest.partModels());
    }

    test('matches the query regardless of case name ScRew', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.name, queryKey: 'ScRew');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //check the type of the result
      expect(results, isA<Right<Failure, List<PartEntity>>>());
      //based on the query provided and the data we have in the setup
      //there is only 3 parts that match the query
      expect(resultPartList.length, 3);
      expect(resultPartList[0], valuesForTest.parts()[0]);
      expect(resultPartList[1], valuesForTest.parts()[4]);
      expect(resultPartList[2], valuesForTest.parts()[8]);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('matches the query regardless of special characters', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.name, queryKey: '-@!#&*#)-ScreW-,,,se');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is only 2 parts that match the query
      expect(resultPartList.length, 2);
      expect(resultPartList[0], valuesForTest.parts()[0]);
      expect(resultPartList[1], valuesForTest.parts()[8]);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('matches the query regardless of numbers', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.name, queryKey: '-98938-ScreW-,,,se');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is only 2 parts that match the query
      expect(resultPartList.length, 2);
      expect(resultPartList[0], valuesForTest.parts()[0]);
      expect(resultPartList[1], valuesForTest.parts()[8]);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('no match found', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.name, queryKey: 'no-match');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is no parts that matches the query
      expect(resultPartList.length, 0);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('no match found when query is all numbers ', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.name, queryKey: '3424566');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is no parts that matches the query
      expect(resultPartList.length, 0);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('ReadDataException() handling', () async {
      //setup
      mockSetUp();
      when(() => mockDatasource.containsKey(PartField.name))
          .thenAnswer((invocation) => throw ReadDataException());
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.name, queryKey: 'no-match');

      Failure resultFailure = const GetFailure();

      results.fold((l) => resultFailure = l, (r) => null);
      //based on the query provided and the data we have in the setup
      //there is no parts that matches the query
      expect(resultFailure, const ReadDataFailure());
      //verify that the appropriate methods from the datasource was used
      //this method shouldn't be called
      verifyNever(() => mockDatasource.values);
    });

    test('Exception() handling', () async {
      //setup
      mockSetUp();
      when(() => mockDatasource.values)
          .thenAnswer((invocation) => throw Exception());
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.name, queryKey: 'no-match');

      Failure resultFailure = const GetFailure();

      results.fold((l) => resultFailure = l, (r) => null);
      //based on the query provided and the data we have in the setup
      //there is no parts that matches the query
      expect(resultFailure, const ReadDataFailure());
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });
  });

  group('.searchPartsByField() part number', () {
    void mockSetUp() {
      when(() => mockDatasource.containsKey(PartField.partNumber))
          .thenAnswer((invocation) => true);

      when(() => mockDatasource.values)
          .thenAnswer((invocation) => valuesForTest.partModels());
    }

    test('matches the query regardless of case', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.partNumber, queryKey: 'Ms40483-1');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //check the type of the result
      expect(results, isA<Right<Failure, List<PartEntity>>>());
      //based on the query provided and the data we have in the setup
      //there is only 3 parts that match the query
      expect(resultPartList.length, 2);
      expect(resultPartList[0], valuesForTest.parts()[0]);
      expect(resultPartList[1], valuesForTest.parts()[2]);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('matches the query regardless of special characters', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.partNumber, queryKey: '@#)()m*(S4)0');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is only 2 parts that match the query
      expect(resultPartList.length, 2);
      expect(resultPartList[0], valuesForTest.parts()[0]);
      expect(resultPartList[1], valuesForTest.parts()[2]);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('no match found', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.partNumber, queryKey: 'no-match');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is no parts that matches the query
      expect(resultPartList.length, 0);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('Exception() handling', () async {
      //setup
      mockSetUp();
      when(() => mockDatasource.values)
          .thenAnswer((invocation) => throw Exception());
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.partNumber, queryKey: 'no-match');

      Failure resultFailure = const GetFailure();

      results.fold((l) => resultFailure = l, (r) => null);
      //based on the query provided and the data we have in the setup
      //there is no parts that matches the query
      expect(resultFailure, const ReadDataFailure());
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });
  });

  group('.searchPartsByField() serial number', () {
    void mockSetUp() {
      when(() => mockDatasource.containsKey(PartField.serialNumber))
          .thenAnswer((invocation) => true);

      when(() => mockDatasource.values)
          .thenAnswer((invocation) => valuesForTest.partModels());
    }

    test('matches the query regardless of case', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.serialNumber, queryKey: 'sY13');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //check the type of the result
      expect(results, isA<Right<Failure, List<PartEntity>>>());
      //based on the query provided and the data we have in the setup
      //there is only 3 parts that match the query
      expect(resultPartList.length, 2);
      expect(resultPartList[0], valuesForTest.parts()[0]);
      expect(resultPartList[1], valuesForTest.parts()[5]);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('matches the query regardless of special characters', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.serialNumber, queryKey: '@#)()s*(Y)13');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is only 2 parts that match the query
      expect(resultPartList.length, 2);
      expect(resultPartList[0], valuesForTest.parts()[0]);
      expect(resultPartList[1], valuesForTest.parts()[5]);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('no match found', () async {
      //setup
      mockSetUp();
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.serialNumber, queryKey: 'no-match');

      //extract the returned list
      var resultPartList = <PartEntity>[];

      results.fold((l) => null, (r) => resultPartList = r);
      //based on the query provided and the data we have in the setup
      //there is no parts that matches the query
      expect(resultPartList.length, 0);
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });

    test('Exception() handling', () async {
      //setup
      mockSetUp();
      when(() => mockDatasource.values)
          .thenAnswer((invocation) => throw Exception());
      //await the results
      var results = await sut.searchPartsByField(
          fieldName: PartField.serialNumber, queryKey: 'no-match');

      Failure resultFailure = const GetFailure();

      results.fold((l) => resultFailure = l, (r) => null);
      //based on the query provided and the data we have in the setup
      //there is no parts that matches the query
      expect(resultFailure, const ReadDataFailure());
      //verify that the appropriate methods from the datasource was used
      verify(() => mockDatasource.values).called(1);
    });
  });
}
