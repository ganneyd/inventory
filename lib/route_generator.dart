import 'package:flutter/material.dart';
import 'package:inventory_v1/domain/entities/checked-out/cart_check_out_entity.dart';
import 'package:inventory_v1/presentation/pages/add_part/view/add_part_view.dart';
import 'package:inventory_v1/presentation/pages/checkout/view/checkout_view.dart';
import 'package:inventory_v1/presentation/pages/home_page/view/home_page_view.dart';
import 'package:inventory_v1/presentation/pages/manage_inventory/view/manage_inventory_view.dart';
import 'package:inventory_v1/presentation/pages/search_results/view/search_results_view.dart';

class RouteGenerator {
  static MaterialPageRoute getRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home_page':
        return MaterialPageRoute(builder: (_) => HomePageView());
      case '/add_part':
        return getRoute(const AddPartView());
      case '/manage_inventory':
        return getRoute(ManageInventory());
      case '/search_parts':
        final String searchKey = settings.arguments as String;
        return getRoute(SearchResults(
            textEditingController: TextEditingController(text: searchKey)));

      case '/checkout':
        final List<CartCheckoutEntity> checkoutItems =
            settings.arguments == null
                ? []
                : settings.arguments as List<CartCheckoutEntity>;

        return getRoute(CheckOutView(checkoutItems));
      default:
        return _errorRoute(settings.name);
    }
  }

  ///Default Error page
  static Route<dynamic> _errorRoute(String? page) {
    return MaterialPageRoute<void>(
        maintainState: false,
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  page ?? 'Error',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color.fromRGBO(255, 85, 51, 1),
              ),
              body: const Center(child: CircularProgressIndicator()));
        });
  }
}
