import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/presentation/cubit/dependency_check_cubit.dart';
import 'package:inventory_v1/presentation/cubit/dependency_check_state.dart';
import 'package:inventory_v1/presentation/widgets/loading_widget.dart';
import 'package:inventory_v1/route_generator.dart';

class App extends StatelessWidget {
  const App() : super(key: const Key('app-view'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory',
      home: BlocProvider<DependencyCheckCubit>(
        create: (_) => DependencyCheckCubit(),
        child: BlocBuilder<DependencyCheckCubit, DependencyCheckState>(
          builder: (context, state) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (state.dependencyCheckStateStatus ==
                  DependencyCheckStateStatus.loadedSuccessfully) {
                Navigator.of(context).pushNamed('/home_page');
              }
            });

            return Scaffold(
                body: state.dependencyCheckStateStatus ==
                        DependencyCheckStateStatus.loadedUnsuccessfully
                    ? Text(state.error != null ? state.error! : ' ')
                    : const LoadingView());
          },
        ),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
