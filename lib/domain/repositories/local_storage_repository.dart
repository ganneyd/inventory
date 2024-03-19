import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';

abstract class LocalStorage {
  Future<Either<Failure, String>> readFromExcel(String path);
  Future<Either<Failure, void>> saveToExcel(String path);
  Future<Either<Failure, void>> clearDatabase();
}
