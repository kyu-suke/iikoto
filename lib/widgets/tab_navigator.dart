import 'package:flutter/material.dart';
import 'package:iikoto/settings/routes.dart';
import 'package:iikoto/settings/tab_item.dart';

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    Key key,
    @required this.tabItem,
    @required this.routerName,
    @required this.navigationKey,
  }) : super(key: key);

  final TabItem tabItem;
  final String routerName;
  final GlobalKey<NavigatorState> navigationKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigationKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute<Widget>(
          builder: (context) {
            return Routes.routes[routerName](context);
          },
        );
      },
    );
  }
}
