import 'package:flutter/material.dart';
import 'package:iikoto/pages/calendar.dart';
import 'package:iikoto/pages/calendar_detail.dart';
import 'package:iikoto/pages/chart.dart';
import 'package:iikoto/pages/count.dart';
import 'package:iikoto/settings/screen_arguments.dart';
import 'package:iikoto/pages/root_page.dart';

class Routes {
  static final RouteFactory onGenerateRoute = (RouteSettings settings) {
    final ScreenArguments arg = settings.arguments;

    if (settings.name == '/calendar_detail') {
      return MaterialPageRoute(
        builder: (context) => CalendarDetailPage(
          arguments: arg,
        ),
        fullscreenDialog: arg.fullscreenDialog,
      );
    } else if (Routes.routes.keys.contains(settings.name)) {
      return MaterialPageRoute(
        builder: routes[settings.name],
      );
    } else {
      throw Exception('invalid route');
    }
  };

  static final Map<String, WidgetBuilder> routes = {
    '/': (context) => RootPage(),
    '/count': (context) => CountPage(),
    '/graph': (context) => LineChartPage(),
    '/calendar': (context) => CalendarPage(),
  };
}
