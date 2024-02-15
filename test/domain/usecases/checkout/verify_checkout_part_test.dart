import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup.dart';

class MockCheckoutPartRepository extends Mock
    implements CheckedOutPartRepository {}

class MockEditPartUsecase extends Mock implements EditPartUsecase {}

void main() {
  late VerifyCheckoutPart sut;
  late MockEditPartUsecase mockEditPartUsecase;
  late MockCheckoutPartRepository mockCheckoutPartRepository;
  late List<CheckedOutEntity> unverifiedCheckoutPart;
  late ValuesForTest valuesForTest;
  setUp(() {
    valuesForTest = ValuesForTest();
    mockCheckoutPartRepository = MockCheckoutPartRepository();
    mockEditPartUsecase = MockEditPartUsecase();
    sut = VerifyCheckoutPart(mockCheckoutPartRepository, mockEditPartUsecase);

    unverifiedCheckoutPart = valuesForTest.createCheckedOutList();
    EditPartParams editPartParams =
        EditPartParams(partEntity: unverifiedCheckoutPart[0].part);
    registerFallbackValue(unverifiedCheckoutPart[0]);
    registerFallbackValue(editPartParams);
  });

  group('.call()', () {
    test('should return a void  when editPartUsecase returns void', () async {
      VerifyCheckoutPartParams params = VerifyCheckoutPartParams(
          checkedOutEntityList: unverifiedCheckoutPart);

      //setup
      when(() => mockEditPartUsecase.call(any(that: isA<EditPartParams>())))
          .thenAnswer((invocation) async =>
              Right<Failure, PartEntity?>(valuesForTest.parts()[0]));
      when(
        () => mockCheckoutPartRepository
            .editCheckedOutItem(any(that: isA<CheckedOutEntity>())),
      ).thenAnswer((invocation) async => const Right<Failure, void>(null));

      var results = await sut.call(params);

      expect(results, isA<Right<Failure, void>>());

      verify(() => mockCheckoutPartRepository
              .editCheckedOutItem(any(that: isA<CheckedOutEntity>())))
          .called(unverifiedCheckoutPart.length);
      verify(() => mockEditPartUsecase.call(any(that: isA<EditPartParams>())))
          .called(unverifiedCheckoutPart.length);
    });

    test('should return null when successful', () async {
      VerifyCheckoutPartParams params = VerifyCheckoutPartParams(
          checkedOutEntityList: unverifiedCheckoutPart);

      //setup
      when(() => mockEditPartUsecase.call(any(that: isA<EditPartParams>())))
          .thenAnswer(
              (invocation) async => const Right<Failure, PartEntity?>(null));
      when(
        () => mockCheckoutPartRepository
            .editCheckedOutItem(any(that: isA<CheckedOutEntity>())),
      ).thenAnswer((invocation) async => const Right<Failure, void>(null));

      var results = await sut.call(params);

      expect(results, isA<Right<Failure, void>>());

      verify(() => mockCheckoutPartRepository
              .editCheckedOutItem(any(that: isA<CheckedOutEntity>())))
          .called(unverifiedCheckoutPart.length);
      verify(() => mockEditPartUsecase.call(any(that: isA<EditPartParams>())))
          .called(unverifiedCheckoutPart.length);
    });

    test(
        'should return UpdateDataFailure() when an error occurs in the checkoutPartRepository',
        () async {
      VerifyCheckoutPartParams params = VerifyCheckoutPartParams(
          checkedOutEntityList: unverifiedCheckoutPart);

      //setup
      when(() => mockEditPartUsecase.call(any(that: isA<EditPartParams>())))
          .thenAnswer(
              (invocation) async => const Right<Failure, PartEntity?>(null));
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
      verify(() => mockEditPartUsecase.call(any(that: isA<EditPartParams>())))
          .called(1);
    });

    test(
        'should return UpdateDataFailure() when an error occurs in the editPartUsecase',
        () async {
      VerifyCheckoutPartParams params = VerifyCheckoutPartParams(
          checkedOutEntityList: unverifiedCheckoutPart);

      //setup
      when(() => mockEditPartUsecase.call(any(that: isA<EditPartParams>())))
          .thenAnswer((invocation) async =>
              const Left<Failure, PartEntity?>(UpdateDataFailure()));
      when(
        () => mockCheckoutPartRepository
            .editCheckedOutItem(any(that: isA<CheckedOutEntity>())),
      ).thenAnswer((invocation) async => const Right<Failure, void>(null));

      var results = await sut.call(params);
      Failure failure = const GetFailure();
      results.fold((fail) => failure = fail, (right) => null);
      expect(results, isA<Left<Failure, void>>());
      expect(failure, const UpdateDataFailure());

      verifyNever(() => mockCheckoutPartRepository
          .editCheckedOutItem(any(that: isA<CheckedOutEntity>())));
      verify(() => mockEditPartUsecase.call(any(that: isA<EditPartParams>())))
          .called(1);
    });
  });
}
