import 'dart:async';
import 'dart:convert';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/controllers/settings.controller.dart';
import 'package:fastaval_app/models/user.model.dart';
import 'package:fastaval_app/services/config.service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'local_storage.service.dart';

final settingsController = Get.find<SettingsController>();
final appController = Get.find<AppController>();

class UserService {
  static String kUserKey = 'USER_KEY25';
  final LocalStorageService storageService = LocalStorageService();

  Future<User?> getUserFromStorage() async {
    String userString = await storageService.getString(kUserKey);
    if (userString == '') {
      return null;
    }
    try {
      return Future.value(User.fromJson(jsonDecode(userString)));
    } catch (error) {
      return Future.error(error);
    }
  }

  setUser(User user) {
    String userString = jsonEncode(user);
    storageService.setString(kUserKey, userString);
  }

  removeUser() {
    storageService.deleteString(kUserKey);
  }

  registerToInfosys(User user) {
    registerAppToInfosys(user);
  }

  Future<void> registerAppToInfosys(User user) async => await showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(tr('login.alert.title')),
            content: Text(tr('login.alert.description')),
            actions: <Widget>[
              TextButton(
                child: Text(tr('login.alert.dialogNo')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text(tr('login.alert.dialogYes')),
                onPressed: () {
                  sendFCMTokenToInfosys(user.id);
                  askForTrackingPermission(context);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
}

Future<User> fetchUser(String userId, String password) async {
  var response = await http.get(
    Uri.parse('$baseUrl/v3/user/$userId?pass=$password'),
  );
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  }
  appController.logout();
  throw Exception('Failed to load login. Logging out');
}

Future<void> sendFCMTokenToInfosys(int userId) async {
  String token = await getDeviceToken();
  var response = await http.post(
    Uri.parse('$baseUrl/user/$userId/register'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({'gcm_id': token}),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to register app with infosys');
  }
}

Future<String> getDeviceToken() async {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  String? deviceToken = await firebaseMessaging.getToken();
  return (deviceToken == null) ? "" : deviceToken;
}

Future<void> askForTrackingPermission(BuildContext context) async {
  final TrackingStatus status =
      await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.notDetermined) {
    await showCustomTrackingDialog(context);
    await Future.delayed(Duration(milliseconds: 200));
    await AppTrackingTransparency.requestTrackingAuthorization();
  }
}

showCustomTrackingDialog(BuildContext context) async => await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr('login.permissionsWarning.title')),
        content: Text(tr('login.permissionsWarning.description')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('common.close')),
          ),
        ],
      ),
    );
