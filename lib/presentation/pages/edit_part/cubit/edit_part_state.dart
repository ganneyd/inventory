import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';

part 'edit_part_state.freezed.dart';

enum EditPartStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  updating,
  updatedSuccessfully,
  updatedUnsuccessfully,
}

@freezed
class EditPartState with _$EditPartState {
  factory EditPartState({
    required PartEntity partEntity,
    @Default('') String errorMsg,
    @Default(EditPartStateStatus.loading) EditPartStateStatus status,
  }) = _EditPartState;
}
