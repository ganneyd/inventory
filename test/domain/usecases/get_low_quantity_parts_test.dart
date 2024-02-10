import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/get_low_quantity_parts.dart';
import 'package:mocktail/mocktail.dart';

import '../../setup.dart';

class MockPartRepository extends Mock implements PartRepository {}

void main() {
  late GetLowQuantityParts sut;
  late MockPartRepository mockPartRepository;

  setUp(() {
    mockPartRepository = MockPartRepository();
    sut = GetLowQuantityParts(mockPartRepository);
  });

  test('Should return a List<PartEntity>', () async {
    GetLowQuantityPartsParams params =
        const GetLowQuantityPartsParams(endIndex: 20, startIndex: 0);
    when(
      () => mockPartRepository.getAllParts(params.startIndex, params.endIndex),
    ).thenAnswer((invocation) async =>
        Right<Failure, List<PartEntity>>(ValuesForTest().parts()));

    var results = await sut.call(params);

    List<PartEntity> returnList = [];

    results.fold((l) => null, (list) => returnList = list);

    expect(results, isA<Right<Failure, List<PartEntity>>>());
    expect(returnList.length, 4);
    verify(() =>
            mockPartRepository.getAllParts(params.startIndex, params.endIndex))
        .called(1);
  });

  test('Should return ReadDataFailure()', () async {
    GetLowQuantityPartsParams params =
        const GetLowQuantityPartsParams(endIndex: 20, startIndex: 0);
    when(
      () => mockPartRepository.getAllParts(params.startIndex, params.endIndex),
    ).thenAnswer((invocation) async =>
        const Left<Failure, List<PartEntity>>(ReadDataFailure()));

    var results = await sut.call(params);

    Failure? returnFailure;

    results.fold((fail) => returnFailure = fail, (list) => null);

    expect(results, isA<Left<Failure, List<PartEntity>>>());
    expect(returnFailure, const ReadDataFailure());
    verify(() =>
            mockPartRepository.getAllParts(params.startIndex, params.endIndex))
        .called(1);
  });
}
