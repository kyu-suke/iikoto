import 'package:flutter/material.dart';

enum TabItem {
  count,
  graph,
  calendar,
}

const TabItemInfo = <TabItem, Map>{
  TabItem.count: {
    'icon': Icons.add,
    'label': 'count',
    'routerName': '/count',
  },
  TabItem.graph: {
    'icon': Icons.show_chart,
    'label': 'graph',
    'routerName': '/graph',
  },
  TabItem.calendar: {
    'icon': Icons.calendar_today_outlined,
    'label': 'calendar',
    'routerName': '/calendar',
  },
};
