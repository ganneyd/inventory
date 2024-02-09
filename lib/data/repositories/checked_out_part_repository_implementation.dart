import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/exceptions.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/data/models/checked-out/checked_out_model.dart';
import 'package:inventory_v1/domain/repositories/checked_out_part_repository.dart';
import 'package:logging/logging.dart';

class CheckedOutPartRepositoryImplementation extends CheckedOutPartRepository {
  CheckedOutPartRepositoryImplementation(Box<CheckedOutModel> localDataSource)
      : _localDatasource = localDataSource,
        _logger = Logger('checked-out-part-repo');

  final Logger _logger;
  final Box<CheckedOutModel> _localDatasource;
  @override
  Future<Either<Failure, void>> createCheckOut(
      CheckedOutEntity checkedOutEntity) {
    // TODO: implement createCheckOut
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> deleteCheckedOutItem(
      CheckedOutEntity checkedOutEntity) {
    // TODO: implement deleteCheckedOutItem
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> editCheckedOutItem(
      CheckedOutEntity checkedOutEntity) async {
    try {
      return const Right<Failure, void>(null);
    } on UpdateDataException {
      return const Left<Failure, void>(UpdateDataFailure());
    } catch (e) {
      return const Left<Failure, void>(UpdateDataFailure());
    }
  }

  @override
  Future<Either<Failure, List<CheckedOutEntity>>> getCheckedOutItems(
      int startIndex, int endIndex) {
    // TODO: implement getCheckedOutItems
    throw UnimplementedError();
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
