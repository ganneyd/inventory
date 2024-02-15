import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/usecases/checkout/add_checkout_parts.dart';
import 'package:inventory_v1/domain/usecases/edit_part.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup.dart';

class MockCheckoutPartRepository extends Mock
    implements CheckedOutPartRepository {}

class MockEditPartUsecase extends Mock implements EditPartUsecase {}

void main() {
  late AddCheckoutPart sut;
  late MockCheckoutPartRepository mockCheckoutPartRepository;
  late MockEditPartUsecase mockEditPartUsecase;
  late CheckedOutEntity checkedOutEntity;

  setUp(() {
    mockCheckoutPartRepository = MockCheckoutPartRepository();
    mockEditPartUsecase = MockEditPartUsecase();
    sut = AddCheckoutPart(mockCheckoutPartRepository, mockEditPartUsecase);
    checkedOutEntity = CheckedOutEntity(
      index: 2,
      checkedOutQuantity: 10,
      quantityDiscrepancy: 0,
      dateTime: DateTime.now().subtract(const Duration(days: 4)),
      part: ValuesForTest().parts()[0],
      isVerified: false,
      verifiedDate: null,
    );

    registerFallbackValue(checkedOutEntity);
  });

  group('.call()', () {
    test('should return right ', () async {
      AddCheckoutPartParams params = AddCheckoutPartParams(
          checkoutParts: ValuesForTest().createCheckedOutList());
      when(() => mockCheckoutPartRepository
              .createCheckOut(any(that: isA<CheckedOutEntity>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
      var results = await sut.call(params);
      expect(results, isA<Right<Failure, void>>());
      verify(() => mockCheckoutPartRepository
          .createCheckOut(any(that: isA<CheckedOutEntity>()))).called(10);
    });
    test('should return right when list is null ', () async {
      AddCheckoutPartParams params =
          const AddCheckoutPartParams(checkoutParts: []);
      when(() => mockCheckoutPartRepository
              .createCheckOut(any(that: isA<CheckedOutEntity>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
      var results = await sut.call(params);
      expect(results, isA<Right<Failure, void>>());
      verifyNever(() => mockCheckoutPartRepository
          .createCheckOut(any(that: isA<CheckedOutEntity>())));
    });
    test('should return a Failure', () async {
      AddCheckoutPartParams params =
          AddCheckoutPartParams(checkoutParts: [checkedOutEntity]);
      when(() => mockCheckoutPartRepository
              .createCheckOut(any(that: isA<CheckedOutEntity>())))
          .thenAnswer(
              (invocation) async => Left<Failure, void>(CreateDataFailure()));

      var results = await sut.call(params);
      Failure failure = const GetFailure();
      results.fold((fail) => failure = fail, (right) => null);
      expect(results, isA<Left<Failure, void>>());
      expect(failure, CreateDataFailure());
      verify(() => mockCheckoutPartRepository
          .createCheckOut(any(that: isA<CheckedOutEntity>()))).called(1);
    });
  });
}
