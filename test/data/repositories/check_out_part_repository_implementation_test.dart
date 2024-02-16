import 'package:hive/hive.dart';
import 'package:inventory_v1/data/models/checked-out/checked_out_model.dart';
import 'package:inventory_v1/data/repositories/checked_out_part_repository_implementation.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../setup.dart';

class MockCheckOutBox extends Mock implements Box<CheckedOutModel> {}

void main() {
  late ValuesForTest valuesForTest;
  late MockCheckOutBox mockCheckOutBox;
  late CheckedOutPartRepositoryImplementation sut;

  setUp(() {
    valuesForTest = ValuesForTest();
    mockCheckOutBox = MockCheckOutBox();
    sut = CheckedOutPartRepositoryImplementation(mockCheckOutBox);
  });

  group('.getCheckedOutItems()', () {
    void mockSetup() {
      when(() => mockCheckOutBox.length).thenAnswer(
        (_) => valuesForTest.createCheckedOutList().length,
      );
      when(() => mockCheckOutBox.getAt(any(that: isA<int>())))
          .thenAnswer((invocation) {
        var index = invocation.positionalArguments[0] as int;
        print('index is $index');
        return sut
            .toCheckoutPartModel(valuesForTest.createCheckedOutList()[index]);
      });
    }

    test(
        'should return the list where the last element is the first in the list',
        () async {
      mockSetup();
      List<CheckedOutEntity> returnedList = [];
      int fetchAmount = 27;
      int startIndex = returnedList.length;
      int endIndex = valuesForTest.createCheckedOutList().length -
          startIndex -
          fetchAmount;
      var results = await sut.getCheckedOutItems(startIndex, endIndex);

      results.fold(
        (l) => null,
        (list) => returnedList.addAll(list),
      );
      startIndex = returnedList.length;

      endIndex = valuesForTest.createCheckedOutList().length -
          startIndex -
          fetchAmount;
      results = await sut.getCheckedOutItems(startIndex, endIndex);
      results.fold(
        (l) => null,
        (list) => returnedList.addAll(list),
      );

      expect(returnedList.first.index,
          valuesForTest.createCheckedOutList().last.index);

      expect(returnedList.length, valuesForTest.createCheckedOutList().length);
      expect(returnedList.last.index,
          valuesForTest.createCheckedOutList().first.index);

      expect(returnedList.first.index,
          valuesForTest.createCheckedOutList().last.index);
    });
  });
}
