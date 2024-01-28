import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/get_part_by_serial_number.dart';
import 'package:mocktail/mocktail.dart';

import '../../data/datasource/setup.dart';

class MockPartRepository extends Mock implements PartRepository {}

void main() {
  late MockPartRepository mockPartRepository;
  late GetPartBySerialNumberUsecase sut;
  late ValuesForTest valuesForTest;

  setUp(() {
    valuesForTest = ValuesForTest();
    mockPartRepository = MockPartRepository();
    sut = GetPartBySerialNumberUsecase(mockPartRepository);
  });

  group('GetPartBySerialNumberUsecase.cal()', () {
    test(
        'should return List<PartEntity> with all parts that match the search criteria',
        () async {
      const String key = 'SY1293';
      const String name = 'serialNumber';
      var expectedPartList = valuesForTest
          .parts()
          .where((element) => element.serialNumber.contains(key))
          .toList();
      when(() => mockPartRepository.searchPartsByField(
          fieldName: any(named: 'fieldName'),
          queryKey: any(named: 'queryKey'))).thenAnswer((invocation) async {
        String queryKey = invocation.namedArguments[const Symbol('queryKey')];
        String fieldName = invocation.namedArguments[const Symbol('fieldName')];
        List<PartEntity> parts = [];
        if (fieldName == name) {
          parts = valuesForTest
              .parts()
              .where((element) => element.serialNumber.contains(queryKey))
              .toList();
        }
        return Right<Failure, List<PartEntity>>(parts);
      });

      var results =
          await sut.call(const GetAllPartBySerialNumberParams(queryKey: key));
      verify(() => mockPartRepository.searchPartsByField(
          fieldName: name, queryKey: key)).called(1);
      var rightResult = <PartEntity>[];
      results.fold((l) => null, (r) => rightResult = r);
      expect(rightResult, equals(expectedPartList));
    });

    test('should return ReadDataFailure() when an failure occurs', () async {
      const String key = 'SY1293';
      const String name = 'serialNumber';
      when(() => mockPartRepository.searchPartsByField(
              fieldName: any(named: 'fieldName'),
              queryKey: any(named: 'queryKey')))
          .thenAnswer((invocation) async =>
              const Left<Failure, List<PartEntity>>(ReadDataFailure()));

      var results =
          await sut.call(const GetAllPartBySerialNumberParams(queryKey: key));
      Failure leftResult = const GetFailure();
      results.fold((l) => leftResult = l, (r) => null);
      expect(leftResult, equals(const ReadDataFailure()));
      verify(() => mockPartRepository.searchPartsByField(
          fieldName: name, queryKey: key)).called(1);
    });
  });
}