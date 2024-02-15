import 'package:dartz/dartz.dart';
import 'package:inventory_v1/core/error/failures.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';

///Represents the different fields that are searchable in the database
enum PartField {
  ///NSN field
  nsn,

  ///NAME
  name,

  ///PART NUMBER
  partNumber,

  ///SERIAL NUMBER
  serialNumber
}

extension PartFieldExtension on PartField {
  String get displayValue {
    return toString().split('.').last; // Returns only the enum value
  }
}

///Deals with all the [Part] related calls to the APIS and external services
abstract class PartRepository {
  ///Returns the number of items in the database
  Future<Either<Failure, int>> getDatabaseLength();

  ///Creates a part in the inventory database using the [partEntity] passed
  Future<Either<Failure, void>> createPart(PartEntity partEntity);

  Future<Either<Failure, PartEntity>> getSpecificPart(int index);

  ///Retrieves the entire part inventory
  Future<Either<Failure, List<PartEntity>>> getAllParts(
      int startIndex, int pageIndex);

  ///Retrieves a particular part using the part National Stock Number [NSN]
  Future<Either<Failure, List<PartEntity>>> searchPartsByField({
    required PartField fieldName,
    required String queryKey,
  });

  ///Updates a particular [partEntity] that is passed
  Future<Either<Failure, void>> editPart(PartEntity partEntity);

  ///Deletes a particular [partEntity] from the database
  Future<Either<Failure, void>> deletePart(PartEntity partEntity);
}
