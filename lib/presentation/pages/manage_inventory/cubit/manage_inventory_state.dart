import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/domain/entities/part_order/order_entity.dart';

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
  verifiedPartUnsuccessfully,
  creatingPartOrder,
  createdPartOrderSuccessfully,
  createdPartOrderUnsuccessfully,
  deletingPartOrder,
  deletedPartOrderSuccessfully,
  deletedPartOrderUnsuccessfully,
  updatingData,
  updatedDataSuccessfully,
  updatedDataUnsuccessfully,
}

@freezed
class ManageInventoryState with _$ManageInventoryState {
  factory ManageInventoryState({
    @Default(20) int fetchPartAmount,
    @Default(<PartEntity>[]) List<PartEntity> allParts,
    @Default(<CheckedOutEntity>[]) List<CheckedOutEntity> newlyVerifiedParts,
    @Default(<CheckedOutEntity>[]) List<CheckedOutEntity> checkedOutParts,
    @Default(<OrderEntity>[]) List<OrderEntity> allPartOrders,
    @Default(<OrderEntity>[]) List<OrderEntity> newlyFulfilledPartOrders,
    @Default('no error') error,
    @Default(ManageInventoryStateStatus.loading)
    ManageInventoryStateStatus status,
  }) = _ManageInventoryState;
}
