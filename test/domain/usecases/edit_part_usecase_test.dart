import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/models/part/part_model.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/edit_part.dart';
import 'package:mocktail/mocktail.dart';

import '../../setup.dart';

//class to mock the part repository for testing purposes
class MockPartRepository extends Mock implements PartRepository {}

void main() {
  //Define variables to be used across the tests
  //system under test which is the Add Part Usecase
  late EditPartUsecase sut;
  //
  late MockPartRepository mockPartRepository;
  //
  late PartEntity typicalPartEntity;
  //
  late ValuesForTest valuesForTest;

  setUp(() async {
    //initialize all the variables
    valuesForTest = ValuesForTest();
    typicalPartEntity = Part.fromJson(valuesForTest.getPartList()[0]);
    mockPartRepository = MockPartRepository();
    sut = EditPartUsecase(mockPartRepository);
  });

  group('EditPartUsecase.call()', () {
    test('should return void upon editing the part successfully', () async {
      when(() => mockPartRepository.editPart(typicalPartEntity))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));

      var results =
          await sut.call(EditPartParams(partEntity: typicalPartEntity));
      expect(results, isA<Right<Failure, void>>());
      verify(() => mockPartRepository.editPart(typicalPartEntity)).called(1);
    });

    test('should return Failure upon error editing the part', () async {
      when(() => mockPartRepository.editPart(typicalPartEntity)).thenAnswer(
          (invocation) async => Left<Failure, void>(CreateDataFailure()));

      var results =
          await sut.call(EditPartParams(partEntity: typicalPartEntity));
      expect(results, isA<Left<Failure, void>>());
      verify(() => mockPartRepository.editPart(typicalPartEntity)).called(1);
    });
  });
}
