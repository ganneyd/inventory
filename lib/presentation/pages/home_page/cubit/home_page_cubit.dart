import 'package:bloc/bloc.dart';
import 'package:inventory_v1/domain/repositories/part_repository.dart';
import 'package:inventory_v1/presentation/pages/home_page/cubit/home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit({required PartRepository partRepository})
      : super(HomePageState());
}
