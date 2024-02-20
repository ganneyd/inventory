import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/get_all_part.dart';
import 'package:mocktail/mocktail.dart';

//class to mock the part repository for testing purposes
class MockPartRepository extends Mock implements PartRepository {}

void main() {
  //Define variables to be used across the tests
  //system under test which is the Add Part Usecase
  late GetAllPartsUsecase sut;
  //
  late MockPartRepository mockPartRepository;
  //

  setUp(() async {
    //initialize all the variables

    mockPartRepository = MockPartRepository();
    sut = GetAllPartsUsecase(mockPartRepository);
  });

  group('GetPartsUsecase.call()', () {
    test('should return a list of all parts between startIndex and pageIndex',
        () async {
      //list

      when(() => mockPartRepository.getAllParts(
              any(that: isA<int>()), any(that: isA<int>())))
          .thenAnswer(
              (invocation) async => const Right<Failure, List<PartEntity>>([]));

      var results = await sut.call(
          const GetAllPartParams(currentDatabaseLength: 0, fetchAmount: 30));
      expect(results, isA<Right<Failure, List<PartEntity>>>());

      var capture = verify(() => mockPartRepository.getAllParts(
          captureAny(that: isA<int>()), captureAny(that: isA<int>()))).captured;
      var currentListLength = capture.first as int;
      var fetchAmount = capture.last as int;
      expect(currentListLength, 0);
      expect(fetchAmount, 30);
    });

    test('should return ReadDataFailure upon an failure', () async {
      when(() => mockPartRepository.getAllParts(
              any(that: isA<int>()), any(that: isA<int>())))
          .thenAnswer((invocation) async {
        return const Left<Failure, List<PartEntity>>(ReadDataFailure());
      });

      var results = await sut.call(
          const GetAllPartParams(currentDatabaseLength: 0, fetchAmount: 20));
      expect(results, const Left<Failure, List<PartEntity>>(ReadDataFailure()));

      var capture = verify(() => mockPartRepository.getAllParts(
          captureAny(that: isA<int>()), captureAny(that: isA<int>()))).captured;
      var currentListLength = capture.first as int;
      var fetchAmount = capture.last as int;
      expect(currentListLength, 0);
      expect(fetchAmount, 20);
    });
  });
}
