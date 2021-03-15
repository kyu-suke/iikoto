import 'package:flutter/material.dart';
import 'pages/root_page.dart';
import 'package:iikoto/services/navigation_service.dart';
import 'package:iikoto/settings/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 10,
          selectedLabelStyle: TextStyle(
            color: Colors.blue,
            fontSize: 11,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11,
          ),
          selectedItemColor: Colors.blue,
        ),
      ),
      home: RootPage(),
      navigatorKey: NavigationService.getInstance().rootNavigatorKey,
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
