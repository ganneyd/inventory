import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/models/part/part_model.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_state.dart';
import 'package:inventory_v1/service_locator.dart';

class AddPartCubit extends Cubit<AddPartState> {
  AddPartCubit(super.initialState)
      : _addPartUsecase = locator<AddPartUsecase>();

  final AddPartUsecase _addPartUsecase;

  void savePart() async {
    emit(state.copyWith(
        addPartStateStatus: AddPartStateStatus.creatingData, part: _getPart()));
    var results = await _addPartUsecase(AddPartParams(partEntity: _getPart()));

    results.fold(
        (l) => emit(state.copyWith(
            error: l.errorMessage,
            addPartStateStatus: AddPartStateStatus.createdDataUnsuccessfully)),
        (r) => emit(state.copyWith(
            addPartStateStatus: AddPartStateStatus.createdDataSuccessfully)));
  }

  void applyPart() {
    emit(state.copyWith(addPartStateStatus: AddPartStateStatus.creatingData));
    emit(state.copyWith(part: _getPart()));
    emit(state.copyWith(
        addPartStateStatus: AddPartStateStatus.loadedSuccessfully));
  }

  Part _getPart() {
    return Part(
      name: state.nomenclatureController.text,
      serialNumber: state.serialNumberController.text,
      requisitionPoint: int.parse(state.requisitionPointController.text),
      requisitionQuantity: int.parse(state.requisitionPointController.text),
      quantity: int.parse(state.quantityController.text),
      nsn: state.nsnController.text,
      partNumber: state.partNumberController.text,
      index: 0,
      location: state.locationController.text,
      unitOfIssue: _getUnitOfIssue(state.unitOfIssueController.text),
    );
  }

  UnitOfIssue _getUnitOfIssue(String text) {
    switch (text) {
      case 'EA':
        return UnitOfIssue.EA;
      case 'LB':
        return UnitOfIssue.LB;
      default:
        return UnitOfIssue.NOT_SPECIFIED;
    }
  }
}
