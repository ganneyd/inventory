import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/get_part_by_nsn.dart';
import 'package:mocktail/mocktail.dart';

import '../../setup.dart';

class MockPartRepository extends Mock implements PartRepository {}

void main() {
  late MockPartRepository mockPartRepository;
  late GetPartByNsnUseCase sut;
  late ValuesForTest valuesForTest;

  setUp(() {
    valuesForTest = ValuesForTest();
    mockPartRepository = MockPartRepository();
    sut = GetPartByNsnUseCase(mockPartRepository);
  });

  group('GetPartByNsnUsecase.cal()', () {
    test(
        'should return List<PartEntity> with all parts that match the search criteria',
        () async {
      const String key = '9878';
      const String name = 'nsn';
      var expectedPartList = valuesForTest
          .parts()
          .where((element) => element.nsn.contains(key))
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
              .where((element) => element.nsn.contains(queryKey))
              .toList();
        }
        return Right<Failure, List<PartEntity>>(parts);
      });

      var results = await sut.call(const GetAllPartByNsnParams(queryKey: key));
      var rightResult = <PartEntity>[];
      results.fold((l) => null, (r) => rightResult = r);
      expect(rightResult, equals(expectedPartList));
      verify(() => mockPartRepository.searchPartsByField(
          fieldName: name, queryKey: key)).called(1);
    });

    test('should return ReadDataFailure() when an failure occurs', () async {
      const String key = '9878';
      const String name = 'nsn';
      when(() => mockPartRepository.searchPartsByField(
              fieldName: any(named: 'fieldName'),
              queryKey: any(named: 'queryKey')))
          .thenAnswer((invocation) async =>
              const Left<Failure, List<PartEntity>>(ReadDataFailure()));

      var results = await sut.call(const GetAllPartByNsnParams(queryKey: key));
      Failure leftResult = const GetFailure();
      results.fold((l) => leftResult = l, (r) => null);
      expect(leftResult, equals(const ReadDataFailure()));
      verify(() => mockPartRepository.searchPartsByField(
          fieldName: name, queryKey: key)).called(1);
    });
  });
}
