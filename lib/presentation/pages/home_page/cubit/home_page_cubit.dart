import 'package:bloc/bloc.dart';
import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/entities/user/user_entity.dart';
import 'package:inventory_v1/domain/usecases/authentication/login_usecase.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/home_page/cubit/home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit(
      {required CreateUserUsecase createUserUsecase,
      required LoginUsecase loginUsecase})
      : _createUserUsecase = createUserUsecase,
        _loginUsecase = loginUsecase,
        super(HomePageState());

  final CreateUserUsecase _createUserUsecase;
  final LoginUsecase _loginUsecase;

  void login({required String username, required String password}) async {
    emit(state.copyWith(status: HomePageStateStatus.loggingIn));

    var results = await _loginUsecase
        .call(LoginParams(username: username, password: password));
    results.fold(
        (l) => emit(state.copyWith(
            error: l.errorMessage,
            status: HomePageStateStatus.loggingInFailure)),
        (r) => emit(state.copyWith(
            authenticatedUser: r,
            error: 'user logged in ${r.username}',
            status: HomePageStateStatus.loggingInSuccess)));
  }

  void signUpUser(
      {required String firstName,
      required String lastName,
      required RankEnum rankEnum,
      required List<ViewRightsEnum> viewRights,
      required String password}) async {
    emit(state.copyWith(status: HomePageStateStatus.creatingUser));
    var createUserResults = await _createUserUsecase.call(CreateUserParams(
        userEntity: UserEntity(
            firstName: firstName,
            lastName: lastName,
            rank: rankEnum,
            viewRights: [
              ViewRightsEnum.parts,
              ViewRightsEnum.orders,
              ViewRightsEnum.verify,
              ViewRightsEnum.admin
            ],
            password: password,
            username: '')));
    createUserResults.fold(
        (l) => emit(state.copyWith(
            status: HomePageStateStatus.createdUserUnsuccessfully,
            error: l.errorMessage)),
        (r) => emit(state.copyWith(
            status: HomePageStateStatus.createdUserSuccessfully,
            error: 'Created user with username $firstName.$lastName')));
  }
}
