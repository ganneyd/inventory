import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';

part 'add_part_state.freezed.dart';

//the different states the add_part page can be in
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
    Part? part,
    String? error,
    @Default(AddPartStateStatus.loading) AddPartStateStatus addPartStateStatus,
  }) = _AddPartState;
}
