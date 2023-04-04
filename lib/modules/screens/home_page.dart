import 'package:badges/badges.dart' as badges;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/config/models/message.dart';
import 'package:fastaval_app/config/models/user.dart';
import 'package:fastaval_app/constants/style_constants.dart';
import 'package:fastaval_app/modules/screens/boardgames_page.dart';
import 'package:fastaval_app/modules/screens/info_screen.dart';
import 'package:fastaval_app/modules/screens/login_screen.dart';
import 'package:fastaval_app/modules/screens/notifications_screen.dart';
import 'package:fastaval_app/modules/screens/profile_screen.dart';
import 'package:fastaval_app/modules/screens/program_screen.dart';
import 'package:fastaval_app/utils/services/config_service.dart';
import 'package:fastaval_app/utils/services/messages_service.dart';
import 'package:fastaval_app/utils/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../notifications/login_notification.dart';

class HomePageState extends State<HomePageView> {
  late List<BottomNavigationBarItem> _bottomNavList = _bottomNavItems();
  late User? _user;
  late List<Message> _messages;
  bool _loggedIn = false;
  int _currentIndex = 1;
  int _waitingMessages = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List mapImgList = [
    Image.asset('assets/images/Mariagerfjord_kort_23.png'),
    Image.asset('assets/images/Hobro_Idraetscenter_kort_23.png'),
  ];
  void _openDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          _getMessages();
          _waitingMessages = 1;
          _bottomNavList = _bottomNavItems();
        });
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          _getMessages();
          _waitingMessages = 1;
          _bottomNavList = _bottomNavItems();
        });
      }
    });

    return NotificationListener(
      onNotification: (notification) {
        if (notification is UserNotification) {
          setState(() {
            if (_loggedIn == false && notification.loggedIn == true) {
              _getMessages();
            }
            if (notification.loggedIn == false) {
              _waitingMessages = 0;
            }
            _loggedIn = notification.loggedIn;
            _user = notification.user;
            _bottomNavList = _bottomNavItems();
          });
        }
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(child: _screens()[_currentIndex]),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: _bottomNavList,
        ),
        endDrawer: drawMenu(context),
      ),
    );
  }

  @override
  initState() {
    ConfigService().initConfig();
    _getUser();
    _getMessages();
    super.initState();
  }

  void onTabTapped(int index) {
    if (index == 3) {
      _openDrawer();
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  List<BottomNavigationBarItem> _bottomNavItems() {
    return <BottomNavigationBarItem>[
      if (_loggedIn == true)
        BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: tr('bottomNavigation.profil')),
      if (_loggedIn == false)
        BottomNavigationBarItem(
            icon: const Icon(Icons.login), label: tr('bottomNavigation.login')),
      BottomNavigationBarItem(
          icon: const Icon(Icons.info),
          label: tr('bottomNavigation.information')),
      BottomNavigationBarItem(
          icon: const Icon(Icons.calendar_view_day),
          label: tr('bottomNavigation.program')),
      BottomNavigationBarItem(
          icon: badges.Badge(
              showBadge: _waitingMessages > 0,
              badgeContent: Text("$_waitingMessages"),
              child: const Icon(Icons.menu_open)),
          label: tr('bottomNavigation.more'))
    ];
  }

  Future _getMessages() async {
    var messages = await fetchMessages();
    setState(() {
      _messages = messages;
    });
  }

  Future _getUser() async {
    await UserService()
        .getUser()
        .then((newUser) => {_user = newUser, _loggedIn = true});

    setState(() {
      _bottomNavList = _bottomNavItems();
    });
  }

  List<Widget> _screens() {
    return <Widget>[
      if (_loggedIn && _user != null) ProfileScreen(user: _user!),
      if (!_loggedIn) LoginScreen(this),
      const InfoScreen(),
      const Programscreen(),
    ];
  }

  Drawer drawMenu(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: SafeArea(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: backgroundBoxDecorationStyle,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: [
                    buildIdIcon(),
                    Text(
                      tr('profile.participantNumber'),
                      style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ])
                ],
              ),
            ),
            if (_loggedIn)
              ListTile(
                leading: badges.Badge(
                    showBadge: _waitingMessages > 0,
                    child: const Icon(Icons.mail)),
                title: Text(tr('drawer.messages'),
                    style: const TextStyle(fontSize: 18)),
                onTap: () => setState(() {
                  Navigator.of(context).pop();
                  _waitingMessages = 0;
                  _bottomNavList = _bottomNavItems();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationsScreen(messages: _messages),
                    ),
                  );
                }),
              ),
            ListTile(
              leading: const Icon(Icons.sports_esports),
              title: Text(tr('drawer.boardgames'),
                  style: const TextStyle(fontSize: 18)),
              onTap: () => setState(() {
                Navigator.of(context).pop();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BoardGamePage()));
              }),
            ),
            ListTile(
                leading: const Icon(Icons.school),
                title: Text(tr('drawer.mapSchool'),
                    style: const TextStyle(fontSize: 18)),
                onTap: () => {
                      Navigator.of(context).pop(),
                      fastaMap(
                        context,
                        const AssetImage(
                            'assets/images/Mariagerfjord_kort_23.png'),
                      )
                    }),
            ListTile(
                leading: const Icon(Icons.sports_tennis),
                title: Text(tr('drawer.mapGym'),
                    style: const TextStyle(fontSize: 18)),
                onTap: () => {
                      Navigator.of(context).pop(),
                      fastaMap(
                          context,
                          const AssetImage(
                              'assets/images/Hobro_Idraetscenter_kort_23.png'))
                    }),
            const SizedBox(height: 60),
            if (_loggedIn)
              ListTile(
                  leading: const Icon(CupertinoIcons.barcode),
                  title: Text(tr('drawer.barcode'),
                      style: const TextStyle(fontSize: 18)),
                  onTap: () => {
                        Navigator.of(context).pop(),
                        UserService()
                            .getUser()
                            .then((user) => barcode(context, user))
                      }),
            ListTile(
                leading: const Icon(Icons.close),
                title: Text(tr('drawer.close'),
                    style: const TextStyle(fontSize: 18)),
                onTap: () => Navigator.of(context).pop()),
          ],
        ),
      ),
    );
  }

  Future<dynamic> barcode(BuildContext context, User user) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Center(
              child: RotatedBox(
                quarterTurns: 1,
                child: BarcodeWidget(
                  barcode: Barcode.ean8(),
                  data: user.barcode.toString(),
                ),
              ),
            ),
          );
        });
  }

  Future fastaMap(BuildContext context, AssetImage image) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(children: [
            PhotoView(
              imageProvider: image,
            ),
            Positioned(
                right: 10,
                top: 10,
                child: Material(
                  color: Colors.transparent,
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.black,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ))
          ]);
        });
  }

  Widget buildIdIcon() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration:
              const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: !_loggedIn
              ? Image.asset('assets/images/penguin_logo.jpg', height: 68)
              : Text(
                  "${_user?.id}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 58,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans'),
                ),
        ),
      ],
    );
  }
}

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}
