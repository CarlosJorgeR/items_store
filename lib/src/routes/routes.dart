import 'package:flutter/material.dart';
import 'package:price_calculator/src/pages/home_page.dart';
import 'package:price_calculator/src/pages/item_page.dart';

class RoutePaths {
  static const Start = '/';
  static const Add = '/add';
  static const Edit = '/edit';
}

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Start:
        return MaterialPageRoute(builder: (_) => HomePage());
      case RoutePaths.Add:
        return MaterialPageRoute(builder: (_) => ItemPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
