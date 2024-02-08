import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';

part 'add_part_state.freezed.dart';

//the different states` the add_part page can be in
enum AddPartStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  creatingData,
  createdDataSuccessfully,
  createdDataUnsuccessfully
}

@freezed
class AddPartState with _$AddPartState {
  factory AddPartState({
    PartEntity? part,
    String? error,
    required GlobalKey<FormState> formKey,
    @Default(false) bool isFormValid,
    @Default(UnitOfIssue.EA) UnitOfIssue unitOfIssue,
    required TextEditingController nsnController,
    required TextEditingController partNumberController,
    required TextEditingController serialNumberController,
    required TextEditingController nomenclatureController,
    required TextEditingController locationController,
    required TextEditingController quantityController,
    required TextEditingController requisitionPointController,
    required TextEditingController requisitionQuantityController,
    @Default(AddPartStateStatus.loading) addPartStateStatus,
  }) = _AddPartState;
}
