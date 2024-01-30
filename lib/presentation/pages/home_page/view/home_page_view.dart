import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/data/repositories/part_repository_implementation.dart';
import 'package:inventory_v1/presentation/pages/home_page/cubit/home_page_cubit.dart';
import 'package:inventory_v1/presentation/pages/home_page/cubit/home_page_state.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';
import 'package:inventory_v1/service_locator.dart';

class HomePageView extends StatelessWidget {
  HomePageView()
      : _scaffoldKey = GlobalKey(debugLabel: 'part-home-scaffold'),
        super(key: const Key('part-home-page'));
  final GlobalKey<ScaffoldState> _scaffoldKey;

  void searchCallback() {}

  final TextEditingController controller = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomePageCubit>(
      create: (_) => HomePageCubit(
          partRepository: locator<PartRepositoryImplementation>()),
      child: BlocBuilder<HomePageCubit, HomePageState>(
        builder: (context, state) {
          return Scaffold(
            key: _scaffoldKey,
            body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomSearchBar(
                    textFieldKey: const Key('home-page-search-bar'),
                    controller: controller,
                    onPressed: searchCallback,
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
                          onPressed: () => Navigator.of(context)
                              .pushNamed('/manage_inventory')),
                    ],
                  )
                ]),
          );
        },
      ),
    );
  }
}
