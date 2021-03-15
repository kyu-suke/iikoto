import 'package:flutter/material.dart';
import 'package:iikoto/services/navigation_service.dart';
import 'package:iikoto/settings/tab_item.dart';
import 'package:iikoto/widgets/bottom_navigation.dart';
import 'package:iikoto/widgets/tab_navigator.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  Widget _buildTabItem(
    TabItem tabItem,
  ) {
    return Offstage(
      offstage: NavigationService.getInstance().currentTab != tabItem,
      child: TabNavigator(
        navigationKey:
            NavigationService.getInstance().tabNavigatorKeys[tabItem],
        tabItem: tabItem,
        routerName: TabItemInfo[tabItem]['routerName'],
      ),
    );
  }

  Future<bool> onWillPop() async {
    final isFirstRouteInCurrentTab =
        !await NavigationService.getCurrentTabState().maybePop();
    if (isFirstRouteInCurrentTab) {
      if (NavigationService.getInstance().currentTab != TabItem.count) {
        onSelect(TabItem.count);
        return false;
      }
    }
    return isFirstRouteInCurrentTab;
  }

  void onSelect(TabItem tabItem) {
    if (NavigationService.getInstance().currentTab == tabItem) {
      NavigationService.getCurrentTabState().popUntil((route) => route.isFirst);
    } else {
      setState(() {
        NavigationService.getInstance().currentTab = tabItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildTabItem(
            TabItem.count,
          ),
          _buildTabItem(
            TabItem.graph,
          ),
          _buildTabItem(
            TabItem.calendar,
          ),        ],
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: NavigationService.getInstance().currentTab.index,
        onSelect: onSelect,
      ),
    );
  }
}
