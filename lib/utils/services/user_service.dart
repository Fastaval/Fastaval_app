import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/utils/dialogs/customTrackingDialog.dart';
import 'package:fastaval_app/utils/services/config_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/models/user.dart';
import 'local_storage_service.dart';

final String baseUrl = ConfigService().getRemoteConfig('API');

class UserService {
  static const String kUserKey = 'USER_KEY';
  final LocalStorageService storageService = LocalStorageService();

  Future<User> getUser() async {
    String userString = await storageService.getString(kUserKey);
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

  refreshUser() {
    print('refreshing user');
  }

  removeUser() {
    storageService.deleteString(kUserKey);
  }

  registerToInfosys(BuildContext context, User user) {
    registerAppToInfosys(context, user);
  }
}

Future<void> registerAppToInfosys(BuildContext context, User user) async =>
    await showDialog<void>(
        context: context,
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
                  }),
              ElevatedButton(
                  child: Text(tr('login.alert.dialogYes')),
                  onPressed: () {
                    sendFCMTokenToInfosys(user.id!);
                    askForTrackingPermission(context);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });

Future<User> fetchUser(String userId, String password) async {
  var response =
      await http.get(Uri.parse('$baseUrl/v3/user/$userId?pass=$password'));

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  }

  throw Exception('Failed to load login');
  //TODO: Vis fejl hvis login fejler
}

Future<void> sendFCMTokenToInfosys(int userId) async {
  String token = await getDeviceToken();
  var response = await http.post(Uri.parse('$baseUrl/user/$userId/register'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'gcm_id': token}));

  if (response.statusCode != 200) {
    throw Exception('Failed to register app with infosys');
    //TODO: Vis fejl hvis registering ikke lykkesede
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
