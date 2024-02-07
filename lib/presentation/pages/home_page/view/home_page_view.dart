import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_v1/presentation/pages/home_page/cubit/home_page_cubit.dart';
import 'package:inventory_v1/presentation/pages/home_page/cubit/home_page_state.dart';
import 'package:inventory_v1/presentation/widgets/widget_bucket.dart';

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
      create: (_) => HomePageCubit(),
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
