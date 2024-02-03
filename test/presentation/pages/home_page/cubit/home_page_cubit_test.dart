import 'package:flutter_test/flutter_test.dart';
import 'package:inventory_v1/presentation/pages/home_page/cubit/home_page_cubit.dart';
import 'package:inventory_v1/presentation/pages/home_page/cubit/home_page_state.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late HomePageCubit homePageCubit;

  setUp(() {
    homePageCubit = HomePageCubit();
  });
  group('HomePageCubit()', () {
    test('initial state is correct', () {
      expect(homePageCubit.state, HomePageState());
      homePageCubit.close();
    });
  });
}
