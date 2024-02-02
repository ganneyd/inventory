import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/models/part/part_model.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_state.dart';
import 'package:inventory_v1/service_locator.dart';

class AddPartCubit extends Cubit<AddPartState> {
  AddPartCubit()
      : _addPartUsecase = locator<AddPartUsecase>(),
        super(AddPartState(
          formKey: GlobalKey<FormState>(),
          addPartStateStatus: AddPartStateStatus.loadedSuccessfully,
          locationController: TextEditingController(),
          nsnController: TextEditingController(),
          nomenclatureController: TextEditingController(),
          partNumberController: TextEditingController(),
          requisitionPointController: TextEditingController(),
          requisitionQuantityController: TextEditingController(),
          quantityController: TextEditingController(),
          serialNumberController: TextEditingController(),
        ));

  final AddPartUsecase _addPartUsecase;

  ///method to save parts by emitting new state with the part
  void savePart() async {
    //first apply() the part to check validation
    applyPart();
    var results = await _addPartUsecase(AddPartParams(partEntity: _getPart()));

    results.fold(
        //emit failure
        (l) => emit(state.copyWith(
            isFormValid: false,
            error: l.errorMessage,
            addPartStateStatus: AddPartStateStatus.createdDataUnsuccessfully)),
        (r) {
      //clear form
      _clearForm();
      //emit success
      emit(state.copyWith(
          isFormValid: false,
          addPartStateStatus: AddPartStateStatus.createdDataSuccessfully));
    });
  }

  void applyPart() {
    //emit that the data is being created
    emit(state.copyWith(addPartStateStatus: AddPartStateStatus.creatingData));
    //check that the form is valid first
    if (state.formKey.currentState!.validate()) {
      //if its valid then emit the part with the state and update that the form
      //is valid now
      emit(state.copyWith(
          isFormValid: true,
          part: _getPart(),
          addPartStateStatus: AddPartStateStatus.loadedSuccessfully));
      //if its not valid emit new status
    } else {
      //tell the user what the error was
      //form is not valid
      emit(state.copyWith(
          isFormValid: false,
          error: 'Please enter correct values',
          addPartStateStatus: AddPartStateStatus.loadedUnsuccessfully));
    }
  }

  void dropDownMenuHandler(UnitOfIssue value) {
    emit(state.copyWith(unitOfIssue: value));
  }

//method to extrapolate part from form
  Part _getPart() {
    return Part(
        name: state.nomenclatureController.text,
        serialNumber: state.serialNumberController.text.isEmpty
            ? 'N/A'
            : state.serialNumberController.text,
        requisitionPoint: int.parse(state.requisitionPointController.text),
        requisitionQuantity: int.parse(state.requisitionPointController.text),
        quantity: int.parse(state.quantityController.text),
        nsn: state.nsnController.text,
        partNumber: state.partNumberController.text,
        index: 0,
        location: state.locationController.text,
        unitOfIssue: state.unitOfIssue);
  }

//method to reset the form after the user inputted values
  void _clearForm() {
    emit(state.copyWith(
      nsnController: state.nsnController..clear(),
      partNumberController: state.partNumberController..clear(),
      serialNumberController: state.serialNumberController..clear(),
      nomenclatureController: state.nomenclatureController..clear(),
      locationController: state.locationController..clear(),
      unitOfIssue: UnitOfIssue.EA,
      quantityController: state.quantityController..clear(),
      requisitionPointController: state.requisitionPointController..clear(),
      requisitionQuantityController: state.requisitionQuantityController
        ..clear(),
    ));
  }
}
