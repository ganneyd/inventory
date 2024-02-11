import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:inventory_v1/presentation/dependency_check/cubit/dependency_check_cubit.dart';
import 'package:inventory_v1/presentation/dependency_check/cubit/dependency_check_state.dart';
import 'package:inventory_v1/presentation/widgets/loading_widget.dart';
import 'package:inventory_v1/route_generator.dart';
import 'package:inventory_v1/service_locator.dart';
import 'package:inventory_v1/theme.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

class App extends StatelessWidget {
  const App() : super(key: const Key('app-view'));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData,
      title: 'Inventory',
      home: BlocProvider<DependencyCheckCubit>(
        create: (_) => DependencyCheckCubit(
            pathProviderPlatform: PathProviderPlatform.instance,
            isHiveInitialized: Hive.isBoxOpen(boxName),
            sl: locator)
          ..checkDependencies(),
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
                    ? const Text('The following couldnt be loaded')
                    : const LoadingView());
          },
        ),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
