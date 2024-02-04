import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/presentation/dependency_check/cubit/dependency_check_cubit.dart';
import 'package:inventory_v1/presentation/dependency_check/cubit/dependency_check_state.dart';

void main() {
  late DependencyCheckCubit sut;

  Future<void> dependencyInjection() async {}

  setUp(() async {
    await dependencyInjection();
    sut = DependencyCheckCubit();
  });

  group('DependencyCubit()', () {
    test('initial state is correct', () {
      expect(sut.state.error, null);
      expect(sut.state.dependencyCheckStateStatus,
          DependencyCheckStateStatus.loading);
    });
  });
}
