import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:inventory_v1/presentation/dependency_check/cubit/dependency_check_cubit.dart';
import 'package:inventory_v1/presentation/dependency_check/cubit/dependency_check_state.dart';
import 'package:mocktail/mocktail.dart';

class MockGetIt extends Mock implements GetIt {}

void main() {
  late DependencyCheckCubit sut;
  late MockGetIt mockGetIt;
  Future<void> dependencyInjection() async {
    mockGetIt = MockGetIt();
  }

  setUp(() async {
    await dependencyInjection();
    sut = DependencyCheckCubit(isHiveInitialized: true, sl: mockGetIt);
  });

  group('DependencyCubit()', () {
    test('initial state is correct', () {
      expect(sut.state.isHiveOpen, false);
      expect(sut.state.isServiceLocatorOpen, false);
      expect(sut.state.isPartRepoInit, false);
      expect(sut.state.isPathAccessible, false);
      expect(sut.state.isUsecasesInit, false);
      expect(sut.state.dependencyCheckStateStatus,
          DependencyCheckStateStatus.loading);
    });

    test('hive ism not opened', () async {
//setups
      expectLater(sut.stream.map((state) => state),
          emitsInOrder([DependencyCheckState()]));
      await sut.checkDependencies();
    });
  });
}
