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
  LocalDataSourceImplementation(Box<PartEntity> localStorage)
      : _localDataSourceLogger = Logger('Local_Database'),
        _localStorage = localStorage;
  final Box<PartEntity> _localStorage;
  final Logger _localDataSourceLogger;

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

  String _cleanKey(String key) {
    var cleanKey = key.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    cleanKey.replaceAll("-", "");
    return cleanKey;
  }

  @override
  Future<void> createData({required PartEntity data}) async {
    try {
      _localDataSourceLogger.finest('adding $data');
      PartEntity(
          index: _localStorage.length,
          name: data.name,
          nsn: data.nsn,
          partNumber: data.partNumber,
          location: data.location,
          quantity: data.quantity,
          requisitionPoint: data.requisitionPoint,
          requisitionQuantity: data.requisitionQuantity,
          serialNumber: data.serialNumber,
          unitOfIssue: data.unitOfIssue);
      var index = await _localStorage.add(data);
      _localDataSourceLogger.finest('returned with index $index');
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
  Future<PartEntity> readData({required int index}) async {
    _localDataSourceLogger.finest('retrieving data from storage at $index');

    if (!_indexWithinBounds(index)) {
      _localDataSourceLogger.warning('index out of bounds $index');
      throw IndexOutOfBounds();
    }
    var key = _localStorage.keyAt(index);
    try {
      PartEntity? res = _localStorage.get(key, defaultValue: Part(index: index))
          as PartEntity;
      var newPart = PartEntity(
          index: index,
          name: res.name,
          nsn: res.nsn,
          partNumber: res.partNumber,
          location: res.location,
          quantity: res.quantity,
          requisitionPoint: res.requisitionPoint,
          requisitionQuantity: res.requisitionQuantity,
          serialNumber: res.serialNumber,
          unitOfIssue: res.unitOfIssue);

      _localDataSourceLogger.fine('index for part is ${newPart.index}');
      return newPart;
    } catch (e) {
      _localDataSourceLogger.severe(e);
    }
    return Part(index: index);
  }

  @override
  Future<void> updateData({required PartEntity updatedData}) async {
    if (!_indexWithinBounds(updatedData.index)) {
      _localDataSourceLogger
          .warning('error encountered updating data ${updatedData.index}');
      throw UpdateDataException();
    }

    _localDataSourceLogger
        .finest('updating data in storage at ${updatedData.index}');
    return _localStorage.putAt(updatedData.index, updatedData);
  }

  @override
  Future<List<PartEntity>> queryData(
      {required String fieldName, required String queryKey}) async {
    if (!_localStorage.containsKey(fieldName)) {
      _localDataSourceLogger.warning('error encountered  querying the dataset');
      throw ReadDataException();
    }
    final String cleanQuery = _cleanKey(queryKey);
    _localDataSourceLogger.finest('searching for $queryKey in database');
    List<PartEntity> parts = _localStorage.values.where((data) {
      bool match = _cleanKey(data.nsn).contains(cleanQuery);
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
