import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:example/components/app_app_bar/gk_bar.dart';
import 'package:example/constants/colors.dart';
import 'package:example/screens/home_screens/screen_manager.dart';
import 'package:example/stores/index.dart';
import 'package:example/stores/user_store/user_store.dart';

class HomeScreen extends StatefulWidget {
  static final String name = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _curIndex = 0;
  List<ScreenManager> _screens;

  @override
  void initState() {
    super.initState();
    loadStores();
    _screens = roleWithPages[userStore.role];
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: GKAppBar(
          context: context,
          title: _screens[_curIndex].title,
          withLogOut: userStore.role == Role.manager,
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black87,
          selectedItemColor: GKColors.green,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: _screens.map((pageManager) => pageManager.bottomItem).toList(),
          currentIndex: _curIndex,
          onTap: (index) {
            setState(() {
              _curIndex = index;
            });
          },
        ),
        body: IndexedStack(
          index: _curIndex,
          children: _screens.map((pageManager) => pageManager.screen).toList(),
        ),
      ),
    );
  }
}
