import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:first_app/core/store.dart';
import 'package:first_app/pages/cart_page.dart';
import 'package:first_app/pages/home_detail_page.dart';
import 'package:first_app/pages/login_page.dart';
import 'package:first_app/pages/signup_page.dart';
import 'package:first_app/utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:url_strategy/url_strategy.dart';
import 'pages/home_page.dart';
import 'widgets/themes.dart';

void main() {
  setPathUrlStrategy(); // Remove # from URLs
  runApp(VxState(store: MyStore(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => CartPage(),
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final id = state.queryParams['id'];
          final catalog =
              (VxState.store as MyStore).catalog.getById(int.parse(id!));
          return HomeDetailPage(catalog: catalog);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
