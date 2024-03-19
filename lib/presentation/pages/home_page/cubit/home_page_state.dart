import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';

part 'home_page_state.freezed.dart';

//the different states the add_part page can be in
enum HomePageStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  loggingIn,
  loggingInSuccess,
  loggingInFailure,
}

@freezed
class HomePageState with _$HomePageState {
  factory HomePageState({
    PartEntity? part,
    String? error,
    @Default(HomePageStateStatus.loading)
    HomePageStateStatus addPartStateStatus,
  }) = _HomePageState;
}
