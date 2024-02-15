import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/add_part/cubit/add_part_state.dart';

class AddPartCubit extends Cubit<AddPartState> {
  final AddPartUsecase addPartUsecase;
  final GlobalKey<FormState> formKey;
  final TextEditingController nsnController;
  final TextEditingController nomenclatureController;
  final TextEditingController partNumberController;
  final TextEditingController requisitionPointController;
  final TextEditingController requisitionQuantityController;
  final TextEditingController quantityController;
  final TextEditingController serialNumberController;
  final TextEditingController locationController;

  AddPartCubit({
    required this.addPartUsecase,
    required this.formKey,
    required this.nsnController,
    required this.nomenclatureController,
    required this.partNumberController,
    required this.requisitionPointController,
    required this.requisitionQuantityController,
    required this.quantityController,
    required this.serialNumberController,
    required this.locationController,
  }) : super(
          AddPartState(
            formKey: formKey,
            addPartStateStatus: AddPartStateStatus.loadedSuccessfully,
            locationController: locationController,
            nsnController: nsnController,
            nomenclatureController: nomenclatureController,
            partNumberController: partNumberController,
            requisitionPointController: requisitionPointController,
            requisitionQuantityController: requisitionQuantityController,
            quantityController: quantityController,
            serialNumberController: serialNumberController,
          ),
        );

  ///method to save parts by emitting new state with the part
  void savePart() async {
    //first apply() the part to check validation
    applyPart();

    if (state.isFormValid) {
      var results =
          await addPartUsecase.call(AddPartParams(partEntity: state.part!));

      results.fold(
          //emit failure
          (l) => emit(state.copyWith(
              isFormValid: false,
              error: l.errorMessage,
              addPartStateStatus:
                  AddPartStateStatus.createdDataUnsuccessfully)), (r) {
        //clear form
        _clearForm();
        //emit success
        emit(state.copyWith(
            error: 'success creating part',
            isFormValid: false,
            addPartStateStatus: AddPartStateStatus.createdDataSuccessfully));
      });
    }
  }

  void applyPart() {
    //check that the form is valid first
    if (state.formKey.currentState != null) {
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
    } else {
      //tell the user what the error was
      //form is not valid
      emit(state.copyWith(
          isFormValid: false,
          error: 'Error encountered trying to save form, please try again',
          addPartStateStatus: AddPartStateStatus.loadedUnsuccessfully));
    }
  }

  void dropDownMenuHandler(UnitOfIssue value) {
    emit(state.copyWith(unitOfIssue: value));
  }

//method to extrapolate part from form
  PartEntity _getPart() {
    return PartEntity(
        checksum: 0,
        name: state.nomenclatureController.text,
        serialNumber: state.serialNumberController.text.isEmpty
            ? 'N/A'
            : state.serialNumberController.text,
        requisitionPoint: int.parse(state.requisitionPointController.text),
        requisitionQuantity:
            int.parse(state.requisitionQuantityController.text),
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
