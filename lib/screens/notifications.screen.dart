import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/notification.controller.dart';
import 'package:fastaval_app/helpers/formatting.dart';
import 'package:fastaval_app/models/notification.model.dart';
import 'package:fastaval_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timezone/standalone.dart' as tz;

class NotificationsScreen extends StatelessWidget {
  final notificationCtrl = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    notificationCtrl.clearNotificationsWaiting();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorOrangeDark,
        foregroundColor: colorWhite,
        toolbarHeight: 40,
        centerTitle: true,
        titleTextStyle: kAppBarTextStyle,
        actions: [
          IconButton(
            onPressed: () => notificationCtrl.getNotifications(),
            icon: Icon(CupertinoIcons.refresh),
          ),
        ],
        title: Text(tr('screenTitle.notifications')),
      ),
      body: Container(
        height: double.infinity,
        decoration: backgroundBoxDecorationStyle,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 12),
              Obx(
                () => textAndTextCard(
                  tr('notifications.title'),
                  "${tr('common.updated')} ${formatDay(notificationCtrl.notificationListUpdatedAt.value)} ${formatTime(notificationCtrl.notificationListUpdatedAt.value)}",
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: notificationList(context),
                  ),
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget notificationList(context) {
    var notifications = notificationCtrl.notificationList.reversed.toList();

    return notifications.isNotEmpty
        ? ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: notifications.length,
            separatorBuilder: (context, int index) =>
                Divider(height: 20, color: Colors.grey),
            itemBuilder: (buildContext, index) =>
                notificationItem(notifications[index]),
          )
        : Padding(
            child: Text(
              tr('notifications.noNotificationsFound'),
              style: kNormalTextStyle,
            ),
            padding: EdgeInsets.fromLTRB(16, 48, 16, 48),
          );
  }

  Widget notificationItem(InfosysNotification notification) {
    var tzOffset =
        (tz.getLocation('Europe/Copenhagen').currentTimeZone.offset / 1000)
            .round();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Column(
            children: [
              Text(
                formatTime(notification.sendTime + tzOffset),
                style: kNormalTextBoldStyle,
              ),
              Text(
                formatDay(notification.sendTime + tzOffset),
                style: kNormalTextBoldStyle,
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            Get.locale?.languageCode == 'da'
                ? notification.da
                : notification.en,
          ),
        ),
      ],
    );
  }
}
