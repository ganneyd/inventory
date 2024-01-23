import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz_unsafe.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/exceptions.dart';
import 'package:logging/logging.dart';

///Contract for the LocalDatabases
abstract class LocalDataSource {
  ///Creates a new [table/field] in the database takes [tableName] and [newData] as
  ///arguments
  Future<void> createData({
    required String tableName,
    required Map<String, dynamic> newData,
  });

  ///Updates data in a particular [tableName] as specified by the [index] and
  ///replacing the data with [updatedData]
  Future<void> updateData({
    required String tableName,
    required Map<String, dynamic> updatedData,
    required int index,
  });

  ///Retrieves a particular [item] using [index] from its respective [tableName]
  Future<Map<String, dynamic>> readData(
      {required String tableName, required int index});

  ///Retrieves all data in the [tableName]
  Future<List<Map<String, dynamic>>> readDataList({
    required String tableName,
  });

  ///Deletes data in [tableName] at the [index] provided
  Future<void> deleteData({
    required String tableName,
    required int index,
  });
}

//*************************************************************************** */

///Implementation of the LocalDataSource contract
///takes an [Hive] instance to access locally stored data
class LocalDataSourceImplementation extends LocalDataSource {
  ///Takes a instance of the open [Box] and [Logger]
  LocalDataSourceImplementation(Box<Map<String, dynamic>> localStorage)
      : _localDataSourceLogger = Logger('Local_Database'),
        _localStorage = localStorage;
  final Box<Map<String, dynamic>> _localStorage;
  final Logger _localDataSourceLogger;
  final StreamController<List<Map<String, dynamic>>> _streamController =
      StreamController<List<Map<String, dynamic>>>();
  int _currentPage = 0;
  @override
  Future<void> createData(
      {required String tableName,
      required Map<String, dynamic> newData}) async {
    try {
      await _localStorage.add(newData);
      _localDataSourceLogger.finest('added new data entry $newData?[nsn]');
    } catch (e) {
      _localDataSourceLogger
          .warning('error encountered adding data, message: $e');
      throw CreateDataException();
    }
  }

  @override
  Future<void> deleteData(
      {required String tableName, required int index}) async {
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
  Future<Map<String, dynamic>> readData(
      {required String tableName, required int index}) async {
    try {
      _localDataSourceLogger.finest('retrieve data from storage at $index');
      return _localStorage.getAt(index) ?? <String, dynamic>{};
    } catch (e) {
      _localDataSourceLogger
          .warning('error encountered reading data $index, message: $e');
      throw ReadDataException();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> readDataList(
      {required String tableName}) async {
    try {
      List<Map<String, dynamic>> parts = [];
      _localDataSourceLogger.finest('retrieving data from storage');
      Iterable<Map<String, dynamic>> items = _localStorage.values;

      for (Map<String, dynamic> item in items) {
        parts.add(item);
      }

      return parts;
    } catch (e) {
      _localDataSourceLogger
          .warning('error encountered reading data list, message: $e');
      throw ReadDataException();
    }
  }

  @override
  Future<void> updateData(
      {required String tableName,
      required Map<String, dynamic> updatedData,
      required int index}) async {
    try {
      _localDataSourceLogger.finest('updating data in storage at $index');
      return _localStorage.putAt(index, updatedData);
    } catch (e) {
      _localDataSourceLogger
          .warning('error encountered updating data $index, message: $e');
      throw UpdateDataException();
    }
  }
}
