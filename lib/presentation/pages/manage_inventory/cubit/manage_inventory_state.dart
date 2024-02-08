import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';

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
    @Default(20) int fetchPartAmount,
    @Default(0) int databaseLength,
    required ScrollController scrollController,
    @Default(<PartEntity>[]) List<PartEntity> parts,
    @Default('no error') error,
    @Default(ManageInventoryStateStatus.loading)
    ManageInventoryStateStatus status,
  }) = _ManageInventoryState;
}
