import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';

part 'search_results_state.freezed.dart';

//the different states the add_part page can be in
enum SearchResultsStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  creatingData,
  createdDataSuccessfully,
  createdDataUnsuccessfully
}

@freezed
class SearchResultsState with _$SearchResultsState {
  factory SearchResultsState({
    Part? part,
    String? error,
    @Default(SearchResultsStateStatus.loading)
    SearchResultsStateStatus searchResultsStateStatus,
  }) = _SearchResultsState;
}
