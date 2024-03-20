import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';

part 'home_page_state.freezed.dart';

//the different states the add_part page can be in
enum HomePageStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
  loggingIn,
  loggingInSuccess,
  loggingInFailure,
  creatingUser,
  createdUserSuccessfully,
  createdUserUnsuccessfully,
}

@freezed
class HomePageState with _$HomePageState {
  factory HomePageState({
    UserEntity? authenticatedUser,
    String? error,
    @Default(HomePageStateStatus.loading) HomePageStateStatus status,
  }) = _HomePageState;
}
