import 'package:badges/badges.dart' as badges;
import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/controllers/notification.controller.dart';
import 'package:fastaval_app/controllers/program.controller.dart';
import 'package:fastaval_app/screens/favorites.screen.dart';
import 'package:fastaval_app/screens/info.screen.dart';
import 'package:fastaval_app/screens/login.screen.dart';
import 'package:fastaval_app/screens/more.screen.dart';
import 'package:fastaval_app/screens/notifications.screen.dart';
import 'package:fastaval_app/screens/profile.screen.dart';
import 'package:fastaval_app/screens/program.screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final appCtrl = Get.find<AppController>();
  final notificationCtrl = Get.find<NotificationController>();
  final programCtrl = Get.find<ProgramController>();

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        notificationCtrl.getNotificationsAndSetWaiting();
        Get.to(() => NotificationsScreen(), transition: Transition.rightToLeft);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        notificationCtrl.getNotificationsAndSetWaiting();
      }
    });

    return NotificationListener(
      onNotification: (notification) {
        if (notification is UserScrollNotification) return false;
        if (notification is OverscrollNotification) return false;
        if (notification is OverscrollIndicatorNotification) return false;

        return false;
      },
      child: Scaffold(
        body: SafeArea(child: Obx(() => _screens()[appCtrl.navIndex.value])),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: appCtrl.navIndex.value,
            onTap: onNavClick,
            items: bottomNavItems(),
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            backgroundColor: colorOrangeDark,
            selectedItemColor: colorBlack,
            unselectedItemColor: Colors.black54,
          ),
        ),
      ),
    );
  }

  onNavClick(int index) {
    appCtrl.updateNavIndex(index);
  }

  bottomNavItems() => [
    appCtrl.loggedIn.value == true
        ? BottomNavigationBarItem(
          activeIcon: Icon(Icons.person),
          icon: Icon(Icons.person_outline),
          label: tr('bottomNavigation.profil'),
        )
        : BottomNavigationBarItem(
          activeIcon: Icon(CupertinoIcons.square_arrow_right_fill),
          icon: Icon(CupertinoIcons.square_arrow_right),
          label: tr('bottomNavigation.login'),
        ),
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.info),
      icon: Icon(Icons.info_outline),
      label: tr('bottomNavigation.information'),
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(Icons.calendar_month),
      icon: Icon(Icons.calendar_month_outlined),
      label: tr('bottomNavigation.program'),
    ),
    BottomNavigationBarItem(
      activeIcon: Icon(CupertinoIcons.heart_fill),
      icon: Icon(CupertinoIcons.heart),
      label: tr('bottomNavigation.favorites'),
    ),
    BottomNavigationBarItem(
      activeIcon: badges.Badge(
        showBadge:
            notificationCtrl.notificationsWaiting.value &&
            notificationCtrl.notificationList.isNotEmpty,
        position: badges.BadgePosition.topEnd(top: -2, end: -2),
        child: Icon(CupertinoIcons.ellipsis_circle_fill),
      ),
      icon: badges.Badge(
        showBadge:
            notificationCtrl.notificationsWaiting.value &&
            notificationCtrl.notificationList.isNotEmpty,
        position: badges.BadgePosition.topEnd(top: -2, end: -2),
        child: Icon(CupertinoIcons.ellipsis_circle),
      ),
      label: tr('bottomNavigation.more'),
    ),
  ];

  List<Widget> _screens() => [
    appCtrl.loggedIn.value == true ? ProfileScreen() : LoginScreen(),
    InfoScreen(),
    ProgramScreen(),
    FavoritesScreen(),
    MoreScreen(),
  ];
}
