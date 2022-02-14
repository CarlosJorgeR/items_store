import 'package:flutter/material.dart';
import 'package:price_calculator/src/pages/price_calculate.dart';
import 'package:price_calculator/src/routes/routes.dart';

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RoutePaths.Start,
      onGenerateRoute: MyRouter.generateRoute,
      home: Center(
        child: PurchasePage(),
        // child: null,
      ),
      // routes: getApplicationsRoutes(_item),
    );
  }
}
