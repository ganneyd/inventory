import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/exceptions.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/data/datasources/local_database.dart';
import 'package:mocktail/mocktail.dart';

import 'setup.dart';

part 'datasource_methods_test/create_data_method_test.dart';

//create class to mock the hive box so that we can then pass the mocked Box class
//to the local datasource class
class MockHiveBox extends Mock implements Box<Map<String, dynamic>> {}

void main() {
  //specify the various variables to be used across the tests
  late LocalDataSource sut;
  late MockHiveBox mockBox;
  late Map<String, dynamic> typicalPart;

  //function runs before each test, so initialize variables or other
  //dependencies here.
  setUp(() async {
    //default key value pair for a part as represent in the Part model and entity
    typicalPart = ValuesForTest.partsList[0];
    //initialize the mock box
    mockBox = MockHiveBox();
    //The actual system under test, that is why the hive box is mocked and not
    //the local datasource, as the methods defined in the local datasource is what
    // is being tested.
    sut = LocalDataSourceImplementation(mockBox);
  });

  //createData() test, test that the method is working as intended
  group('createData() tests', () {
    void addDataToMock() {
      //when the method add() is called it returns a mock Future<int> in this case 0
      when(() => mockBox.add(any())).thenAnswer((_) async => 0);
    }

    //check to see if box.add() method is called
    test('create data uses the Hive Box', () async {
      addDataToMock();
      await sut.createData(newData: typicalPart);
      //verify that the method was called only once
      verify(() => mockBox.add(any())).called(1);
    });

    //check to see if the 'index' key is removed before being placed in the db
    //reason why is that in the domain layer we want to access the data's index
    //without having to call the
    test('check that index is removed before placing in db', () async {
      typicalPart['index'] = 0;
      addDataToMock();
      //check that it exist before the operation
      expect(typicalPart.containsKey('index'), isTrue);
      await sut.createData(newData: typicalPart);
      //check that it is removed after the operation
      expect(typicalPart.containsKey('index'), isFalse);
    });

    //check to see if the method properly handles exceptions
    test('check that an exception is returned', () async {
      when(() => mockBox.add(any())).thenThrow(Exception());
      expect(sut.createData(newData: {}), throwsA(isA<CreateDataException>()));
    });
  });

  group('readData() tests', () {
    void getAtMock(int index) {
      when(() => mockBox.length).thenReturn(ValuesForTest.partsList.length);
      if (index >= 0 && index < ValuesForTest.partsList.length) {
        when(() => mockBox.getAt(index))
            .thenReturn(ValuesForTest.partsList[index]);
      }
    }

    test(
        'check if the read data method returns the appropriate item in the list with its index',
        () async {
      const int index = 0;
      getAtMock(index);
      final Map<String, dynamic> expectedResponse =
          Map<String, dynamic>.from(ValuesForTest.partsList[index]);
      expectedResponse['index'] = index;
      expect(await sut.readData(index: index), equals(expectedResponse));
    });

    test('check if the read data method throws an exception', () async {
      final int index = 12; // Index out of bounds
      getAtMock(index); // Configure the mock behavior

      // Expecting the readData method to throw a ReadDataException
      expect(
          () => sut.readData(index: index), throwsA(isA<ReadDataException>()));

      // Verify that getAt method is never called with the out-of-bounds index
      verifyNever(() => mockBox.getAt(index));

      // Verify that the length method is called once
      verify(() => mockBox.length).called(1);
    });
  });
}
