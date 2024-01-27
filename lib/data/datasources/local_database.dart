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
  //returns the size of the database
  int getLength();
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

  Map<String, dynamic> _removeIndex(Map<String, dynamic> data) {
    var newData = Map<String, dynamic>.from(data);
    if (data.containsKey('index')) {
      newData.remove('index');
    }
    return newData;
  }

  bool _indexWithinBounds(int index) {
    return (index >= 0 && index < _localStorage.length);
  }

  Map<String, dynamic> _addIndex(Map<String, dynamic> data) {
    var newData = Map<String, dynamic>.from(data);
    if (!data.containsKey('index')) {
      newData['index'] = _localStorage.keys.toList().indexOf(data);
    }
    return newData;
  }

  String _cleanKey(String key) {
    var cleanKey = key.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    cleanKey.replaceAll("-", "");
    return cleanKey;
  }

  @override
  Future<void> createData({required Map<String, dynamic> newData}) async {
    try {
      await _localStorage.add(_removeIndex(newData));
      _localDataSourceLogger.finest('added new data entry $newData?[nsn]');
    } catch (e) {
      _localDataSourceLogger
          .warning('error encountered adding data, message: $e');
      throw CreateDataException();
    }
  }

  @override
  Future<void> deleteData({required int index}) async {
    if (!_indexWithinBounds(index)) {
      _localDataSourceLogger.warning('error encountered deleting data $index');
      throw DeleteDataException();
    }
    await _localStorage.deleteAt(index);
    _localDataSourceLogger.finest('deleted data $index');
  }

  @override
  Future<Map<String, dynamic>> readData({required int index}) async {
    _localDataSourceLogger.finest('retrieve data from storage at $index');

    if (!_indexWithinBounds(index)) {
      _localDataSourceLogger.warning('error encountered reading data $index');
      throw ReadDataException();
    }

    final Map<String, dynamic>? data = _localStorage.getAt(index);
    return data != null ? _addIndex(data) : {};
  }

  @override
  Future<void> updateData(
      {required Map<String, dynamic> updatedData, required int index}) async {
    if (!_indexWithinBounds(index)) {
      _localDataSourceLogger.warning('error encountered updating data $index');
      throw UpdateDataException();
    }

    _localDataSourceLogger.finest('updating data in storage at $index');
    return _localStorage.putAt(index, updatedData);
  }

  @override
  Future<List<Map<String, dynamic>>> queryData(
      {required String fieldName, required String queryKey}) async {
    if (!_localStorage.containsKey(fieldName)) {
      _localDataSourceLogger.warning('error encountered  querying the dataset');
      throw ReadDataException();
    }
    final String cleanQuery = _cleanKey(queryKey);
    _localDataSourceLogger.finest('searching for $queryKey in database');
    List<Map<String, dynamic>> parts = _localStorage.values.where((data) {
      bool match = _cleanKey(data[fieldName]).contains(cleanQuery);
      return match;
    }).toList();
    parts = parts.map((part) {
      return _addIndex(part);
    }).toList();

    return parts;
  }

  @override
  int getLength() {
    return _localStorage.length;
  }
}
