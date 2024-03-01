import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/util/main_section_enum.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/domain/usecases/checkout/add_checkout_parts.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup.dart';

class MockCheckoutPartRepository extends Mock
    implements CheckedOutPartRepository {}

class MockPartRepository extends Mock implements PartRepository {}

void main() {
  late AddCheckoutPart sut;
  late MockCheckoutPartRepository mockCheckoutPartRepository;
  late MockPartRepository mockPartRepository;
  late CheckedOutEntity checkedOutEntity;
  late PartEntity partEntity;
  late ValuesForTest valuesForTest;
  setUp(() {
    mockCheckoutPartRepository = MockCheckoutPartRepository();
    mockPartRepository = MockPartRepository();
    valuesForTest = ValuesForTest();
    sut = AddCheckoutPart(mockCheckoutPartRepository, mockPartRepository);
    partEntity = valuesForTest.parts()[0];
    checkedOutEntity = CheckedOutEntity(
      section: MaintenanceSection.aH,
      checkoutUser: '',
      aircraftTailNumber: '',
      taskName: '',
      index: 2,
      checkedOutQuantity: 10,
      quantityDiscrepancy: 0,
      dateTime: DateTime.now().subtract(const Duration(days: 4)),
      partEntityIndex: ValuesForTest().parts()[0].index,
      isVerified: false,
      verifiedDate: null,
    );

    registerFallbackValue(checkedOutEntity);
    registerFallbackValue(valuesForTest.getCartCheckoutEntities());
    registerFallbackValue(partEntity);
  });

  group('.call()', () {
    test('should return right ', () async {
      AddCheckoutPartParams params = AddCheckoutPartParams(
          cartItems: valuesForTest.getCartCheckoutEntities());
      when(() => mockCheckoutPartRepository
              .createCheckOut(any(that: isA<CheckedOutEntity>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
      when(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
      var results = await sut.call(params);
      expect(results, isA<Right<Failure, void>>());
      verify(() => mockCheckoutPartRepository
              .createCheckOut(any(that: isA<CheckedOutEntity>())))
          .called(ValuesForTest().createCheckedOutList().length);
    });
    test('should return right when list is null ', () async {
      AddCheckoutPartParams params = const AddCheckoutPartParams(cartItems: []);
      when(() => mockCheckoutPartRepository
              .createCheckOut(any(that: isA<CheckedOutEntity>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
      var results = await sut.call(params);
      expect(results, isA<Right<Failure, void>>());
      verifyNever(() => mockCheckoutPartRepository
          .createCheckOut(any(that: isA<CheckedOutEntity>())));
    });
    test('should return a Failure', () async {
      AddCheckoutPartParams params = AddCheckoutPartParams(
          cartItems: valuesForTest.getCartCheckoutEntities());
      when(() =>
          mockCheckoutPartRepository
              .createCheckOut(any(that: isA<CheckedOutEntity>()))).thenAnswer(
          (invocation) async => const Left<Failure, void>(CreateDataFailure()));
      when(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
      var results = await sut.call(params);
      Failure failure = const GetFailure();
      results.fold((fail) => failure = fail, (right) => null);
      expect(results, isA<Left<Failure, void>>());
      expect(failure, const CreateDataFailure());
      verify(() => mockCheckoutPartRepository
          .createCheckOut(any(that: isA<CheckedOutEntity>()))).called(1);
      verify(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .called(1);
    });

    test('should return a Failure when the check out entity cant be updated',
        () async {
      AddCheckoutPartParams params = AddCheckoutPartParams(
          cartItems: valuesForTest.getCartCheckoutEntities());
      when(() => mockCheckoutPartRepository
              .createCheckOut(any(that: isA<CheckedOutEntity>())))
          .thenAnswer((invocation) async => const Right<Failure, void>(null));
      when(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .thenAnswer((invocation) async =>
              const Left<Failure, void>(CreateDataFailure()));
      var results = await sut.call(params);

      expect(results, isA<Right<Failure, void>>());
      verifyNever(() => mockCheckoutPartRepository
          .createCheckOut(any(that: isA<CheckedOutEntity>())));
      verify(() => mockPartRepository.editPart(any(that: isA<PartEntity>())))
          .called(valuesForTest.createCheckedOutList().length);
    });
  });
}
