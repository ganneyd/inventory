import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';

///Deals with all the [CheckedOutModel] related calls to the local database
abstract class CheckedOutPartRepository {
  ///Returns the number of items in the database
  Future<Either<Failure, int>> getDatabaseLength();

  ///Creates a checked out part in the database
  Future<Either<Failure, void>> createCheckOut(
      CheckedOutEntity checkedOutEntity);

  ///Retrieves all the checked out parts from the database starting from the most recent
  Future<Either<Failure, List<CheckedOutEntity>>> getCheckedOutItems(
      int startIndex, int endIndex);

  ///Updates a checked out part in the database
  Future<Either<Failure, void>> editCheckedOutItem(
      CheckedOutEntity checkedOutEntity);

  ///Deletes a particular checked out part in the database
  Future<Either<Failure, void>> deleteCheckedOutItem(
      CheckedOutEntity checkedOutEntity);

  Iterable<CheckedOutEntity> getValues();
  Future<Either<Failure, void>> clearParts();
}
