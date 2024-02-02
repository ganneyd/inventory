import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/domain/models/part/part_model.dart';

part 'manage_inventory_state.freezed.dart';

//the different states the add_part page can be in
enum ManageInventoryStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  fetchingData,
  fetchedDataSuccessfully,
  fetchedDataUnsuccessfully
}

@freezed
class ManageInventoryState with _$ManageInventoryState {
  factory ManageInventoryState({
    @Default(0) int databaseLength,
    required ScrollController scrollController,
    @Default(<Part>[]) List<Part> parts,
    @Default('no error') error,
    @Default(ManageInventoryStateStatus.loading)
    ManageInventoryStateStatus status,
  }) = _ManageInventoryState;
}
