part of 'part_model.dart';

class PartEntityToModelAdapter {
  ///Even though [PartModel] inherits [PartEntity] an entity does not have access to
  ///methods defined by the part class in the data layer. As such this adapter
  ///class is used to bridge the structures.
  static PartModel fromEntity(PartEntity partEntity) {
    return PartModel(
        index: partEntity.index,
        name: partEntity.name,
        nsn: partEntity.nsn,
        partNumber: partEntity.partNumber,
        location: partEntity.location,
        quantity: partEntity.quantity,
        requisitionPoint: partEntity.requisitionPoint,
        requisitionQuantity: partEntity.requisitionQuantity,
        serialNumber: partEntity.serialNumber,
        unitOfIssue: partEntity.unitOfIssue,
        checksum: partEntity.checksum);
  }
}
