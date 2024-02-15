import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:mocktail/mocktail.dart';

class MockPartRepository extends Mock implements PartRepository {}

void main() {
  late MockPartRepository mockPartRepository;
  late GetPartByPartNumberUsecase sut;

  setUp(() {
    mockPartRepository = MockPartRepository();
    sut = GetPartByPartNumberUsecase(mockPartRepository);
  });

  group('GetPartByPartNumberUsecase.call()', () {
    test(
        'should return List<PartEntity> with all parts that match the search criteria',
        () async {
      //setup
      const String key = '9878';
      //return Right
      when(() => mockPartRepository.searchPartsByField(
          fieldName: PartField.partNumber,
          queryKey: any(named: 'queryKey'))).thenAnswer((invocation) async {
        return const Right<Failure, List<PartEntity>>(<PartEntity>[]);
      });
      //await the results
      var results =
          await sut.call(const GetAllPartByPartNumberParams(queryKey: key));

      //check that the results is of Right
      expect(results, isA<Right<Failure, List<PartEntity>>>());
      verify(() => mockPartRepository.searchPartsByField(
          fieldName: PartField.partNumber, queryKey: key)).called(1);
    });

    test('should return ReadDataFailure() when an failure occurs', () async {
      //setup
      const String key = '9878';
      //return a Left
      when(() => mockPartRepository.searchPartsByField(
              fieldName: PartField.partNumber,
              queryKey: any(named: 'queryKey')))
          .thenAnswer((invocation) async =>
              const Left<Failure, List<PartEntity>>(ReadDataFailure()));

      //await the results
      var results =
          await sut.call(const GetAllPartByPartNumberParams(queryKey: key));
      //extract the failure
      Failure leftResult = const GetFailure();
      results.fold((l) => leftResult = l, (r) => null);
      //check that the failure if of ReadDataFailure
      expect(leftResult, equals(const ReadDataFailure()));
      //verify that the method in the repo was only called once
      verify(() => mockPartRepository.searchPartsByField(
          fieldName: PartField.partNumber, queryKey: key)).called(1);
    });
  });
}
