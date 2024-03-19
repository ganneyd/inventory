import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:inventory_v1/presentation/pages/home_page/cubit/home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit() : super(HomePageState());

  void login({required String user, required String password}) async {
    emit(state.copyWith(addPartStateStatus: HomePageStateStatus.loggingIn));

    await Future.delayed(Durations.medium2);
    emit(state.copyWith(
        addPartStateStatus: HomePageStateStatus.loggingInSuccess, error: user));
  }
}
