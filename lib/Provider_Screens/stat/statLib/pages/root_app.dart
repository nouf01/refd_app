import 'package:refd_app/Provider_Screens/stat/statLib/pages/budget_page.dart';
import 'package:refd_app/Provider_Screens/stat/statLib/pages/create_budge_page.dart';
import 'package:refd_app/Provider_Screens/stat/statLib/pages/daily_page.dart';
import 'package:refd_app/Provider_Screens/stat/statLib/pages/profile_page.dart';
import 'package:refd_app/Provider_Screens/stat/statLib/pages/stats_page.dart';
import 'package:refd_app/Provider_Screens/stat/statLib/theme/colors.dart';
import 'package:refd_app/Provider_Screens/stat/statLib/json/day_month.dart';

import 'package:refd_app/Provider_Screens/stat/statLib/json/budget_json.dart';
import 'package:flutter/material.dart';

import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  List<Widget> pages = [
    DailyPage(),
    StatsPage(),
    BudgetPage(),
    ProfilePage(),
    CreatBudgetPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: getBody(),
        bottomNavigationBar: getFooter(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              selectedTab(4);
            },
            child: Icon(
              Icons.add,
              size: 25,
            ),
            backgroundColor: Colors.pink
            //params
            ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked);
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: pages,
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Ionicons.md_calendar,
      Ionicons.md_stats,
      Ionicons.md_wallet,
      Ionicons.ios_person,
    ];

    return AnimatedBottomNavigationBar(
      activeColor: primary,
      splashColor: secondary,
      inactiveColor: Colors.black.withOpacity(0.5),
      icons: iconItems,
      activeIndex: pageIndex,
      gapLocation: GapLocation.center,
      notchSmoothness: NotchSmoothness.softEdge,
      leftCornerRadius: 10,
      iconSize: 25,
      rightCornerRadius: 10,
      onTap: (index) {
        selectedTab(index);
      },
      //other params
    );
  }

  selectedTab(index) {
    setState(() {
      pageIndex = index;
    });
  }
}
