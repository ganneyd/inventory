import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/get_all_part.dart';
import 'package:mocktail/mocktail.dart';

import '../../setup.dart';

//class to mock the part repository for testing purposes
class MockPartRepository extends Mock implements PartRepository {}

void main() {
  //Define variables to be used across the tests
  //system under test which is the Add Part Usecase
  late GetAllPartsUsecase sut;
  //
  late MockPartRepository mockPartRepository;
  //
  late ValuesForTest valuesForTest;

  setUp(() async {
    //initialize all the variables
    valuesForTest = ValuesForTest();
    mockPartRepository = MockPartRepository();
    sut = GetAllPartsUsecase(mockPartRepository);
  });

  group('GetPartsUsecase.call()', () {
    test('should return a list of all parts between startIndex and pageIndex',
        () async {
      int startIndex = 2;
      int pageIndex = 10;
      //list
      List<PartEntity> parts = [];
      when(() => mockPartRepository.getAllParts(startIndex, pageIndex))
          .thenAnswer((invocation) async {
        for (int i = startIndex; i < pageIndex; i++) {
          parts.add(valuesForTest.parts()[i]);
        }
        return Right<Failure, List<PartEntity>>(parts);
      });

      var results = await sut
          .call(GetAllPartParams(pageIndex: pageIndex, startIndex: startIndex));
      expect(results, isA<Right<Failure, List<PartEntity>>>());
      var rightResult = <PartEntity>[];
      results.fold((l) => null, (r) => rightResult = r);
      expect(rightResult, equals(parts));
      verify(() => mockPartRepository.getAllParts(startIndex, pageIndex))
          .called(1);
    });

    test('should return ReadDataFailure upon an failure', () async {
      int startIndex = 2;
      int pageIndex = 10;
      when(() => mockPartRepository.getAllParts(startIndex, pageIndex))
          .thenAnswer((invocation) async {
        return const Left<Failure, List<PartEntity>>(ReadDataFailure());
      });

      var results = await sut
          .call(GetAllPartParams(pageIndex: pageIndex, startIndex: startIndex));
      expect(results, isA<Left<Failure, List<PartEntity>>>());
      Failure leftResult = const GetFailure();
      results.fold((l) => leftResult = l, (r) => null);
      expect(leftResult, equals(const ReadDataFailure()));
      verify(() => mockPartRepository.getAllParts(startIndex, pageIndex))
          .called(1);
    });
  });
}
