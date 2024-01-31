import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/datasources/local_database.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:logging/logging.dart';

import '../../core/error/exceptions.dart';

class PartRepositoryImplementation extends PartRepository {
  PartRepositoryImplementation(LocalDataSource localDataSource)
      : _localDataSource = localDataSource,
        _logger = Logger('part-repo-impl');

  final LocalDataSource _localDataSource;
  final Logger _logger;
  @override
  Future<Either<Failure, void>> createPart(PartEntity partEntity) async {
    try {
      _logger.finest('creating new part $partEntity');
      return Right<Failure, void>(
          await _localDataSource.createData(data: partEntity));
    } on CreateDataException {
      _logger.warning('CreateDataException occurred');
      return const Left<Failure, void>(CreateDataFailure());
    } catch (e) {
      _logger.severe('Unknown Exception occurred', [e]);
      return const Left<Failure, void>(CreateDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePart(PartEntity partEntity) async {
    try {
      _logger.finest('deleting part at  ${partEntity.index}');
      return Right<Failure, void>(
          await _localDataSource.deleteData(index: partEntity.index));
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
      var upperBound = _localDataSource.getLength();
      var lowerBound = startIndex < 0 ? 0 : startIndex;

      if (pageIndex < upperBound) {
        upperBound = pageIndex + 1;
      }
      _logger.finest(
          'getting all parts lowerBound is $lowerBound and upperBound is $upperBound');
      if (upperBound < lowerBound) {
        _logger.severe(
            'upperBound is less than lowerBound, throwing exception... ');
        throw IndexOutOfBounds();
      }

      List<PartEntity> parts = [];
      for (int i = lowerBound; i < upperBound; i++) {
        PartEntity part = await _localDataSource.readData(index: i);
        parts.add(part);
      }
      _logger.finest('got ${parts.length} parts from database');
      return Right<Failure, List<PartEntity>>(parts);
    } on ReadDataException {
      _logger.warning('ReadDataFailure() occurred');
      return const Left<Failure, List<PartEntity>>(ReadDataFailure());
    } catch (e) {
      _logger.severe('Unknown exception occurred  $e', [e.runtimeType]);
      return const Left<Failure, List<PartEntity>>(GetFailure());
    }
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
    } on ReadDataFailure {
      _logger.warning('ReadDataFailure() occurred');
      return const Left<Failure, List<Part>>(ReadDataFailure());
    } catch (e) {
      _logger.severe('Unknown exception occurred  ', [e]);
      return const Left<Failure, List<Part>>(ReadDataFailure());
    }
  }
}
