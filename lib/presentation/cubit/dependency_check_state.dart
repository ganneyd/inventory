import 'package:freezed_annotation/freezed_annotation.dart';

part 'dependency_check_state.freezed.dart';

//the different states the add_part page can be in
enum DependencyCheckStateStatus {
  loading,
  loadedSuccessfully,
  loadedUnsuccessfully,
}

@freezed
class DependencyCheckState with _$DependencyCheckState {
  factory DependencyCheckState({
    String? error,
    @Default(DependencyCheckStateStatus.loading)
    DependencyCheckStateStatus dependencyCheckStateStatus,
  }) = _DependencyCheckState;
}
