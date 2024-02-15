import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/exceptions.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/data/models/checked-out/checked_out_model.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:logging/logging.dart';

class CheckedOutPartRepositoryImplementation extends CheckedOutPartRepository {
  CheckedOutPartRepositoryImplementation(Box<CheckedOutModel> localDataSource)
      : _localDatasource = localDataSource,
        _logger = Logger('checked-out-part-repo');

  final Logger _logger;
  final Box<CheckedOutModel> _localDatasource;

  CheckedOutModel _toCheckoutPartModel(CheckedOutEntity checkedOutEntity) {
    return CheckedOutModel(
        quantityDiscrepancyModel: checkedOutEntity.quantityDiscrepancy,
        indexModel: checkedOutEntity.index,
        checkedOutAmount: checkedOutEntity.checkedOutQuantity,
        dateTimeModel: checkedOutEntity.dateTime,
        partModel: PartEntityToModelAdapter.fromEntity(checkedOutEntity.part),
        isVerifiedModel: checkedOutEntity.isVerified ?? false,
        verifiedDateModel: checkedOutEntity.verifiedDate ?? DateTime.now());
  }

  @override
  Future<Either<Failure, void>> createCheckOut(
      CheckedOutEntity checkedOutEntity) async {
    try {
      _logger.finest('creating new checked out entry $checkedOutEntity');
      var index = _localDatasource.isEmpty ? 0 : _localDatasource.length;
      checkedOutEntity = checkedOutEntity.copyWith(index: index);
      await _localDatasource.add(_toCheckoutPartModel(checkedOutEntity));
      return const Right<Failure, void>(null);
    } catch (exception) {
      return const Left<Failure, void>(CreateDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteCheckedOutItem(
      CheckedOutEntity checkedOutEntity) async {
    try {
      _logger.finest('deleting $checkedOutEntity');
      await _localDatasource.delete(checkedOutEntity.index);
      return const Right<Failure, void>(null);
    } catch (exception) {
      return const Left<Failure, void>(DeleteDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> editCheckedOutItem(
      CheckedOutEntity checkedOutEntity) async {
    try {
      if (checkedOutEntity.index < 0) {
        throw IndexError;
      }

      _localDatasource.putAt(
          checkedOutEntity.index, _toCheckoutPartModel(checkedOutEntity));
      return const Right<Failure, void>(null);
    } on UpdateDataException {
      return const Left<Failure, void>(UpdateDataFailure());
    } catch (e) {
      return const Left<Failure, void>(UpdateDataFailure());
    }
  }

  @override
  Future<Either<Failure, List<CheckedOutEntity>>> getCheckedOutItems(
      int startIndex, int endIndex) async {
    try {
      var upperBound = _localDatasource.length;
      var lowerBound = startIndex < 0 ? 0 : startIndex;

      if (endIndex < upperBound) {
        upperBound = endIndex + 1;
      }
      _logger.finest(
          'getting all parts lowerBound is $lowerBound and upperBound is $upperBound');
      if (upperBound < lowerBound) {
        _logger.severe(
            'upperBound is less than lowerBound, throwing exception... ');
        throw IndexOutOfBounds();
      }

      List<CheckedOutModel> parts = [];
      for (int i = lowerBound; i < upperBound; i++) {
        var part = _localDatasource.getAt(i);
        if (part != null) {
          parts.add(part);
        }
      }
      _logger.finest('got ${parts.length} parts from database');
      return Right<Failure, List<CheckedOutEntity>>(parts);
    } on ReadDataException {
      _logger.warning('ReadDataFailure() occurred');
      return const Left<Failure, List<CheckedOutEntity>>(ReadDataFailure());
    } on IndexOutOfBounds {
      _logger.warning('ReadDataFailure() occurred');
      return const Left<Failure, List<CheckedOutEntity>>(
          IndexOutOfBoundsFailure());
    } catch (e) {
      _logger.severe('Unknown exception occurred  $e', [e.runtimeType]);
      return const Left<Failure, List<CheckedOutEntity>>(GetFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getDatabaseLength() async {
    try {
      var length = _localDatasource.length;
      _logger.finest('retrieved database length and its $length');
      return Right<Failure, int>(length);
    } catch (e) {
      return const Left<Failure, int>(ReadDataFailure());
    }
  }
}
