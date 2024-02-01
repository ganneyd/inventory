import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';

///Deals with all the [Part] related calls to the APIS and external services
abstract class PartRepository {
  static const String partNsnField = 'nsn';
  static const String partNameField = 'name';
  static const String partNumberField = 'partNumber';
  static const String partSerialNumberField = 'serialNumber';

  ///Creates a part in the inventory database using the [partEntity] passed
  Future<Either<Failure, void>> createPart(PartEntity partEntity);

  ///Retrieves the entire part inventory
  Future<Either<Failure, List<PartEntity>>> getAllParts(
      int startIndex, int pageIndex);

  ///Retrieves a particular part using the part National Stock Number [NSN]
  Future<Either<Failure, List<PartEntity>>> searchPartsByField({
    required String fieldName,
    required String queryKey,
  });

  ///Updates a particular [partEntity] that is passed
  Future<Either<Failure, void>> editPart(PartEntity partEntity);

  ///Deletes a particular [partEntity] from the database
  Future<Either<Failure, void>> deletePart(PartEntity partEntity);
}
