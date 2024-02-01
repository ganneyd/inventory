import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/exceptions.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:logging/logging.dart';

///Contract for the LocalDatabases
abstract class LocalDataSource {
  ///Creates a new [table/field] in the database takes [tableName] and [newData] as
  ///arguments
  Future<void> createData({
    required PartEntity data,
  });

  ///Updates data in a particular [tableName] as specified by the [index] and
  ///replacing the data with [updatedData]
  Future<void> updateData({required PartEntity updatedData});

  ///Retrieves a particular [item] using [index] from its respective [tableName]
  Future<PartEntity> readData({required int index});

  ///Deletes data in [tableName] at the [index] provided
  Future<void> deleteData({
    required int index,
  });

  ///Queries the [tableName] in the dataset finding a result based on the [queryKey]
  ///in the [fieldName]
  Future<List<PartEntity>> queryData(
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
      : _logger = Logger('Local_Database'),
        _localStorage = localStorage;
  final Box<Map<String, dynamic>> _localStorage;
  final Logger _logger;

  Map<String, dynamic> _removeIndex(Map<String, dynamic> data) {
    var newData = Map<String, dynamic>.from(data);
    if (data.containsKey('index')) {
      newData.remove('index');
    }
    return newData;
  }

  bool _indexWithinBounds(int index) {
    _localDataSourceLogger.fine('checking to see if within bounds');
    return (index >= 0 && index < _localStorage.length);
  }

  Map<String, dynamic> _addIndex(Map<String, dynamic> data) {
    var newData = Map<String, dynamic>.from(data);
    if (!data.containsKey('index')) {
      _logger.finest('found index _addIndex() is: ');
      var index = _localStorage.values.toList().indexOf(data);
      _logger.finest('found index _addIndex() is: $index');
      newData['index'] = index;
    }
    return newData;
  }

  String _cleanKey(String key) {
    var cleanKey = key.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    cleanKey.replaceAll("-", "");
    return cleanKey;
  }

  @override
  Future<void> createData({required PartEntity data}) async {
    try {
      await _localStorage.add(_removeIndex(newData));
      _logger.finest('added new data entry $newData?[nsn]');
    } catch (e) {
      _logger.warning('error encountered adding data, message: $e');
      throw CreateDataException();
    }
  }

  @override
  Future<void> deleteData({required int index}) async {
    if (!_indexWithinBounds(index)) {
      _logger.warning('error encountered deleting data $index');
      throw DeleteDataException();
    }
    await _localStorage.deleteAt(index);
    _logger.finest('deleted data $index');
  }

  @override
  Future<Map<String, dynamic>> readData({required int index}) async {
    _logger.finest('retrieve data from storage at $index');

    if (!_indexWithinBounds(index)) {
      _logger.warning('error encountered reading data $index');
      throw ReadDataException();
    }

    Map<String, dynamic>? data = _localStorage.getAt(index);
    data = data ?? {};
    data['index'] = index;
    return data;
  }

  @override
  Future<void> updateData(
      {required Map<String, dynamic> updatedData, required int index}) async {
    if (!_indexWithinBounds(index)) {
      _logger.warning('error encountered updating data $index');
      throw UpdateDataException();
    }

    _logger.finest('updating data in storage at $index');
    return _localStorage.putAt(index, updatedData);
  }

  @override
  Future<List<PartEntity>> queryData(
      {required String fieldName, required String queryKey}) async {
    if (!_localStorage.containsKey(fieldName)) {
      _logger.warning('error encountered  querying the dataset');
      throw ReadDataException();
    }
    final String cleanQuery = _cleanKey(queryKey);
    _logger.finest('searching for $queryKey in database');
    List<Map<String, dynamic>> parts = _localStorage.values.where((data) {
      bool match = _cleanKey(data[fieldName]).contains(cleanQuery);
      return match;
    }).toList();
    parts = parts.map((part) {
      return part;
    }).toList();

    return parts;
  }

  @override
  int getLength() {
    return _localStorage.isEmpty ? 0 : _localStorage.length;
  }
}
