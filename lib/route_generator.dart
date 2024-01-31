import 'package:flutter/material.dart';
import 'package:inventory_v1/presentation/pages/add_part/view/add_part_view.dart';
import 'package:inventory_v1/presentation/pages/home_page/view/home_page_view.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/manage_inventory_view.dart';

class RouteGenerator {
  static MaterialPageRoute getRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home_page':
        return getRoute(HomePageView());
      case '/add_part':
        return getRoute(const AddPartView());
      case '/manage_inventory':
        return getRoute(ManageInventory());
      default:
        return _errorRoute(settings.name);
    }
  }

  ///Default Error page
  ///TODO IMPLEMENT OTHER ERROR PAGES such as network err etc
  static Route<dynamic> _errorRoute(String? page) {
    return MaterialPageRoute<void>(
        maintainState: false,
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  page ?? 'Error',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color.fromRGBO(255, 85, 51, 1),
              ),
              body: const Center(child: CircularProgressIndicator()));
        });
  }
}
