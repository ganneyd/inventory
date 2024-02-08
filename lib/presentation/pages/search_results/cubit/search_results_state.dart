import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/data/entities/part/part_entity.dart';

part 'search_results_state.freezed.dart';

//the different states the add_part page can be in
enum SearchResultsStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  searchUnsuccessful,
  searchSuccessful,
  searchNotFound,
  textFieldEmpty,
  textFieldNotEmpty,
}

@freezed
class SearchResultsState with _$SearchResultsState {
  factory SearchResultsState({
    required ScrollController scrollController,
    @Default(<PartEntity>[]) List<PartEntity> partsByName,
    @Default(<PartEntity>[]) List<PartEntity> partsByNsn,
    @Default(<PartEntity>[]) List<PartEntity> partsBySerialNumber,
    @Default(<PartEntity>[]) List<PartEntity> partsByPartNumber,
    required TextEditingController searchBarController,
    @Default('no-error') String error,
    @Default(SearchResultsStateStatus.loading) SearchResultsStateStatus status,
  }) = _SearchResultsState;
}
