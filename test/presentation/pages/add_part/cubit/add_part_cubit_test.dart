import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_cubit.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_state.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../setup.dart';

class MockAddPartUseCase extends Mock implements AddPartUsecase {}

class MockGetPartsBYNSNUsecase extends Mock implements GetPartByNsnUseCase {}

class MockEditPartsUsecase extends Mock implements EditPartUsecase {}

void main() {
  late AddPartCubit sut;
  late ValuesForTest valuesForTest;
  late PartModel typicalPart;
  late MockAddPartUseCase mockAddPartUseCase;
  late MockEditPartsUsecase mockEditPartsUsecase;
  late MockGetPartsBYNSNUsecase mockGetPartsBYNSNUsecase;

  setUp(() {
    valuesForTest = ValuesForTest();
    typicalPart = PartEntityToModelAdapter.fromEntity(valuesForTest.parts()[0]);

    mockAddPartUseCase = MockAddPartUseCase();
    mockEditPartsUsecase = MockEditPartsUsecase();
    mockGetPartsBYNSNUsecase = MockGetPartsBYNSNUsecase();
    sut = AddPartCubit(
      getPartByNsnUseCase: mockGetPartsBYNSNUsecase,
      editPartUsecase: mockEditPartsUsecase,
      addPartUsecase: mockAddPartUseCase,
    );
    registerFallbackValue(AddPartParams(partEntity: typicalPart));
  });

  group('AddPartCubit()', () {
    test('initial State is correct', () {
      // Verify the initial state

      expect(
          sut.state.addPartStateStatus, AddPartStateStatus.loadedSuccessfully);

      sut.close();
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
