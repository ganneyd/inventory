import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_cubit.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../setup.dart';

class MockAddPartUseCase extends Mock implements AddPartUsecase {}

class MockFormState extends Mock implements FormState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return 'MockFormState';
  }
}

class MockGlobalKey extends Mock implements GlobalKey<MockFormState> {}

class MockTextEditingController extends Mock implements TextEditingController {}

void main() {
  late AddPartCubit sut;
  late ValuesForTest valuesForTest;
  late Part typicalPart;
  late MockAddPartUseCase mockAddPartUseCase;
  late MockFormState mockFormState;
  late MockGlobalKey mockGlobalKey;
  late MockTextEditingController nsnController;
  late MockTextEditingController nomenclatureController;
  late MockTextEditingController partNumberController;
  late MockTextEditingController requisitionPointController;
  late MockTextEditingController requisitionQuantityController;
  late MockTextEditingController quantityController;
  late MockTextEditingController serialNumberController;
  late MockTextEditingController mockLocationController;
  setUp(() {
    valuesForTest = ValuesForTest();
    typicalPart = PartAdapter.fromEntity(valuesForTest.parts()[0]);
    mockFormState = MockFormState();
    mockGlobalKey = MockGlobalKey();
    nsnController = MockTextEditingController();
    nomenclatureController = MockTextEditingController();
    partNumberController = MockTextEditingController();
    requisitionPointController = MockTextEditingController();
    requisitionQuantityController = MockTextEditingController();
    quantityController = MockTextEditingController();
    serialNumberController = MockTextEditingController();
    mockLocationController = MockTextEditingController();
    mockAddPartUseCase = MockAddPartUseCase();
    sut = AddPartCubit(
      addPartUsecase: mockAddPartUseCase,
      formKey: mockGlobalKey,
      nsnController: nsnController,
      nomenclatureController: nomenclatureController,
      partNumberController: partNumberController,
      requisitionPointController: requisitionPointController,
      requisitionQuantityController: requisitionQuantityController,
      quantityController: quantityController,
      serialNumberController: serialNumberController,
      locationController: mockLocationController,
    );
  });

  group('AddPartCubit()', () {
    test('initial State is correct', () {
      // Verify the initial state
      expect(sut.state.formKey, isA<GlobalKey<FormState>>());
      expect(
          sut.state.addPartStateStatus, AddPartStateStatus.loadedSuccessfully);
      expect(sut.state.locationController, isA<TextEditingController>());
      expect(sut.state.nsnController, isA<TextEditingController>());
      expect(sut.state.nomenclatureController, isA<TextEditingController>());
      expect(sut.state.partNumberController, isA<TextEditingController>());
      expect(
          sut.state.requisitionPointController, isA<TextEditingController>());
      expect(sut.state.requisitionQuantityController,
          isA<TextEditingController>());
      expect(sut.state.quantityController, isA<TextEditingController>());
      expect(sut.state.serialNumberController, isA<TextEditingController>());

      sut.close();
    });
  });

  group('.applyPart', () {
    //
    void mockSetup() {
      when(() => mockGlobalKey.currentState)
          .thenAnswer((invocation) => mockFormState);
      when(() => mockFormState.validate()).thenAnswer((invocation) => true);
//nsn
      when(() => nsnController.text)
          .thenAnswer((invocation) => typicalPart.nsn);
//name
      when(() => nomenclatureController.text)
          .thenAnswer((invocation) => typicalPart.name);
//serial number
      when(() => serialNumberController.text)
          .thenAnswer((invocation) => typicalPart.serialNumber);
//requisition point
      when(() => requisitionPointController.text)
          .thenAnswer((invocation) => typicalPart.requisitionPoint.toString());
//requisition quantity
      when(() => requisitionQuantityController.text).thenAnswer(
          (invocation) => typicalPart.requisitionQuantity.toString());
//quantity
      when(() => quantityController.text)
          .thenAnswer((invocation) => typicalPart.quantity.toString());
      //part number
      when(() => partNumberController.text)
          .thenAnswer((invocation) => typicalPart.partNumber);
      //location
      when(() => mockLocationController.text)
          .thenAnswer((invocation) => typicalPart.location);
    }

    test('Valid Form Submission', () {
      mockSetup();
      //mock the drop down menu onChange method
      sut.dropDownMenuHandler(typicalPart.unitOfIssue);

      sut.applyPart();

      //verifications
      //verify that the form was only validate once when the .applyPart() was called
      verify(
        () => mockFormState.validate(),
      ).called(1);

      //verify that the .currentState was only called once when the .applyPart() was called

      verify(
        () => mockGlobalKey.currentState,
      ).called(2);

      //verify that the controllers were only called once when the .applyPart() was called
      verify(() => nsnController.text).called(1);
      verify(() => nomenclatureController.text).called(1);
      //method gets called twice, once to check if text is empty and if its not called again to get the value
      verify(() => serialNumberController.text).called(2);
      verify(() => requisitionPointController.text).called(1);
      verify(() => requisitionQuantityController.text).called(1);
      verify(() => quantityController.text).called(1);
      verify(() => partNumberController.text).called(1);
      verify(() => mockLocationController.text).called(1);

      //expectations
      //status
      //the form validation flag should be true
      expect(sut.state.isFormValid, true);
      //the state status should be AddPartStateStatus.loadedSuccessfully
      expect(
          sut.state.addPartStateStatus, AddPartStateStatus.loadedSuccessfully);

      //the part emitted in the state should be the same typical part
      expect(sut.state.part?.serialNumber, typicalPart.serialNumber);
      expect(sut.state.part?.nsn, typicalPart.nsn);
      expect(sut.state.part?.name, typicalPart.name);
      expect(sut.state.part?.location, typicalPart.location);
      expect(sut.state.part?.quantity, typicalPart.quantity);
      expect(sut.state.part?.requisitionPoint, typicalPart.requisitionPoint);
      expect(
          sut.state.part?.requisitionQuantity, typicalPart.requisitionQuantity);
      expect(sut.state.part?.unitOfIssue, typicalPart.unitOfIssue);
      expect(sut.state.part?.partNumber, typicalPart.partNumber);
    });

    test('Valid Form Submission with empty Serial Number', () {
      mockSetup();
      when(() => serialNumberController.text).thenAnswer((invocation) => '');
      //mock the drop down menu onChange method
      sut.dropDownMenuHandler(typicalPart.unitOfIssue);

      sut.applyPart();

      //verifications
      //verify that the form was only validate once when the .applyPart() was called
      verify(
        () => mockFormState.validate(),
      ).called(1);

      //verify that the .currentState was called twice when the .applyPart() was called

      verify(
        () => mockGlobalKey.currentState,
      ).called(2);

      //verify that the controllers were only called once when the .applyPart() was called
      verify(() => nsnController.text).called(1);
      verify(() => nomenclatureController.text).called(1);
      //method gets called twice, once to check if text is empty and if its empty it shouldn't be called again
      verify(() => serialNumberController.text).called(1);
      verify(() => requisitionPointController.text).called(1);
      verify(() => requisitionQuantityController.text).called(1);
      verify(() => quantityController.text).called(1);
      verify(() => partNumberController.text).called(1);
      verify(() => mockLocationController.text).called(1);

      //expectations
      //status
      //the form validation flag should be true
      expect(sut.state.isFormValid, true);
      //the state status should be AddPartStateStatus.loadedSuccessfully
      expect(
          sut.state.addPartStateStatus, AddPartStateStatus.loadedSuccessfully);
      //the part emitted in the state should be the same typical part

      expect(sut.state.part?.serialNumber, 'N/A');
      expect(sut.state.part?.nsn, typicalPart.nsn);
      expect(sut.state.part?.name, typicalPart.name);
      expect(sut.state.part?.location, typicalPart.location);
      expect(sut.state.part?.quantity, typicalPart.quantity);
      expect(sut.state.part?.requisitionPoint, typicalPart.requisitionPoint);
      expect(
          sut.state.part?.requisitionQuantity, typicalPart.requisitionQuantity);
      expect(sut.state.part?.unitOfIssue, typicalPart.unitOfIssue);
      expect(sut.state.part?.partNumber, typicalPart.partNumber);
    });

    test('Invalid Form Submission', () {
      mockSetup();
      //return false when the validate method is called
      when(() => mockFormState.validate()).thenAnswer((invocation) => false);

      //mock the drop down menu onChange method
      sut.dropDownMenuHandler(typicalPart.unitOfIssue);

      sut.applyPart();

      //verifications
      //verify that the form was only validate once when the .applyPart() was called
      verify(() => mockFormState.validate()).called(1);

      //verify that the .currentState was  called twice when the .applyPart() was called

      verify(() => mockGlobalKey.currentState).called(2);

      verifyNever(() => nsnController.text);
      verifyNever(() => nomenclatureController.text);
      verifyNever(() => serialNumberController.text);
      verifyNever(() => requisitionPointController.text);
      verifyNever(() => requisitionQuantityController.text);
      verifyNever(() => quantityController.text);
      verifyNever(() => partNumberController.text);
      verifyNever(() => mockLocationController.text);

      //expectations
      expect(sut.state.isFormValid, false);
      expect(sut.state.addPartStateStatus,
          AddPartStateStatus.loadedUnsuccessfully);
      expect(sut.state.part, isNull);
    });

    test('Null Form State', () {
      mockSetup();
      //return false when the validate method is called
      when(() => mockGlobalKey.currentState).thenAnswer((invocation) => null);

      //mock the drop down menu onChange method
      sut.dropDownMenuHandler(typicalPart.unitOfIssue);

      sut.applyPart();

      //verifications
      //verify that the form was only validate once when the .applyPart() was called
      verifyNever(() => mockFormState.validate());

      //verify that the .currentState was only called once when the .applyPart() was called

      verify(() => mockGlobalKey.currentState).called(1);

      verifyNever(() => nsnController.text);
      verifyNever(() => nomenclatureController.text);
      verifyNever(() => serialNumberController.text);
      verifyNever(() => requisitionPointController.text);
      verifyNever(() => requisitionQuantityController.text);
      verifyNever(() => quantityController.text);
      verifyNever(() => partNumberController.text);
      verifyNever(() => mockLocationController.text);

      //expectations
      expect(sut.state.isFormValid, false);
      expect(sut.state.addPartStateStatus,
          AddPartStateStatus.loadedUnsuccessfully);
      expect(sut.state.part, isNull);
    });
  });

  group('.savePart()', () {
    ///
    void mockSetup() {
      when(() => mockGlobalKey.currentState)
          .thenAnswer((invocation) => mockFormState);
      when(() => mockFormState.validate()).thenAnswer((invocation) => true);
//nsn
      when(() => nsnController.text)
          .thenAnswer((invocation) => typicalPart.nsn);
//name
      when(() => nomenclatureController.text)
          .thenAnswer((invocation) => typicalPart.name);
//serial number
      when(() => serialNumberController.text)
          .thenAnswer((invocation) => typicalPart.serialNumber);
//requisition point
      when(() => requisitionPointController.text)
          .thenAnswer((invocation) => typicalPart.requisitionPoint.toString());
//requisition quantity
      when(() => requisitionQuantityController.text).thenAnswer(
          (invocation) => typicalPart.requisitionQuantity.toString());
//quantity
      when(() => quantityController.text)
          .thenAnswer((invocation) => typicalPart.quantity.toString());
      //part number
      when(() => partNumberController.text)
          .thenAnswer((invocation) => typicalPart.partNumber);
      //location
      when(() => mockLocationController.text)
          .thenAnswer((invocation) => typicalPart.location);

      //for clearing the controllers
      when(() => nsnController.clear()).thenAnswer((_) {});
      when(() => nomenclatureController.clear()).thenAnswer((_) {});
      when(() => mockLocationController.clear()).thenAnswer((_) {});
      when(() => quantityController.clear()).thenAnswer((_) {});
      when(() => partNumberController.clear()).thenAnswer((_) {});
      when(() => requisitionPointController.clear()).thenAnswer((_) {});
      when(() => requisitionQuantityController.clear()).thenAnswer((_) {});
      when(() => serialNumberController.clear()).thenAnswer((_) {});
    }

    void mockUsecaseSetup(AddPartParams params) {
      mockSetup();

      when(() => mockAddPartUseCase.call(params))
          .thenAnswer((_) async => const Right<Failure, void>(null));
    }

    test('Usecase completes with no errors', () async {
      AddPartParams params = AddPartParams(partEntity: typicalPart);
      mockUsecaseSetup(params);
      sut.dropDownMenuHandler(typicalPart.unitOfIssue);
      sut.savePart();

      verify(() => mockAddPartUseCase.call(params)).called(1);
      //verify that the controllers were only called once when the .applyPart() was called
      verify(() => nsnController.text).called(1);
      verify(() => nomenclatureController.text).called(1);
      //method gets called twice, once to check if text is empty and if its not called again to get the value
      verify(() => serialNumberController.text).called(2);
      verify(() => requisitionPointController.text).called(1);
      verify(() => requisitionQuantityController.text).called(1);
      verify(() => quantityController.text).called(1);
      verify(() => partNumberController.text).called(1);
      verify(() => mockLocationController.text).called(1);

      //since the .savePart() contains async calls we expect that the state is emitted after the
      //async function from the usecase completes
      await expectLater(
          sut.stream.map((state) => state.addPartStateStatus),
          emitsInOrder([
            AddPartStateStatus.loadedSuccessfully,
            AddPartStateStatus.createdDataSuccessfully
            // More states if expected
          ]));

      //verify that the controllers were cleared
      await expectLater(verify(() => nsnController.clear()).callCount, 1);
      await expectLater(
          verify(() => nomenclatureController.clear()).callCount, 1);
      await expectLater(
          verify(() => serialNumberController.clear()).callCount, 1);
      await expectLater(
          verify(() => requisitionPointController.clear()).callCount, 1);
      await expectLater(
          verify(() => requisitionQuantityController.clear()).callCount, 1);
      await expectLater(verify(() => quantityController.clear()).callCount, 1);
      await expectLater(
          verify(() => partNumberController.clear()).callCount, 1);
      await expectLater(
          verify(() => mockLocationController.clear()).callCount, 1);
    });

    test('Usecase completes with  errors', () async {
      AddPartParams params = AddPartParams(partEntity: typicalPart);
      mockUsecaseSetup(params);
      sut.dropDownMenuHandler(typicalPart.unitOfIssue);
      when(() => mockAddPartUseCase.call(params)).thenAnswer(
          (invocation) async => Left<Failure, void>(CreateDataFailure()));
      sut.savePart();

      verify(() => mockAddPartUseCase.call(params)).called(1);
      //verify that the controllers were only called once when the .applyPart() was called
      verify(() => nsnController.text).called(1);
      verify(() => nomenclatureController.text).called(1);
      //method gets called twice, once to check if text is empty and if its not called again to get the value
      verify(() => serialNumberController.text).called(2);
      verify(() => requisitionPointController.text).called(1);
      verify(() => requisitionQuantityController.text).called(1);
      verify(() => quantityController.text).called(1);
      verify(() => partNumberController.text).called(1);
      verify(() => mockLocationController.text).called(1);

      //since the .savePart() contains async calls we expect that the state is emitted after the
      //async function from the usecase completes
      await expectLater(
        sut.stream.map((state) => state.addPartStateStatus),
        emitsInOrder([
          AddPartStateStatus.createdDataUnsuccessfully
          // More states if expected
        ]),
      );

      //verify that the controllers were not cleared
      await expectLater(verifyNever(() => nsnController.clear()).callCount, 0);
      await expectLater(
          verifyNever(() => nomenclatureController.clear()).callCount, 0);
      await expectLater(
          verifyNever(() => serialNumberController.clear()).callCount, 0);
      await expectLater(
          verifyNever(() => requisitionPointController.clear()).callCount, 0);
      await expectLater(
          verifyNever(() => requisitionQuantityController.clear()).callCount,
          0);
      await expectLater(
          verifyNever(() => quantityController.clear()).callCount, 0);
      await expectLater(
          verifyNever(() => partNumberController.clear()).callCount, 0);
      await expectLater(
          verifyNever(() => mockLocationController.clear()).callCount, 0);
    });

    test('Form was not validated properly and .savePart() called', () {
      AddPartParams params = AddPartParams(partEntity: typicalPart);
      mockUsecaseSetup(params);
      sut.dropDownMenuHandler(typicalPart.unitOfIssue);

      //make it so that the form validation fails
      when(() => mockFormState.validate()).thenAnswer((invocation) => false);

      //evoke the function
      sut.savePart();
      //expectations
      //isFormValid should be false
      expect(sut.state.isFormValid, false);
      //usecase shouldn't be called
      verifyNever(() => mockAddPartUseCase.call(params));
      //state should be unsuccessful
      expect(sut.state.addPartStateStatus,
          AddPartStateStatus.loadedUnsuccessfully);
    });
  });

  group('.dropDownMenuHandler', () {
    test('Should emit the provided enum value to the state', () {
      var expectedEnum = UnitOfIssue.FT;
      sut.dropDownMenuHandler(expectedEnum);

      //the enum provided to the function should be the same as in the state
      expect(sut.state.unitOfIssue, expectedEnum);
    });
  });
}
