import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';

///Deals with all the [Part] related calls to the APIS and external services
abstract class PartRepository {
  ///Creates a part in the inventory database using the [partEntity] passed
  Future<Either<Failure, void>> addPart(PartEntity partEntity);

  ///Retrieves the entire part inventory
  Future<Either<Failure, PartEntity>> getPart();

  ///Updates a particular [partEntity] that is passed
  Future<Either<Failure, void>> editPart(PartEntity partEntity);

  ///Deletes a particular [partEntity] from the database
  Future<Either<Failure, void>> deletePart(PartEntity partEntity);
}
