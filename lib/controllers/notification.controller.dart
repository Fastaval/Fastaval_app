import 'dart:convert';

import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/models/notification.model.dart';
import 'package:fastaval_app/services/config.service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {
  RxList notificationList = [].obs;
  RxInt notificationsOnLastClear = 0.obs;
  RxBool notificationsWaiting = false.obs;
  RxInt notificationListUpdatedAt = 0.obs;
  final appController = Get.find<AppController>();

  init() {
    if (appController.loggedIn.value) {
      getNotifications();
    }

    appController.loggedIn.listen((loggedIn) {
      if (loggedIn) {
        getNotifications();
      }
    });
  }

  getNotificationsAndSetWaiting() {
    _fetchNotifications().then(
      (notificationList) => {
        _updateNotificationList(notificationList),
        if (notificationList.isNotEmpty) setNotificationWaiting(),
      },
    );
  }

  getNotifications() {
    _fetchNotifications().then(
      (notificationList) => _updateNotificationList(notificationList),
    );
  }

  setNotificationWaiting() {
    notificationsWaiting(true);
  }

  clearNotificationsWaiting() {
    notificationsOnLastClear(notificationList.length);
    notificationsWaiting(false);
  }

  _updateNotificationList(List<InfosysNotification> notifications) {
    notificationList(notifications);
    notificationListUpdatedAt(
      (DateTime.now().millisecondsSinceEpoch / 1000).round(),
    );
  }

  Future<List<InfosysNotification>> _fetchNotifications() async {
    if (appController.user.id <= 0) {
      return [];
    }

    try {
      var response = await http.get(
        Uri.parse(
          '$baseUrl/messages/${appController.user.id}?pass=${appController.user.password}',
        ),
      );

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((item) => InfosysNotification.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
