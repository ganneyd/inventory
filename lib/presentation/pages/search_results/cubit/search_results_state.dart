import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/domain/models/part/part_model.dart';

part 'search_results_state.freezed.dart';

//the different states the add_part page can be in
enum SearchResultsStateStatus {
  loading,
  searching,
  loadedSuccessfully,
  loadedUnsuccessfully,
}

@freezed
class SearchResultsState with _$SearchResultsState {
  factory SearchResultsState({
    required ScrollController scrollController,
    @Default(<Part>[]) List<Part> parts,
    @Default('no-error') String error,
    @Default(SearchResultsStateStatus.loading) SearchResultsStateStatus status,
  }) = _SearchResultsState;
}
