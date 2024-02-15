import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/get_part_by_name.dart';
import 'package:mocktail/mocktail.dart';

class MockPartRepository extends Mock implements PartRepository {}

void main() {
  late MockPartRepository mockPartRepository;
  late GetPartByNameUseCase sut;

  setUp(() {
    mockPartRepository = MockPartRepository();
    sut = GetPartByNameUseCase(mockPartRepository);
  });

  group('GetPartByNameUsecase.call()', () {
    test(
        'should return List<PartEntity> with all parts that match the search criteria',
        () async {
      const String key = 'SCREW';
      when(() => mockPartRepository.searchPartsByField(
          fieldName: PartField.name,
          queryKey: any(named: 'queryKey'))).thenAnswer((invocation) async {
        return const Right<Failure, List<PartEntity>>(<PartEntity>[]);
      });

      var results = await sut.call(const GetAllPartByNameParams(queryKey: key));
      var rightResult = <PartEntity>[];
      results.fold((l) => null, (r) => rightResult = r);
      expect(rightResult, <PartEntity>[]);
      verify(() => mockPartRepository.searchPartsByField(
          fieldName: PartField.name, queryKey: key)).called(1);
    });

    test('should return ReadDataFailure() when an failure occurs', () async {
      //setup
      const String key = 'SCREW';
      //return a Left
      when(() => mockPartRepository.searchPartsByField(
              fieldName: PartField.name, queryKey: any(named: 'queryKey')))
          .thenAnswer((invocation) async =>
              const Left<Failure, List<PartEntity>>(ReadDataFailure()));
      //await the results
      var results = await sut.call(const GetAllPartByNameParams(queryKey: key));
      //extract the failure
      Failure leftResult = const GetFailure();
      results.fold((l) => leftResult = l, (r) => null);
      //check that the failure is of ReadDataFailure()
      expect(leftResult, equals(const ReadDataFailure()));
      //verify that the method in the repo was only called once
      verify(() => mockPartRepository.searchPartsByField(
          fieldName: PartField.name, queryKey: key)).called(1);
    });
  });
}
