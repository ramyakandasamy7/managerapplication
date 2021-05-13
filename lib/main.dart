import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/auth/login.dart';
import 'constants/route_names.dart';
import 'pages/home_page.dart';
import 'pages/add_product.dart';
import 'widgets/app_route_observer.dart';
import 'pages/transaction.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(DemoApp());
}

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Store Manager Website',
      theme: ThemeData(
        textTheme: TextTheme(
            subtitle1: TextStyle(
          color: Color(0xffE7E7E7),
          fontSize: 14,
        )),
        iconTheme:
            new IconThemeData(color: Colors.black, opacity: 1.0, size: 30.0),
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          color: Color(0xffEDEDED),
        ),
        primaryTextTheme: TextTheme(
          title: TextStyle(
            color: Color(0xff73879C),
            fontWeight: FontWeight.bold,
          ),
        ),
        // primaryColor: Color(0xff2A3F54),
        pageTransitionsTheme: PageTransitionsTheme(
          // makes all platforms that can run Flutter apps display routes without any animation
          builders: Map<TargetPlatform,
                  _InanimatePageTransitionsBuilder>.fromIterable(
              TargetPlatform.values.toList(),
              key: (dynamic k) => k,
              value: (dynamic _) => const _InanimatePageTransitionsBuilder()),
        ),
      ),
      initialRoute: RouteNames.login,
      navigatorObservers: [AppRouteObserver()],
      routes: {
        RouteNames.login: (_) => LoginPage(),
        RouteNames.home: (_) => const HomePage(),
        RouteNames.add_product: (_) => ReceiptForm2(),
        RouteNames.check_transaction: (_) => TransactionPage()
      },
    );
  }
}

/// This class is used to build page transitions that don't have any animation
class _InanimatePageTransitionsBuilder extends PageTransitionsBuilder {
  const _InanimatePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return child;
  }
}
