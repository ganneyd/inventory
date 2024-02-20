import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup.dart';

class MockCheckoutPartRepository extends Mock
    implements CheckedOutPartRepository {}

class MockPartRepository extends Mock implements PartRepository {}

void main() {
  late VerifyCheckoutPart sut;
  late MockPartRepository mockPartRepository;
  late MockCheckoutPartRepository mockCheckoutPartRepository;
  late List<CheckedOutEntity> unverifiedCheckoutPart;
  late ValuesForTest valuesForTest;
  setUp(() {
    valuesForTest = ValuesForTest();
    mockCheckoutPartRepository = MockCheckoutPartRepository();
    mockPartRepository = MockPartRepository();
    sut = VerifyCheckoutPart(mockCheckoutPartRepository, mockPartRepository);

    unverifiedCheckoutPart = valuesForTest.createCheckedOutList();

    registerFallbackValue(unverifiedCheckoutPart[0]);
    registerFallbackValue(valuesForTest.parts()[0]);
  });

  group('.call()', () {
    void mockSetup() {
      when(() => mockCheckoutPartRepository
              .editCheckedOutItem(any(that: isA<CheckedOutEntity>())))
          .thenAnswer((_) async => const Right<Failure, void>(null));
      when(() => mockPartRepository.getSpecificPart(any(that: isA<int>())))
          .thenAnswer((_) async =>
              Right<Failure, PartEntity>(valuesForTest.parts()[0]));

      when(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .thenAnswer((_) async => const Right<Failure, void>(null));
    }

    test('should return a Right', () async {
      mockSetup();
      VerifyCheckoutPartParams params = VerifyCheckoutPartParams(
          checkedOutEntityList: unverifiedCheckoutPart);

      //setup

      var results = await sut.call(params);

      expect(results, isA<Right<Failure, void>>());

      verify(() => mockCheckoutPartRepository
              .editCheckedOutItem(any(that: isA<CheckedOutEntity>())))
          .called(unverifiedCheckoutPart.length);
      verify(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .called(unverifiedCheckoutPart.length);
      verify(() => mockPartRepository.getSpecificPart(any(that: isA<int>())))
          .called(unverifiedCheckoutPart.length);
    });

    test('should return Right when list is null', () async {
      mockSetup();
      VerifyCheckoutPartParams params =
          const VerifyCheckoutPartParams(checkedOutEntityList: []);

      //setup

      var results = await sut.call(params);

      expect(results, isA<Right<Failure, void>>());

      verifyNever(() => mockCheckoutPartRepository
          .editCheckedOutItem(any(that: isA<CheckedOutEntity>())));
      verifyNever(
          () => mockPartRepository.editPart(any(that: isA<PartEntity>())));
      verifyNever(
          () => mockPartRepository.getSpecificPart(any(that: isA<int>())));
    });

    test(
        'should return Right and rollback the part entity to the original value',
        () async {
      mockSetup();
      VerifyCheckoutPartParams params = VerifyCheckoutPartParams(
          checkedOutEntityList: [unverifiedCheckoutPart[0]]);

      //setup

      when(
        () => mockCheckoutPartRepository
            .editCheckedOutItem(any(that: isA<CheckedOutEntity>())),
      ).thenAnswer(
          (invocation) async => const Left<Failure, void>(UpdateDataFailure()));

      var results = await sut.call(params);

      verify(() => mockCheckoutPartRepository
          .editCheckedOutItem(any(that: isA<CheckedOutEntity>()))).called(1);
      var captured = verify(() =>
              mockPartRepository.editPart(captureAny(that: isA<PartEntity>())))
          .captured;
      verify(() => mockPartRepository.getSpecificPart(any(that: isA<int>())))
          .called(1);
      var part = captured.first as PartEntity;
      expect(part.quantity, valuesForTest.parts()[0].quantity);
      expect(results, const Right<Failure, void>(null));
    });

    test(
        'should not call checkoutPartReo.editCheckoutItem() when an error occurs when editing the part',
        () async {
      mockSetup();
      when(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .thenAnswer((_) async => const Left<Failure, void>(GetFailure()));
      VerifyCheckoutPartParams params =
          VerifyCheckoutPartParams(checkedOutEntityList: [
        unverifiedCheckoutPart[0],
      ]);

      //setup

      var results = await sut.call(params);
      expect(results, isA<Right<Failure, void>>());

      verifyNever(() => mockCheckoutPartRepository
          .editCheckedOutItem(any(that: isA<CheckedOutEntity>())));
      verify(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .called(1);
      verify(() => mockPartRepository.getSpecificPart(any(that: isA<int>())))
          .called(1);
    });

    test(
        'should not call partRepo.editPart or checkOutPartRepo.editCheckOutItem()',
        () async {
      mockSetup();
      when(() => mockPartRepository.getSpecificPart(any(that: isA<int>())))
          .thenAnswer(
              (_) async => const Left<Failure, PartEntity>(GetFailure()));
      VerifyCheckoutPartParams params =
          VerifyCheckoutPartParams(checkedOutEntityList: [
        unverifiedCheckoutPart[0],
      ]);
      var results = await sut.call(params);
      expect(results, isA<Right<Failure, void>>());

      verifyNever(() => mockCheckoutPartRepository
          .editCheckedOutItem(any(that: isA<CheckedOutEntity>())));
      verifyNever(
          () => mockPartRepository.editPart(any(that: isA<PartEntity>())));
      verify(() => mockPartRepository.getSpecificPart(any(that: isA<int>())))
          .called(1);
    });
  });
}
