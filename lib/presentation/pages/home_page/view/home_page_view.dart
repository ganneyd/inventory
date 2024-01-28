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

  void searchCallback() {}

  TextEditingController controller = TextEditingController(text: 'search');
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          body: Column(children: [
            CustomSearchBar(
              controller: controller,
              onPressed: searchCallback,
            ),
            Row(
              children: [
                LargeButton(buttonName: 'Add Part', onPressed: () {}),
                LargeButton(buttonName: 'Manage Inventory', onPressed: () {}),
              ],
            )
          ]),
        );
      },
    );
  }
}
