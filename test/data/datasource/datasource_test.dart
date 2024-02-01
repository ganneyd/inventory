
<<<<<<< HEAD
=======
import '../../setup.dart';

// Class to mock the Hive box for testing purposes
class MockHiveBox extends Mock implements Box<Map<String, dynamic>> {}

void main() {
  // Define variables used across the tests
  late LocalDataSource sut;
  late MockHiveBox mockBox;
  late Map<String, dynamic> typicalPart;
  late int typicalPartIndex;
  late ValuesForTest valuesForTest;

  // Setup method runs before each test to initialize variables and dependencies
  setUp(() async {
    // Initialize the class responsible for holding test data
    valuesForTest = ValuesForTest();
    // Set default key-value pair for a part as represented in the Part model and entity
    typicalPart = Map<String, dynamic>.from(valuesForTest.partsList[0]);
    // Initialize the mock box
    mockBox = MockHiveBox();
    //index for our typical part
    typicalPartIndex = 0;
    // Create the system under test, mocking the Hive box
    sut = LocalDataSourceImplementation(mockBox);
  });

  // Check if the index is within the bounds of the list
  bool indexWithinBounds(int index) {
    return (index >= 0 && index < valuesForTest.partsList.length);
  }

  // Mock method to set the length of the Hive box
  void mockBoxSetup() {
    when(
      () => mockBox.length,
    ).thenReturn(valuesForTest.partsList.length);
    when(() => mockBox.keys).thenReturn(valuesForTest.partsList);
  }

  // Test group for createData() method
  group('createData() tests', () {
    // Mock method to add data to the box
    void addDataToMock(Map<String, dynamic> data) {
      // Return a mock Future<int> when add() method is called, in this case 0
      when(() => mockBox.add(any())).thenAnswer((_) async {
        valuesForTest.partsList.add(data);
        return 1;
      });
    }

    // Test to ensure createData() method uses the Hive Box
    test('create data uses the Hive Box', () async {
      addDataToMock(typicalPart);
      await sut.createData(newData: typicalPart);
      // Verify that the add() method was called exactly once
      verify(() => mockBox.add(any())).called(1);
    });

    // Test to check if the 'index' key is removed before placing in the database
    test('check that index is removed before placing in db', () async {
      var expectedResponse = typicalPart;
      var index = 0;
      expectedResponse['index'] = index;
      addDataToMock(expectedResponse);
      // Check if 'index' key exists before the operation
      expect(expectedResponse.containsKey('index'), isTrue);
      await sut.createData(newData: expectedResponse);
      // Check if 'index' key is not present  after the operation
      expect(valuesForTest.partsList[index].containsKey('index'), isFalse);
    });

    // Test to verify if the method properly handles exceptions
    test('check that an exception is returned', () async {
      when(() => mockBox.add(any())).thenThrow(Exception());
      expect(sut.createData(newData: {}), throwsA(isA<CreateDataException>()));
    });
  });

  group('readData() tests', () {
    void getAtMock(int index) {
      mockBoxSetup();
      if (indexWithinBounds(index)) {
        when(() => mockBox.getAt(index))
            .thenReturn(valuesForTest.partsList[index]);
      }
    }

    // Test: Verify that the readData method returns the correct item from the list with its index
    test(
        'check if the read data method returns the appropriate item in the list with its index',
        () async {
      // Define the index of the item to retrieve from the list
      const int index = 0;

      // Setup the mock to return the item at the specified index
      getAtMock(index);
      // Verify that the readData method returns the expected item with its index
      var response = await sut.readData(index: index);
      expect(response.containsKey('index'), isTrue);
      expect(response['index'], equals(index));
      verify(() => mockBox.keys).called(1);
    });

    test('should return {} if the data box.getAt() returns a null value',
        () async {
      // Define the index of the item to retrieve from the list
      const int index = 0;
      mockBoxSetup();

      when(() => mockBox.getAt(index)).thenAnswer((invocation) => null);
      // Verify that the readData method returns the expected item with its index
      var response = await sut.readData(index: index);
      expect(response, equals({}));
    });

    test(
        'check if the read data method throws an exception when the index is out of bounds - upper limit',
        () async {
      const int index = 20; // Index out of bounds
      getAtMock(index); // Configure the mock behavior

      // Expecting the readData method to throw a ReadDataException
      expect(
          () => sut.readData(index: index), throwsA(isA<ReadDataException>()));

      // Verify that getAt method is never called with the out-of-bounds index
      verifyNever(() => mockBox.getAt(index));

      // Verify that the length method is called once
      verify(() => mockBox.length).called(1);
    });

    test(
        'check that the read data method throws and exception when the index is out of bounds - lower limit ',
        () {
      const int index = -91; // Index out of bounds
      getAtMock(index); // Configure the mock behavior

      // Expecting the readData method to throw a ReadDataException
      expect(
          () => sut.readData(index: index), throwsA(isA<ReadDataException>()));

      // Verify that getAt method is never called with the out-of-bounds index
      verifyNever(() => mockBox.getAt(index));

      // Verify that the length method is called once
      verifyNever(() => mockBox.length);
    });
  });

  group('updateData() tests', () {
    // Function: Sets up the mock calls for the putAt() method
    void updateDataMockSetup(int index, Map<String, dynamic> value) {
      // Mock the behavior of the box length
      mockBoxSetup();

      // Define behavior for the putAt() method call
      when(() => mockBox.putAt(index, value)).thenAnswer((_) async {
        // Check if the index is within the bounds of the list
        if (indexWithinBounds(index)) {
          // Replace the value at the specified index with the new value
          valuesForTest.partsList[index] = value;
        }
      });
    }

    // Test case: Checks that the data is updated properly in the database
    test('checks that the data is updated properly in the database', () async {
      // Prepare updated data with a new NSN value
      var updatedData = typicalPart;
      updatedData['nsn'] = '6743-00-323-3293';

      // Choose an index within bounds for the data update
      var index = 2;

      // Setup the mock to simulate the behavior of the database
      updateDataMockSetup(index, updatedData);

      // Call the updateData method with the prepared data and index
      await sut.updateData(updatedData: updatedData, index: index);

      // Verify that the putAt() method is called once with the specified index and updated data
      verify(() => mockBox.putAt(index, updatedData)).called(1);

      // Check if the update actually succeeded by comparing the updatedData with the data at the specified index
      expect(updatedData, equals(valuesForTest.partsList[index]));

      // Verify that the box.length is called to get the upper bounds of our list
      verify(() => mockBox.length).called(1);
    });

    // Test case: Checks that the method throws an exception when the index is out of bounds
    test(
        'checks that the method throws an exception when the index is out of bounds',
        () async {
      // Prepare updated data with a new NSN value
      var updatedData = typicalPart;
      updatedData['nsn'] = '6743-00-323-3293';

      // Choose an index that is out of bounds for the data update
      var index = 20;

      // Setup the mock to simulate the behavior of the database
      updateDataMockSetup(index, updatedData);

      // Execute the updateData method with the prepared data and index and expect an exception
      expect(() => sut.updateData(updatedData: updatedData, index: index),
          throwsA(isA<UpdateDataException>()));

      // Verify that putAt() is never called with the out-of-bounds index
      verifyNever(() => mockBox.putAt(index, updatedData));

      // Verify that the length method is called to get the upper bounds of the list
      verify(() => mockBox.length).called(1);
    });
  });

  group('deleteData() tests', () {
    void mockDeleteDataSetup(int index) {
      mockBoxSetup();
      when(() => mockBox.deleteAt(index)).thenAnswer((_) async {
        if (indexWithinBounds(index)) {
          valuesForTest.partsList.removeAt(index);
        }
      });
    }

    test('checks that the method properly deletes the correct item in the list',
        () async {
      const int index = 2;
      var dataToBeDeleted = valuesForTest.partsList[index];
      mockDeleteDataSetup(index);
      //check to see if data exist before operation
      expect(valuesForTest.partsList.contains(dataToBeDeleted), isTrue);
      //evoke the deleteData() method
      await sut.deleteData(index: index);
      //check to see if it was deleted
      expect(valuesForTest.partsList.contains(dataToBeDeleted), isFalse);
    });

    test('throws a DeleteDataException() when index is out of bounds',
        () async {
      const int index = 20; //out of bounds
      mockDeleteDataSetup(index);

      expect(() => sut.deleteData(index: index),
          throwsA(isA<DeleteDataException>()));
      verifyNever(() => mockBox.deleteAt(index));
      verify(() => mockBox.length).called(1);
    });
  });

  group('.queryData()', () {
    void mockQueryDataSetup(String fieldName, String queryKey) {
      mockBoxSetup();
      when(() => mockBox.values).thenReturn(valuesForTest.partsList);
      when(() => mockBox.containsKey(fieldName))
          .thenReturn(valuesForTest.partsList[0].containsKey(fieldName));
    }

    test('returns map<string,dynamic> based on match', () async {
      const String fieldName = 'nsn';
      final String queryKey = typicalPart['nsn'];
      mockQueryDataSetup(fieldName, queryKey);
      var results =
          await sut.queryData(fieldName: fieldName, queryKey: queryKey);
      typicalPart['index'] = typicalPartIndex;
      var expectedResults = [typicalPart];
      expect(results, equals(expectedResults));
      verify(() => mockBox.values).called(1);
      verify(() => mockBox.containsKey(fieldName)).called(1);
    });
    test('returns an empty list when no match found', () async {
      const String fieldName = 'nsn';
      //A key that does not exist
      const String queryKey = 'ii--143';
      mockQueryDataSetup(fieldName, queryKey);
      // await the results
      var results =
          await sut.queryData(fieldName: fieldName, queryKey: queryKey);
      //what is expected to return from the .queryData() method
      var expectedResults = [];
      //check that results is an empty list given that the queryKey does not exist
      expect(results, equals(expectedResults));
      //verify that the values were accessed once
      verify(() => mockBox.values).called(1);
      //verify that the check if the key exist in the box is called once
      verify(() => mockBox.containsKey(fieldName)).called(1);
    });
    test('throws a ReadDataException if fieldName does not exist', () async {
      //an field that does not exist
      const String fieldName = 'does_not_exist';
      final String queryKey = typicalPart['nsn'];
      mockQueryDataSetup(fieldName, queryKey);
      //do not await the method will throw the exception, if await is used the
      //runtime handles the error which makes the test fail
      expect(sut.queryData(fieldName: fieldName, queryKey: queryKey),
          throwsA(isA<ReadDataException>()));
      //verify that the values were never accessed
      verifyNever(() => mockBox.values);
      //verify that the check if the key exist in the box is called once
      verify(() => mockBox.containsKey(fieldName)).called(1);
    });
  });
}
>>>>>>> 9a9488c (removed local datasource as a dependency)
