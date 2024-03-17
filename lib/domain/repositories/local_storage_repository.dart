import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';

abstract class LocalStorage {
  Future<Either<Failure, void>> readFromExcel(String path, Box<PartEntity> box);
  Future<Either<Failure, void>> saveToExcel(String path);
  Future<Either<Failure, void>> clearDatabase();
}
