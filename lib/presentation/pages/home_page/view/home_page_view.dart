import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/core/util/rank_enum.dart';
import 'package:inventory_v1/core/util/view_right_enum.dart';
import 'package:inventory_v1/domain/usecases/authentication/login_usecase.dart';
import 'package:inventory_v1/domain/usecases/usecases_bucket.dart';
import 'package:inventory_v1/presentation/pages/home_page/cubit/home_page_cubit.dart';
import 'package:inventory_v1/presentation/pages/home_page/cubit/home_page_state.dart';
import 'package:inventory_v1/presentation/pages/home_page/view/auth_dialog.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';
import 'package:inventory_v1/service_locator.dart';

class HomePageView extends StatelessWidget {
  HomePageView()
      : _scaffoldKey = GlobalKey(debugLabel: 'part-home-scaffold'),
        super(key: const Key('part-home-page'));
  final GlobalKey<ScaffoldState> _scaffoldKey;

  void searchCallback(context) {
    if (controller.text.isNotEmpty) {
      Navigator.of(context)
          .pushNamed('/search_parts', arguments: controller.text);
    }
  }

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomePageCubit>(
      create: (_) => HomePageCubit(
          createUserUsecase: locator<CreateUserUsecase>(),
          loginUsecase: locator<LoginUsecase>()),
      child: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (context, state) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            if (state.status == HomePageStateStatus.loggingInFailure) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  duration: Durations.long1,
                  content: Center(
                    child: Center(
                      child: Text('${state.error}'),
                    ),
                  )));
            }

            if (state.status == HomePageStateStatus.loggingInSuccess &&
                state.authenticatedUser != null) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 4),
                  content: Center(
                    child: Center(
                      child: Text(
                          'Successfully logged in, Welcome ${state.error}'),
                    ),
                  )));

              Navigator.of(context).pushNamed('/manage_inventory',
                  arguments: state.authenticatedUser);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 4),
                  content: Center(
                    child: Center(
                      child: Text('Failed to get profile'),
                    ),
                  )));
            }
            if (state.status == HomePageStateStatus.createdUserSuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 4),
                  content: Center(
                    child: Center(
                      child: Text('Created user profile ${state.error}'),
                    ),
                  )));
            }
            if (state.status == HomePageStateStatus.createdUserUnsuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                  content: Center(
                    child: Center(
                      child: Text('Failed to create profile: ${state.error}'),
                    ),
                  )));
            }
          });
          return Scaffold(
            key: _scaffoldKey,
            body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomSearchBar(
                    textFieldKey: const Key('home-page-search-bar'),
                    controller: controller,
                    onPressed: () => searchCallback(context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      LargeButton(
                          key: const Key('add-part-btn'),
                          buttonName: 'Add Part',
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/add_part')),
                      LargeButton(
                          key: const Key('manage-inv-btn'),
                          buttonName: 'Manage Inventory',
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return BlocProvider.value(
                                    value:
                                        BlocProvider.of<HomePageCubit>(context),
                                    child: BlocListener<HomePageCubit,
                                        HomePageState>(
                                      listener: (context, state) {
                                        if (state.status ==
                                            HomePageStateStatus
                                                .loggingInSuccess) {
                                          Navigator.pop(
                                              dialogContext); // Close the dialog
                                        }
                                      },
                                      child: AuthDialog(
                                          onSubmit: (
                                                  {required String firstName,
                                                  required String lastName,
                                                  required String password,
                                                  required RankEnum rankEnum,
                                                  required List<ViewRightsEnum>
                                                      viewRights}) =>
                                              BlocProvider.of<HomePageCubit>(
                                                      context)
                                                  .signUpUser(
                                                      firstName: firstName,
                                                      lastName: lastName,
                                                      rankEnum: rankEnum,
                                                      viewRights: viewRights,
                                                      password: password),
                                          onLogin: (
                                                  {required String username,
                                                  required String password}) =>
                                              BlocProvider.of<HomePageCubit>(
                                                      context)
                                                  .login(
                                                      username: username,
                                                      password: password)),
                                    ),
                                  );
                                });
                          }),
                    ],
                  )
                ]),
          );
        },
      ),
    );
  }
}
