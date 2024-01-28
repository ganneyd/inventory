import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';

part 'manage_inventory_state.freezed.dart';

//the different states the add_part page can be in
enum ManageInventoryStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  creatingData,
  createdDataSuccessfully,
  createdDataUnsuccessfully
}

@freezed
class ManageInventoryState with _$ManageInventoryState {
  factory ManageInventoryState({
    Part? part,
    String? error,
    @Default(ManageInventoryStateStatus.loading)
    ManageInventoryStateStatus manageInventoryStateStatus,
  }) = _ManageInventoryState;
}
