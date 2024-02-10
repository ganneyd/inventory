import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/usecases/checkout/get_unverified_checkout_parts.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup.dart';

class MockCheckoutPartRepository extends Mock
    implements CheckedOutPartRepository {}

void main() {
  late GetUnverifiedCheckoutParts sut;
  late MockCheckoutPartRepository mockCheckoutPartRepository;
  late List<CheckedOutEntity> checkoutParts;

  setUp(() {
    mockCheckoutPartRepository = MockCheckoutPartRepository();
    sut = GetUnverifiedCheckoutParts(mockCheckoutPartRepository);
    checkoutParts = ValuesForTest().createCheckedOutList();
  });

  test('should return a List<CheckoutEntity>', () async {
    UnverifiedCheckoutPartsParams params =
        const UnverifiedCheckoutPartsParams(endIndex: 20, startIndex: 0);
    when(
      () => mockCheckoutPartRepository.getCheckedOutItems(
          params.startIndex, params.endIndex),
    ).thenAnswer((invocation) async =>
        Right<Failure, List<CheckedOutEntity>>(checkoutParts));
    var results = await sut.call(params);
    List<CheckedOutEntity> expectedList = [];
    results.fold((l) => null, (list) => expectedList = list);
    expect(expectedList.length, 8);
    expect(results, isA<Right<Failure, List<CheckedOutEntity>>>());
    verify(
      () => mockCheckoutPartRepository.getCheckedOutItems(
          params.startIndex, params.endIndex),
    ).called(1);
  });

  test('should return a Failure', () async {
    UnverifiedCheckoutPartsParams params =
        const UnverifiedCheckoutPartsParams(endIndex: 20, startIndex: 0);
    when(
      () => mockCheckoutPartRepository.getCheckedOutItems(
          params.startIndex, params.endIndex),
    ).thenAnswer((invocation) async =>
        const Left<Failure, List<CheckedOutEntity>>(ReadDataFailure()));
    var results = await sut.call(params);
    Failure expectedFailure = const GetFailure();
    results.fold((failure) => expectedFailure = failure, (list) => null);
    expect(expectedFailure, const ReadDataFailure());
    expect(results, isA<Left<Failure, List<CheckedOutEntity>>>());

    verify(
      () => mockCheckoutPartRepository.getCheckedOutItems(
          params.startIndex, params.endIndex),
    ).called(1);
  });
}
