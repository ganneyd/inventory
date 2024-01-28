import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';

part 'part_view_state.freezed.dart';

//the different states the add_part page can be in
enum PartViewStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  readingPart,
  readPartSuccessfully,
  readPartUnsuccessfully
}

@freezed
class PartViewState with _$PartViewState {
  factory PartViewState({
    Part? part,
    String? error,
    @Default(PartViewStateStatus.loading)
    PartViewStateStatus partViewStateStatuse,
  }) = _PartViewState;
}
