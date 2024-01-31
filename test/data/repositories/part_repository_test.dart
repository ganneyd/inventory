// import 'package:dartz/dartz.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:inventory_v1/core/error/exceptions.dart';
// import 'package:inventory_v1/core/error/failures.dart';
// import 'package:inventory_v1/data/datasources/local_database.dart';
// import 'package:inventory_v1/data/models/part/part_model.dart';
// import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
// import 'package:inventory_v1/domain/entities/part/part_entity.dart';
// import 'package:inventory_v1/domain/repositories/part_repository.dart';
// import 'package:mocktail/mocktail.dart';

// import '../datasource/setup.dart';

// class MockDatasource extends Mock implements LocalDataSource {}

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

//   group('.createPart()', () {
//     void mockCreatePartSetup() {
//       when(() => mockDatasource.createData(newData: typicalPart.toJson()))
//           .thenAnswer((invocation) async => {});
//     }

//     test('should return Right<Failure,void>', () async {
//       mockCreatePartSetup();
//       var results = await sut.createPart(typicalPartEntity);
//       expect(results, isA<Right<Failure, void>>());
//       verify(() => mockDatasource.createData(newData: typicalPart.toJson()))
//           .called(1);
//     });

//     test('returns Left<Failure,void> when there is an CreateDataException',
//         () async {
//       when(() => mockDatasource.createData(newData: typicalPart.toJson()))
//           .thenAnswer((invocation) async => throw CreateDataException());
//       var results = await sut.createPart(typicalPartEntity);
//       expect(results, isA<Left<Failure, void>>());
//       verify(() => mockDatasource.createData(newData: typicalPart.toJson()))
//           .called(1);
//     });

//     test('returns Left<Failure,void> when there is an exception', () async {
//       when(() => mockDatasource.createData(newData: typicalPart.toJson()))
//           .thenAnswer((invocation) async => throw Exception());
//       var results = await sut.createPart(typicalPartEntity);
//       expect(results, isA<Left<Failure, void>>());
//       verify(() => mockDatasource.createData(newData: typicalPart.toJson()))
//           .called(1);
//     });
//   });

//   group('.deletePart()', () {
//     test('should return Right<Failure,void>', () async {
//       when(() => mockDatasource.deleteData(index: typicalPart.index))
//           .thenAnswer((invocation) async => {});

//       var results = await sut.deletePart(typicalPartEntity);
//       expect(results, isA<Right<Failure, void>>());
//       verify(() => mockDatasource.deleteData(index: typicalPart.index))
//           .called(1);
//     });

//     test('returns Left<Failure,void> when there is an DeleteDataException',
//         () async {
//       when(() => mockDatasource.deleteData(index: typicalPart.index))
//           .thenAnswer((invocation) async => throw DeleteDataException());
//       var results = await sut.deletePart(typicalPartEntity);
//       expect(results, isA<Left<Failure, void>>());
//       verify(() => mockDatasource.deleteData(index: typicalPart.index))
//           .called(1);
//     });

//     test('returns Left<Failure,void> when there is an Exception', () async {
//       when(() => mockDatasource.deleteData(index: typicalPart.index))
//           .thenAnswer((invocation) async => throw Exception());
//       var results = await sut.deletePart(typicalPartEntity);
//       expect(results, isA<Left<Failure, void>>());
//       verify(() => mockDatasource.deleteData(index: typicalPart.index))
//           .called(1);
//     });
//   });

//   group('.updatePart()', () {
//     test('should return Right<Failure,void>', () async {
//       when(() => mockDatasource.updateData(
//           updatedData: any(named: 'updatedData'),
//           index: any(named: 'index'))).thenAnswer((invocation) async => {});

//       var results = await sut.editPart(typicalPartEntity);
//       expect(results, isA<Right<Failure, void>>());
//       verify(() => mockDatasource.updateData(
//           updatedData: typicalPart.toJson(),
//           index: typicalPart.index)).called(1);
//     });

//     test('returns Left<Failure,void> when there is an UpdateDataException',
//         () async {
//       when(() => mockDatasource.updateData(
//               updatedData: typicalPart.toJson(), index: typicalPart.index))
//           .thenAnswer((invocation) async => throw UpdateDataException());
//       var results = await sut.editPart(typicalPartEntity);
//       expect(results, isA<Left<Failure, void>>());
//       verify(() => mockDatasource.updateData(
//           updatedData: typicalPart.toJson(),
//           index: typicalPart.index)).called(1);
//     });

//     test('returns Left<Failure,void> when there is an Exception', () async {
//       when(() => mockDatasource.updateData(
//               updatedData: typicalPart.toJson(), index: typicalPart.index))
//           .thenAnswer((invocation) async => throw UpdateDataException());
//       var results = await sut.editPart(typicalPartEntity);
//       expect(results, isA<Left<Failure, void>>());
//       verify(() => mockDatasource.updateData(
//           updatedData: typicalPart.toJson(),
//           index: typicalPart.index)).called(1);
//     });
//   });

//   group('.getAllParts', () {
//     void mockGetAllPartsSetup() {
//       when(() => mockDatasource.getLength()).thenAnswer((invocation) {
//         var len = valuesForTest.partsList.length;
//         return len;
//       });

//       when(() => mockDatasource.readData(index: any(named: 'index')))
//           .thenAnswer((invocation) async {
//         int rangeIndex = invocation.namedArguments[const Symbol('index')];
//         var result = valuesForTest.getPartList()[rangeIndex];

//         return result;
//       });
//     }

//     int getLen(int startIndex, int pageIndex) {
//       int upperBound = valuesForTest.partsList.length;
//       int lowerBound = 0;
//       if (startIndex > lowerBound) {
//         lowerBound = startIndex;
//       }
//       if (pageIndex < upperBound) {
//         upperBound = pageIndex + 1;
//       }
//       return upperBound - lowerBound;
//     }

//     test('should return a Right<List<Part>>,Failure> when successful',
//         () async {
//       mockGetAllPartsSetup();
//       const int pageIndex = 8;
//       const int startIndex = 2;

//       var results = await sut.getAllParts(startIndex, pageIndex);
//       //verify that the method was called per expected number of iterations
//       verify(() => mockDatasource.readData(index: any(named: 'index')))
//           .called(getLen(startIndex, pageIndex));
//       //check that results returns what is expected
//       expect(results, isA<Right<Failure, List<PartEntity>>>());
//     });

//     test(
//         'should return a List<PartEntity> when startIndex and pageIndex are within bounds of data list length',
//         () async {
//       mockGetAllPartsSetup();
//       const int pageIndex = 8;
//       const int startIndex = 4;
//       //get the results from .getAllParts()
//       var results = await sut.getAllParts(startIndex, pageIndex);
//       //verify that the method was called per expected number of iterations
//       verify(() => mockDatasource.readData(index: any(named: 'index')))
//           .called(getLen(startIndex, pageIndex));
//       List<PartEntity> rightResult = [];
//       //extract the right value
//       results.fold((l) => null, (r) => rightResult = r);
//       //check that the List length equals the amount of items we expect to receive
//       expect(rightResult.length, equals(getLen(startIndex, pageIndex)));
//       //extract the entity that exists at the startIndex in the dataList
//       PartEntity firstEntity =
//           Part.fromJson(valuesForTest.getPartList()[startIndex]);
//       //firstEntity should be the first item in the list returned by .getAllParts()
//       expect(rightResult[0], firstEntity);
//       //extract the  entity given the pageIndex, if the page index is greater than the list length
//       //then use the list len to get the entity
//       Part lastEntity = Part.fromJson(valuesForTest.getPartList()[
//           pageIndex >= valuesForTest.partsList.length
//               ? valuesForTest.partsList.length - 1
//               : pageIndex]);
//       //lastEntity should be the last item in the list returned by .getAllParts()
//       expect(rightResult[rightResult.length - 1], lastEntity);
//     });

//     test(
//         'should return a List<PartEntity> when startIndex is within bounds  and pageIndex is out of bounds',
//         () async {
//       mockGetAllPartsSetup();
//       const int pageIndex = 12233;
//       const int startIndex = 4;
//       //get the results from .getAllParts()
//       var results = await sut.getAllParts(startIndex, pageIndex);
//       //verify that the method was called per expected number of iterations
//       verify(() => mockDatasource.readData(index: any(named: 'index')))
//           .called(getLen(startIndex, pageIndex));
//       List<PartEntity> rightResult = [];
//       //extract the right value
//       results.fold((l) => null, (r) => rightResult = r);
//       //check that the List length equals the amount of items we expect to receive
//       expect(rightResult.length, equals(getLen(startIndex, pageIndex)));
//       //extract the entity that exists at the startIndex in the dataList
//       PartEntity firstEntity =
//           Part.fromJson(valuesForTest.getPartList()[startIndex]);
//       //firstEntity should be the first item in the list returned by .getAllParts()
//       expect(rightResult[0], firstEntity);
//       //extract the  entity given the pageIndex, if the page index is greater than the list length
//       //then use the list len to get the entity
//       Part lastEntity = Part.fromJson(valuesForTest.getPartList()[
//           pageIndex >= valuesForTest.partsList.length
//               ? valuesForTest.partsList.length - 1
//               : pageIndex]);
//       //lastEntity should be the last item in the list returned by .getAllParts()
//       expect(rightResult[rightResult.length - 1], lastEntity);
//     });

//     test(
//         'should return a List<PartEntity> when startIndex is less than 0   and pageIndex is within bounds',
//         () async {
//       mockGetAllPartsSetup();
//       const int pageIndex = 12233;
//       const int startIndex = -4;
//       //get the results from .getAllParts()
//       var results = await sut.getAllParts(startIndex, pageIndex);
//       //verify that the method was called per expected number of iterations
//       verify(() => mockDatasource.readData(index: any(named: 'index')))
//           .called(getLen(startIndex, pageIndex));
//       List<PartEntity> rightResult = [];
//       //extract the right value
//       results.fold((l) => null, (r) => rightResult = r);
//       //check that the List length equals the amount of items we expect to receive
//       expect(rightResult.length, equals(getLen(startIndex, pageIndex)));
//       //extract the entity that exists at the startIndex in the dataList
//       PartEntity firstEntity = Part.fromJson(
//           valuesForTest.getPartList()[startIndex < 0 ? 0 : startIndex]);
//       //firstEntity should be the first item in the list returned by .getAllParts()
//       expect(rightResult[0], firstEntity);
//       //extract the  entity given the pageIndex, if the page index is greater than the list length
//       //then use the list len to get the entity
//       Part lastEntity = Part.fromJson(valuesForTest.getPartList()[
//           pageIndex >= valuesForTest.partsList.length
//               ? valuesForTest.partsList.length - 1
//               : pageIndex]);
//       //lastEntity should be the last item in the list returned by .getAllParts()
//       expect(rightResult[rightResult.length - 1], lastEntity);
//     });

//     test(
//         'should return a Left<Failure,List<PartEntity>>(GetFailure()) when an exception occurs',
//         () async {
//       when(() => mockDatasource.getLength())
//           .thenAnswer((invocation) => throw Exception());
//       const int pageIndex = 12233;
//       const int startIndex = -4;
//       //get the results from .getAllParts()
//       var results = await sut.getAllParts(startIndex, pageIndex);
//       expect(results, isA<Left<Failure, List<PartEntity>>>());
//     });

//     test(
//         'should return a Left<Failure,List<PartEntity>>(GetFailure()) when startIndex is less than pageIndex',
//         () async {
//       mockGetAllPartsSetup();
//       const int pageIndex = 2;
//       const int startIndex = 10;
//       //get the results from .getAllParts()
//       var results = await sut.getAllParts(startIndex, pageIndex);
//       expect(results, isA<Left<Failure, List<PartEntity>>>());
//     });
//   });

//   group('.searchPartByField()', () {
//     void mockSearchPartByFieldSetup(int index) {
//       when(() => mockDatasource.queryData(
//           fieldName: any(named: 'fieldName'),
//           queryKey: any(named: 'queryKey'))).thenAnswer((invocation) async {
//         return [valuesForTest.getPartList()[index]];
//       });
//     }

//     test(
//         'should return a List<PartEntity>[] with the part that matches the nsn searched ',
//         () async {
//       //index of the part we want to find
//       int index = 2;
//       //the field that we want to search
//       String fieldName = 'nsn';
//       //the part that we want to find
//       Part searchPart = Part.fromJson(valuesForTest.getPartList()[index]);
//       //extract the last 4 of the nsn
//       String queryKey =
//           searchPart.nsn.toString().substring(searchPart.nsn.length - 4);
//       //setup for the mock calls;
//       mockSearchPartByFieldSetup(index);

//       var results = await sut.searchPartsByField(
//           fieldName: fieldName, queryKey: queryKey);
//       expect(results, isA<Right<Failure, List<PartEntity>>>());
//       var rightResult = <PartEntity>[];

//       results.fold((l) => null, (r) => rightResult = r);

//       expect(rightResult[0], searchPart);
//       verify(() => mockDatasource.queryData(
//           fieldName: fieldName, queryKey: queryKey)).called(1);
//     });

//     test(
//         'should return an empty List<PartEntity>[] when the query key does not match anything ',
//         () async {
//       //the field that we want to search
//       String fieldName = 'nsn';
//       //extract the last 4 of the nsn
//       String queryKey = 'does-not-exist';
//       //setup for the mock calls;
//       when(() => mockDatasource.queryData(
//               fieldName: any(named: 'fieldName'),
//               queryKey: any(named: 'queryKey')))
//           .thenAnswer((invocation) async => <Map<String, dynamic>>[]);

//       var results = await sut.searchPartsByField(
//           fieldName: fieldName, queryKey: queryKey);
//       expect(results, isA<Right<Failure, List<PartEntity>>>());
//       var rightResult = <PartEntity>[];

//       results.fold((l) => null, (r) => rightResult = r);

//       expect(rightResult.isEmpty, isTrue);
//       verify(() => mockDatasource.queryData(
//           fieldName: fieldName, queryKey: queryKey)).called(1);
//     });

//     test('should return Left<Failure,List<PartEntity>> an exception is thrown',
//         () async {
//       //the field that we want to search
//       String fieldName = 'nsn';
//       //extract the last 4 of the nsn
//       String queryKey = 'does-not-exist';
//       //setup for the mock calls;
//       when(() => mockDatasource.queryData(
//               fieldName: any(named: 'fieldName'),
//               queryKey: any(named: 'queryKey')))
//           .thenAnswer((invocation) => throw ReadDataException());

//       var results = await sut.searchPartsByField(
//           fieldName: fieldName, queryKey: queryKey);
//       expect(results, isA<Left<Failure, List<PartEntity>>>());
//       Failure leftResults = const GetFailure();

//       results.fold((l) => leftResults = l, (r) => null);
//       expect(leftResults, isA<ReadDataFailure>());
//       verify(() => mockDatasource.queryData(
//           fieldName: fieldName, queryKey: queryKey)).called(1);
//     });
//   });
// }
