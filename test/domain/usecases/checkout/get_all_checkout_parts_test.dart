import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/usecases/checkout/get_all_checkout_parts.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup.dart';

class MockCheckoutPartRepository extends Mock
    implements CheckedOutPartRepository {}

void main() {
  late GetAllCheckoutParts sut;
  late MockCheckoutPartRepository mockCheckoutPartRepository;
  late List<CheckedOutEntity> checkoutParts;
  late GetAllCheckoutPartsParams params;
  setUp(() {
    mockCheckoutPartRepository = MockCheckoutPartRepository();
    sut = GetAllCheckoutParts(mockCheckoutPartRepository);
    checkoutParts = ValuesForTest().createCheckedOutList();
    params =
        const GetAllCheckoutPartsParams(currentListLength: 0, fetchAmount: 20);
  });

  group('.call()', () {
    void mockSetup() {
      when(
        () => mockCheckoutPartRepository.getCheckedOutItems(
            any(that: isA<int>()), any(that: isA<int>())),
      ).thenAnswer((invocation) async =>
          Right<Failure, List<CheckedOutEntity>>(checkoutParts));
      when(() => mockCheckoutPartRepository.getDatabaseLength())
          .thenAnswer((invocation) async => const Right<Failure, int>(10));
    }

    test('should return a List<CheckoutEntity>', () async {
      mockSetup();

      var results = await sut.call(params);
      List<CheckedOutEntity> expectedList = [];
      results.fold((l) => null, (list) => expectedList.addAll(list));
      expect(expectedList, checkoutParts);
      expect(results, isA<Right<Failure, List<CheckedOutEntity>>>());
      verify(
        () => mockCheckoutPartRepository.getCheckedOutItems(
            any(that: isA<int>()), any(that: isA<int>())),
      ).called(1);
      verify(() => mockCheckoutPartRepository.getDatabaseLength()).called(1);
    });

    test('should return a Failure', () async {
      mockSetup();

      when(
        () => mockCheckoutPartRepository.getCheckedOutItems(
            any(that: isA<int>()), any(that: isA<int>())),
      ).thenAnswer((invocation) async =>
          const Left<Failure, List<CheckedOutEntity>>(ReadDataFailure()));
      var results = await sut.call(params);
      Failure expectedFailure = const GetFailure();
      results.fold((failure) => expectedFailure = failure, (list) => null);
      expect(expectedFailure, const ReadDataFailure());
      expect(results, isA<Left<Failure, List<CheckedOutEntity>>>());

      verify(
        () => mockCheckoutPartRepository.getCheckedOutItems(
            any(that: isA<int>()), any(that: isA<int>())),
      ).called(1);
      verify(() => mockCheckoutPartRepository.getDatabaseLength()).called(1);
    });
  });
}
