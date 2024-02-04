import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:logging/logging.dart';
import 'package:logging/logging.dart';

import '../../core/error/exceptions.dart';

class PartRepositoryImplementation extends PartRepository {
  PartRepositoryImplementation(LocalDataSource localDataSource)
      : _localDataSource = localDataSource,
        _logger = Logger('part-repo-impl');
  PartRepositoryImplementation(Box<PartEntity> localDataSource)
      : _localDataSource = localDataSource,
        _logger = Logger('part-repo');

  final LocalDataSource _localDataSource;
  final Logger _logger;
  final Box<PartEntity> _localDataSource;
  final Logger _logger;

  PartEntity _getPartWithIndex(
      {required int index, required PartEntity partEntity}) {
    return PartEntity(
        index: index,
        name: partEntity.name,
        nsn: partEntity.nsn,
        partNumber: partEntity.partNumber,
        location: partEntity.location,
        quantity: partEntity.quantity,
        requisitionPoint: partEntity.requisitionPoint,
        requisitionQuantity: partEntity.requisitionQuantity,
        serialNumber: partEntity.serialNumber,
        unitOfIssue: partEntity.unitOfIssue);
  }

  @override
  Future<Either<Failure, void>> createPart(PartEntity partEntity) async {
    try {
      _logger.finest('creating new part $partEntity');
      return Right<Failure, void>(
          await _localDataSource.createData(data: partEntity));
      _logger.finest('setting partEntity index');
      var index = _localDataSource.isEmpty ? 0 : _localDataSource.length;
      _logger.finest('index is $index');

      await _localDataSource
          .add(_getPartWithIndex(index: index, partEntity: partEntity));
      _logger.finest('index set');
      return const Right<Failure, void>(null);
    } on CreateDataException {
      _logger.warning('CreateDataException occurred');
      return const Left<Failure, void>(CreateDataFailure());
      return Left<Failure, void>(CreateDataFailure());
    } catch (e) {
      _logger.severe('Unknown Exception occurred', [e]);
      return const Left<Failure, void>(CreateDataFailure());
      return Left<Failure, void>(CreateDataFailure(errMsg: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePart(PartEntity partEntity) async {
    try {
      _logger.finest('deleting part at  ${partEntity.index}');
      return Right<Failure, void>(
          await _localDataSource.delete(partEntity.index));
    } on DeleteDataException {
      _logger.warning('DeleteDataFailure() occurred');
      return const Left<Failure, void>(DeleteDataFailure());
    } catch (e) {
      return const Left<Failure, void>(DeleteDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editPart(PartEntity partEntity) async {
    try {
      _logger.finest('editing  part $partEntity');
      return Right<Failure, void>(
          await _localDataSource.updateData(updatedData: partEntity));
      return Right<Failure, void>(
          await _localDataSource.putAt(partEntity.index, partEntity));
    } on UpdateDataException {
      _logger.warning('UpdateDataFailure() occurred');
      return const Left<Failure, void>(UpdateDataFailure());
    } catch (e) {
      _logger.severe('Unknown exception occurred  ', [e]);
      return const Left<Failure, void>(UpdateDataFailure());
    }
  }

  @override
  Future<Either<Failure, List<PartEntity>>> getAllParts(
      int startIndex, int pageIndex) async {
    try {
      var upperBound = _localDataSource.length;
      var lowerBound = startIndex < 0 ? 0 : startIndex;

      if (pageIndex < upperBound) {
        upperBound = pageIndex + 1;
      }
      _logger.finest(
          'getting all parts lowerBound is $lowerBound and upperBound is $upperBound');
      _logger.finest(
          'getting all parts lowerBound is $lowerBound and upperBound is $upperBound');
      if (upperBound < lowerBound) {
        _logger.severe(
            'upperBound is less than lowerBound, throwing exception... ');
        throw IndexOutOfBounds();
        _logger.severe(
            'upperBound is less than lowerBound, throwing exception... ');
        throw IndexOutOfBounds();
      }

      List<PartEntity> parts = [];
      List<PartEntity> parts = [];
      for (int i = lowerBound; i < upperBound; i++) {
        PartEntity part = await _localDataSource.readData(index: i);
        parts.add(part);
      }
      _logger.finest('got ${parts.length} parts from database');
      return Right<Failure, List<PartEntity>>(parts);
        var part = _localDataSource.getAt(i);
        if (part != null) {
          parts.add(part);
        }
      }
      _logger.finest('got ${parts.length} parts from database');
      return Right<Failure, List<PartEntity>>(parts);
    } on ReadDataException {
      _logger.warning('ReadDataFailure() occurred');
      _logger.warning('ReadDataFailure() occurred');
      return const Left<Failure, List<PartEntity>>(ReadDataFailure());
    } on IndexOutOfBounds {
      _logger.warning('ReadDataFailure() occurred');
      return Left<Failure, List<PartEntity>>(OutOfBoundsFailure());
    } catch (e) {
      _logger.severe('Unknown exception occurred  $e', [e.runtimeType]);
      _logger.severe('Unknown exception occurred  $e', [e.runtimeType]);
      return const Left<Failure, List<PartEntity>>(GetFailure());
    }
  }

  String _cleanKey(String key) {
    var cleanKey = key.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    cleanKey.replaceAll("-", "");
    return cleanKey;
  }

  @override
  Future<Either<Failure, List<PartEntity>>> searchPartsByField(
      {required String fieldName, required String queryKey}) async {
    try {
      List<PartEntity> parts = [];
      _logger.finest(
          'searching all parts that $fieldName matches or contains $queryKey');
      List<PartEntity> queryList = await _localDataSource.queryData(
          fieldName: fieldName, queryKey: queryKey);
      for (PartEntity item in queryList) {
        parts.add(item);
      }
      _logger.finest('found ${parts.length} that matches the query');
      return Right<Failure, List<PartEntity>>(parts);
      List<PartEntity> parts = [];

      if (!_localDataSource.containsKey(fieldName)) {
        _logger.warning('error encountered  querying the dataset');
        throw ReadDataException();
      }
      final String cleanQuery = _cleanKey(queryKey);
      _logger.finest('searching for $queryKey in database');
      parts = _localDataSource.values.where((data) {
        switch (fieldName) {
          case PartRepository.partNameField:
            return _cleanKey(data.name).contains(cleanQuery);
          case PartRepository.partNsnField:
            return _cleanKey(data.nsn).contains(cleanQuery);
          case PartRepository.partNumberField:
            return _cleanKey(data.name).contains(cleanQuery);
          case PartRepository.partSerialNumberField:
            return _cleanKey(data.serialNumber).contains(cleanQuery);
          default:
            return false;
        }
      }).toList();

      return Right<Failure, List<PartEntity>>(parts);
    } on ReadDataFailure {
      _logger.warning('ReadDataFailure() occurred');
      return const Left<Failure, List<Part>>(ReadDataFailure());
      return const Left<Failure, List<PartEntity>>(ReadDataFailure());
    } catch (e) {
      _logger.severe('Unknown exception occurred  ', [e]);
      return const Left<Failure, List<Part>>(ReadDataFailure());
      return const Left<Failure, List<PartEntity>>(ReadDataFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getDatabaseLength() async {
    try {
      var length = _localDataSource.length;
      _logger.finest('retrieved database length and it is $length');
      return Right<Failure, int>(length);
    } catch (e) {
      return const Left<Failure, int>(ReadDataFailure());
    }
  }
}
