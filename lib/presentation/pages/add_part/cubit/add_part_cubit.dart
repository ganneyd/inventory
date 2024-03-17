import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_state.dart';
import 'package:logging/logging.dart';

class AddPartCubit extends Cubit<AddPartState> {
  final AddPartUsecase addPartUsecase;
  final GetPartByNsnUseCase getPartByNsnUseCase;
  final EditPartUsecase editPartUsecase;
  final Logger _logger;
  AddPartCubit({
    required this.editPartUsecase,
    required this.addPartUsecase,
    required this.getPartByNsnUseCase,
  })  : _logger = Logger('add-part-cubit'),
        super(
          AddPartState(
            addPartStateStatus: AddPartStateStatus.loadedSuccessfully,
          ),
        );

  void dropDownMenuHandler(UnitOfIssue value) {
    emit(state.copyWith(unitOfIssue: value));
  }

//method to extrapolate part from form
  PartEntity _getPart({
    required String nsn,
    required String name,
    required String partNumber,
    required String location,
    required String quantity,
    required String requisitionPoint,
    required String requisitionQuantity,
    required String serialNumber,
    required UnitOfIssue unitOfIssue,
  }) {
    return PartEntity(
        isDiscontinued: false,
        checksum: 0,
        name: name,
        serialNumber: serialNumber,
        requisitionPoint: int.parse(requisitionPoint),
        requisitionQuantity: int.parse(requisitionQuantity),
        quantity: int.parse(quantity),
        nsn: nsn,
        partNumber: partNumber,
        index: 0,
        location: location,
        unitOfIssue: unitOfIssue);
  }

  void addPart({
    required String nsn,
    required String name,
    required String partNumber,
    required String location,
    required String quantity,
    required String requisitionPoint,
    required String requisitionQuantity,
    required String serialNumber,
    required UnitOfIssue unitOfIssue,
  }) async {
    var partEntity = _getPart(
        nsn: nsn,
        name: name,
        partNumber: partNumber,
        location: location,
        quantity: quantity,
        requisitionPoint: requisitionPoint,
        requisitionQuantity: requisitionQuantity,
        serialNumber: serialNumber,
        unitOfIssue: unitOfIssue);

    var results =
        await addPartUsecase.call(AddPartParams(partEntity: partEntity));

    results.fold(
        //emit failure
        (l) => emit(state.copyWith(
            isFormValid: false,
            error: l.errorMessage,
            addPartStateStatus: AddPartStateStatus.createdDataUnsuccessfully)),
        (r) {
      //emit success
      emit(state.copyWith(
          error: 'success creating part',
          isFormValid: false,
          part: partEntity,
          addPartStateStatus: AddPartStateStatus.createdDataSuccessfully));
    });
  }

  void checkIfPartExists({required String nsn}) async {
    var results =
        await getPartByNsnUseCase.call(GetAllPartByNsnParams(queryKey: nsn));
    results.fold((_) => (), (parts) {
      if (parts.isNotEmpty) {
        emit(state.copyWith(
            existingParts: parts,
            addPartStateStatus: AddPartStateStatus.foundMatches));
      }
    });
    _logger.finest('found ${state.existingParts.length} parts matching $nsn');
  }

  void updateQuantity(
      {PartEntity? partEntity, required int additionalQuantity}) async {
    if (partEntity != null && additionalQuantity > 0) {
      var results = await editPartUsecase.call(EditPartParams(
          partEntity: partEntity.copyWith(
              quantity: partEntity.quantity + additionalQuantity)));

      results.fold(
          (l) => emit(state.copyWith(
              error: l.errorMessage,
              addPartStateStatus:
                  AddPartStateStatus.updatedQuantityUnsuccessfully)),
          (r) => emit(state.copyWith(
              error: '',
              part: partEntity.copyWith(
                  quantity: partEntity.quantity + additionalQuantity),
              addPartStateStatus:
                  AddPartStateStatus.updatedQuantitySuccessfully)));
    } else {
      emit(state.copyWith(addPartStateStatus: AddPartStateStatus.searched));
    }
  }
}
