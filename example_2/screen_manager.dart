import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:example/constants/colors.dart';
import 'package:example/icons/example_icons_icons.dart';
import 'package:example/screens/home_screens/dashboard/dashboard.dart';
import 'package:example/screens/home_screens/profile/profile.dart';
import 'package:example/screens/home_screens/requests/requests.dart';
import 'package:example/screens/home_screens/sites/sites.dart';
import 'package:example/screens/home_screens/subscriptions/subscription.dart';
import 'package:example/screens/home_screens/tasks/tasks.dart';
import 'package:example/screens/home_screens/technicians/technicians.dart';
import 'package:example/screens/home_screens/work_orders/work_orders.dart';
import 'package:example/stores/user_store/user_store.dart';

final Map<Role, List<ScreenManager>> roleWithPages = {
  Role.tenant: [
    _dashboard,
    _requests,
    _profile,
  ],
  Role.client: [
    _dashboard,
    _requests,
    _tasks,
    _subscriptions,
    _profile,
  ],
  Role.manager: [
    _dashboard,
    _requests,
    _workOrder,
    _tasks,
    _sites,
    _technicians,
  ],
  Role.technician: [
    _dashboard,
    _workOrder,
    _tasks,
    _profile,
  ],
};

final _dashboard = ScreenManager(
  title: 'Dashboard',
  bottomItem: BottomNavigationBarItem(
    icon: Icon(ExampleIcons.home),
    title: Text('Home'),
  ),
  screen: DashboardScreen(),
);

final _requests = ScreenManager(
  title: 'Requests',
  bottomItem: BottomNavigationBarItem(
    icon: Icon(ExampleIcons.request),
    title: Text("Requests"),
  ),
  screen: RequestsScreen(),
);

final _workOrder = ScreenManager(
  title: 'Work Order',
  bottomItem: BottomNavigationBarItem(
    icon: SvgPicture.asset('svgs/work-order.svg'),
    activeIcon: SvgPicture.asset(
      'svgs/work-order.svg',
      color: GKColors.green,
    ),
    title: Text("Work"),
  ),
  screen: WorkOrdersPage(),
);

final _sites = ScreenManager(
  title: 'Sites',
  bottomItem: BottomNavigationBarItem(
    icon: Icon(ExampleIcons.building),
    title: Text("Sites"),
  ),
  screen: SitesScreen(),
);

final _tasks = ScreenManager(
  title: 'Tasks',
  bottomItem: BottomNavigationBarItem(
    icon: Icon(ExampleIcons.tasks),
    title: Text("Tasks"),
  ),
  screen: TasksScreen(),
);

final _subscriptions = ScreenManager(
  title: 'Subsciptions',
  bottomItem: BottomNavigationBarItem(
    icon: Icon(ExampleIcons.subscription),
    title: Text("Subsciptions"),
  ),
  screen: SubscriptionScreen(),
);

final _profile = ScreenManager(
  title: 'My Profile',
  bottomItem: BottomNavigationBarItem(
    icon: Icon(ExampleIcons.profile),
    title: Text('Profile'),
  ),
  screen: ProfileScreen(),
);

final _technicians = ScreenManager(
  title: 'Technicians',
  bottomItem: BottomNavigationBarItem(
    icon: Icon(ExampleIcons.service),
    title: Text('Technicians'),
  ),
  screen: TechniciansScreen(),
);

class ScreenManager {
  final String title;
  final Widget screen;
  final BottomNavigationBarItem bottomItem;

  ScreenManager({
    @required this.title,
    @required this.screen,
    @required this.bottomItem,
  });
}
