import 'dart:async';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/exceptions.dart';
import 'package:logging/logging.dart';

///Contract for the LocalDatabases
abstract class LocalDataSource {
  ///Creates a new [table/field] in the database takes [tableName] and [newData] as
  ///arguments
  Future<void> createData({
    required Map<String, dynamic> newData,
  });

  ///Updates data in a particular [tableName] as specified by the [index] and
  ///replacing the data with [updatedData]
  Future<void> updateData({
    required Map<String, dynamic> updatedData,
    required int index,
  });

  ///Retrieves a particular [item] using [index] from its respective [tableName]
  Future<Map<String, dynamic>> readData({required int index});

  ///Deletes data in [tableName] at the [index] provided
  Future<void> deleteData({
    required int index,
  });

  ///Queries the [tableName] in the dataset finding a result based on the [queryKey]
  ///in the [fieldName]
  Future<List<Map<String, dynamic>>> queryData(
      {required String fieldName, required String queryKey});
}

//*************************************************************************** */

///Implementation of the LocalDataSource contract
///takes an [Hive] instance to access locally stored data
class LocalDataSourceImplementation extends LocalDataSource {
  ///Takes a instance of the open [Box]
  LocalDataSourceImplementation(Box<Map<String, dynamic>> localStorage)
      : _localDataSourceLogger = Logger('Local_Database'),
        _localStorage = localStorage;
  final Box<Map<String, dynamic>> _localStorage;
  final Logger _localDataSourceLogger;
  @override
  Future<void> createData({required Map<String, dynamic> newData}) async {
    try {
      newData.remove('index');
      await _localStorage.add(newData);
      _localDataSourceLogger.finest('added new data entry $newData?[nsn]');
    } catch (e) {
      _localDataSourceLogger
          .warning('error encountered adding data, message: $e');
      throw CreateDataException();
    }
  }

  @override
  Future<void> deleteData({required int index}) async {
    try {
      await _localStorage.delete(index);
      _localDataSourceLogger.finest('deleted data $index');
    } catch (e) {
      _localDataSourceLogger
          .warning('error encountered deleting data $index, message: $e');
      throw DeleteDataException();
    }
  }

  @override
  Future<Map<String, dynamic>> readData({required int index}) async {
    _localDataSourceLogger.finest('retrieve data from storage at $index');

    final int boxLength = _localStorage.length;

    if (index < 0 || index >= boxLength) {
      _localDataSourceLogger.warning('error encountered reading data $index');
      throw ReadDataException();
    }

    final Map<String, dynamic>? data = _localStorage.getAt(index);

    if (data != null) {
      var readData = Map<String, dynamic>.from(data);
      readData['index'] = index;
      return readData;
    } else {
      _localDataSourceLogger.warning('error encountered reading data $index');
      throw ReadDataException();
    }
  }

  @override
  Future<void> updateData(
      {required Map<String, dynamic> updatedData, required int index}) async {
    try {
      _localDataSourceLogger.finest('updating data in storage at $index');
      return _localStorage.putAt(index, updatedData);
    } catch (e) {
      _localDataSourceLogger
          .warning('error encountered updating data $index, message: $e');
      throw UpdateDataException();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> queryData(
      {required String fieldName, required String queryKey}) async {
    try {
      final String cleanQuery = queryKey.replaceAll(RegExp(r'[^0-9]'), '');
      _localDataSourceLogger.finest('searching for $queryKey in database');
      List<Map<String, dynamic>> parts = _localStorage.values.where((part) {
        return part[fieldName]
            .toString()
            .replaceAll(RegExp(r'[^0-9]'), '')
            .toLowerCase()
            .contains(cleanQuery);
      }).toList();

      return parts;
    } catch (e) {
      _localDataSourceLogger
          .warning('error encountered  querying the dataset, message: $e');
      throw UpdateDataException();
    }
  }
}
