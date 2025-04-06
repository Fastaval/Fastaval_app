import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/controllers/boardgame.controller.dart';
import 'package:fastaval_app/controllers/notification.controller.dart';
import 'package:fastaval_app/controllers/program.controller.dart';
import 'package:fastaval_app/controllers/settings.controller.dart';
import 'package:fastaval_app/screens/home.screen.dart';
import 'package:fastaval_app/services/config.service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  await ConfigService.instance.initConfig();
  tz.initializeTimeZones();

  await Get.put(SettingsController()).init();
  await Get.put(AppController()).init();
  await Get.put(ProgramController()).init();
  await Get.put(BoardGameController()).init();
  await Get.put(NotificationController()).init();

  runApp(
    EasyLocalization(
      startLocale: Locale(Get.find<SettingsController>().language.value),
      supportedLocales: [Locale('da'), Locale('en')],
      path: 'assets/translations',
      useOnlyLangCode: true,
      fallbackLocale: Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setting the top bar in system to same color as app
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: colorOrangeDark,
        statusBarColor: colorOrangeDark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    // Setting app only portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    Get.find<SettingsController>().setContext(context);

    return GetMaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: Locale(Get.find<SettingsController>().language.value),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange, fontFamily: 'Roboto'),
      home: UpgradeAlert(child: HomeScreen()),
    );
  }
}
