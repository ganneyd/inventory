import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/core/util/util.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';

part 'add_part_state.freezed.dart';

//the different states` the add_part page can be in
enum AddPartStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  creatingData,
  createdDataSuccessfully,
  createdDataUnsuccessfully,
  updatedQuantitySuccessfully,
  updatedQuantityUnsuccessfully,
  searching,
  searched,
  foundMatches,
}

@freezed
class AddPartState with _$AddPartState {
  factory AddPartState({
    PartEntity? part,
    String? error,
    @Default(false) bool isFormValid,
    @Default(UnitOfIssue.EA) UnitOfIssue unitOfIssue,
    @Default(<PartEntity>[]) List<PartEntity> existingParts,
    @Default(AddPartStateStatus.loading) addPartStateStatus,
  }) = _AddPartState;
}
