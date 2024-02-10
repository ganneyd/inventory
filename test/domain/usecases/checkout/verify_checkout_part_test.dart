import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/usecases/checkout/verify_checkout_part.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup.dart';

class MockCheckoutPartRepository extends Mock
    implements CheckedOutPartRepository {}

void main() {
  late VerifyCheckoutPart sut;
  late MockCheckoutPartRepository mockCheckoutPartRepository;
  late CheckedOutEntity unverifiedCheckoutPart;

  setUp(() {
    mockCheckoutPartRepository = MockCheckoutPartRepository();
    sut = VerifyCheckoutPart(mockCheckoutPartRepository);

    unverifiedCheckoutPart = CheckedOutEntity(
      index: 2,
      checkedOutQuantity: 10,
      dateTime: DateTime.now().subtract(const Duration(days: 4)),
      part: ValuesForTest().parts()[0],
      isVerified: false,
      verifiedDate: null,
    );
    registerFallbackValue(unverifiedCheckoutPart);
  });

  group('.call()', () {
    test('should return void when successful', () async {
      VerifyCheckoutPartParams params =
          VerifyCheckoutPartParams(checkedOutEntity: unverifiedCheckoutPart);

      //setup
      when(
        () => mockCheckoutPartRepository
            .editCheckedOutItem(any(that: isA<CheckedOutEntity>())),
      ).thenAnswer((invocation) async => const Right<Failure, void>(null));

      var results = await sut.call(params);

      expect(results, isA<Right<Failure, void>>());

      verify(() => mockCheckoutPartRepository
          .editCheckedOutItem(any(that: isA<CheckedOutEntity>()))).called(1);
    });

    test('should return UpdateDataFailure() when an error occurs', () async {
      VerifyCheckoutPartParams params =
          VerifyCheckoutPartParams(checkedOutEntity: unverifiedCheckoutPart);

      //setup
      when(
        () => mockCheckoutPartRepository
            .editCheckedOutItem(any(that: isA<CheckedOutEntity>())),
      ).thenAnswer(
          (invocation) async => const Left<Failure, void>(UpdateDataFailure()));

      var results = await sut.call(params);
      Failure failure = const GetFailure();
      results.fold((fail) => failure = fail, (right) => null);
      expect(results, isA<Left<Failure, void>>());
      expect(failure, const UpdateDataFailure());

      verify(() => mockCheckoutPartRepository
          .editCheckedOutItem(any(that: isA<CheckedOutEntity>()))).called(1);
    });
  });
}
