import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';

part 'manage_inventory_state.freezed.dart';

//the different states the add_part page can be in
enum ManageInventoryStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  fetchingData,
  fetchedDataSuccessfully,
  fetchedDataUnsuccessfully,
  verifyingPart,
  verifiedPartSuccessfully,
  verifiedPartUnsuccessfully
}

@freezed
class ManageInventoryState with _$ManageInventoryState {
  factory ManageInventoryState({
    @Default(20) int fetchPartAmount,
    @Default(0) int databaseLength,
    @Default(<PartEntity>[]) List<PartEntity> parts,
    @Default(<PartEntity>[]) List<PartEntity> lowQuantityParts,
    @Default(<CheckedOutEntity>[]) List<CheckedOutEntity> unverifiedParts,
    @Default(<CheckedOutEntity>[]) List<CheckedOutEntity> newlyVerifiedParts,
    @Default(<CheckedOutEntity>[]) List<CheckedOutEntity> checkedOutParts,
    @Default('no error') error,
    @Default(ManageInventoryStateStatus.loading)
    ManageInventoryStateStatus status,
  }) = _ManageInventoryState;
}
