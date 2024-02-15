import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';

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
    PartEntity? part,
    String? error,
    @Default(PartViewStateStatus.loading)
    PartViewStateStatus partViewStateStatuse,
  }) = _PartViewState;
}
