import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/domain/models/part/part_model.dart';

part 'home_page_state.freezed.dart';

//the different states the add_part page can be in
enum HomePageStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  searchingParts,
  searchSuccessful,
  searchUnsuccessful
}

@freezed
class HomePageState with _$HomePageState {
  factory HomePageState({
    Part? part,
    String? error,
    @Default(HomePageStateStatus.loading)
    HomePageStateStatus addPartStateStatus,
  }) = _HomePageState;
}
