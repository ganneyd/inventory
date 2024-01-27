import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/datasources/local_database.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';

import '../../core/error/exceptions.dart';

class PartRepositoryImplementation extends PartRepository {
  PartRepositoryImplementation(LocalDataSource localDataSource)
      : _localDataSource = localDataSource;

  final LocalDataSource _localDataSource;

  @override
  Future<Either<Failure, void>> createPart(PartEntity partEntity) async {
    try {
      Part part = PartAdapter.fromEntity(partEntity);

      return Right<Failure, void>(
          await _localDataSource.createData(newData: part.toJson()));
    } on CreateDataException {
      return const Left<Failure, void>(CreateDataFailure());
    } catch (e) {
      return const Left<Failure, void>(CreateDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deletePart(PartEntity partEntity) async {
    try {
      return Right<Failure, void>(
          await _localDataSource.deleteData(index: partEntity.index));
    } on DeleteDataException {
      return const Left<Failure, void>(DeleteDataFailure());
    } catch (e) {
      return const Left<Failure, void>(DeleteDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editPart(PartEntity partEntity) async {
    try {
      Part part = PartAdapter.fromEntity(partEntity);

      return Right<Failure, void>(await _localDataSource.updateData(
          updatedData: part.toJson(), index: part.index));
    } on UpdateDataException {
      return const Left<Failure, void>(UpdateDataFailure());
    } catch (e) {
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

      if (upperBound < lowerBound) {
        throw ReadDataException();
      }

      List<Part> parts = [];
      for (int i = lowerBound; i < upperBound; i++) {
        Map<String, dynamic> part = await _localDataSource.readData(index: i);
        if (part != <String, dynamic>{}) {
          parts.add(Part.fromJson(part));
        }
      }
      return Right<Failure, List<Part>>(parts);
    } on ReadDataException {
      return const Left<Failure, List<PartEntity>>(ReadDataFailure());
    } catch (e) {
      return const Left<Failure, List<PartEntity>>(GetFailure());
    }
  }

  @override
  Future<Either<Failure, List<PartEntity>>> searchPartsByField(
      {required String fieldName, required String queryKey}) async {
    try {
      List<Part> parts = [];

      List<Map<String, dynamic>> queryList = await _localDataSource.queryData(
          fieldName: fieldName, queryKey: queryKey);
      for (Map<String, dynamic> item in queryList) {
        parts.add(Part.fromJson(item));
      }

      return Right<Failure, List<Part>>(parts);
    } on ReadDataFailure {
      return const Left<Failure, List<Part>>(ReadDataFailure());
    } catch (e) {
      return const Left<Failure, List<Part>>(ReadDataFailure());
    }
  }
}
