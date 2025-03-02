import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/notification.controller.dart';
import 'package:fastaval_app/controllers/program.controller.dart';
import 'package:fastaval_app/helpers/collections.dart';
import 'package:fastaval_app/helpers/formatting.dart';
import 'package:fastaval_app/models/activity_item.model.dart';
import 'package:fastaval_app/models/activity_run.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

final programCtrl = Get.find<ProgramController>();
final notificationController = Get.find<NotificationController>();

Widget oneTextRow(String text) =>
    Text(text, style: kNormalTextStyle, overflow: TextOverflow.ellipsis);

Widget programListItem(
  ActivityItem activity,
  ActivityRun run,
  Color color,
  BuildContext context,
) {
  return Stack(
    children: [
      Positioned.fill(
        child: InkWell(
          onTap:
              () => showDialog(
                context: context,
                builder: programItemDialog,
                routeSettings: RouteSettings(
                  arguments: [run, programCtrl.activities[activity.id]],
                ),
              ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 48, 5),
            child: Row(
              children: [
                SizedBox(
                  height: 40,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(width: 5, color: color),
                        right: BorderSide(
                          width: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            formatTime(run.start),
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          Get.locale?.languageCode == 'da'
                              ? activity.daTitle
                              : activity.enTitle,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: Obx(
          () => IconButton(
            onPressed: () => programCtrl.toggleFavorite(run.id),
            icon: Icon(
              programCtrl.favorites.contains(run.id)
                  ? CupertinoIcons.heart_fill
                  : CupertinoIcons.heart,
              color: colorOrangeDark,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget menuCard(
  String title,
  IconData icon, [
  bool hasSubMenu = false,
  showBadge = false,
]) {
  return Card(
    surfaceTintColor: colorWhite,
    color: colorWhite,
    margin: kMenuCardMargin,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Colors.black12, width: 1),
    ),
    elevation: 5,
    child: Column(
      children: [
        ListTile(
          trailing:
              hasSubMenu ? Icon(Icons.keyboard_arrow_right_outlined) : null,
          title: Row(
            children: [
              Icon(icon),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(title, style: kMenuCardHeaderStyle),
              ),
              if (showBadge)
                Badge(
                  label: Text(
                    '${notificationController.notificationList.length - notificationController.notificationsOnLastClear.value}',
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget textAndIconCard(String title, IconData icon, content) {
  return Container(
    margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
    decoration: BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 0.5),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: colorWhite, width: 1),
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 24, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: kCardHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ),
              Icon(icon),
            ],
          ),
        ),
        content,
      ],
    ),
  );
}

Widget textAndTextCard(String title, String secondaryTitle, content) {
  return Container(
    margin: kCardMargin,
    decoration: BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 0.5),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: colorWhite, width: 1),
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: kCardHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ),
              Text(secondaryTitle, style: kNormalTextSubdued),
            ],
          ),
        ),
        content,
      ],
    ),
  );
}

Widget textAndItemCard(String title, Widget secondaryTitle, content) {
  return Container(
    margin: kCardMargin,
    decoration: BoxDecoration(
      color: Color.fromRGBO(255, 255, 255, 0.5),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: colorWhite, width: 1),
    ),
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: kCardHeaderStyle,
                overflow: TextOverflow.ellipsis,
              ),
              secondaryTitle,
            ],
          ),
        ),
        content,
      ],
    ),
  );
}

Widget textRowHeader(String text) => Row(
  mainAxisSize: MainAxisSize.max,
  children: [
    Expanded(
      child: Text(
        text,
        style: kNormalTextBoldStyle,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
);

Widget twoTextRow(
  String textLeft,
  String textRight, {
  bool selectable = false,
  bool sidePadding = false,
}) {
  return Padding(
    padding: EdgeInsets.only(left: sidePadding ? 8 : 0),
    child: Row(
      children: <Widget>[
        Expanded(flex: 4, child: Text(textLeft, style: kNormalTextStyle)),
        Expanded(
          flex: 6,
          child:
              selectable
                  ? SelectableText(
                    textRight,
                    textAlign: TextAlign.right,
                    style: kNormalTextStyle,
                  )
                  : Text(
                    textRight,
                    textAlign: TextAlign.right,
                    style: kNormalTextStyle,
                  ),
        ),
      ],
    ),
  );
}

Widget twoTextRowWithTapAction(String title, String link, Uri url) {
  return Row(
    children: <Widget>[
      Expanded(flex: 11, child: Text(title, style: kNormalTextStyle)),
      Expanded(
        flex: 9,
        child: GestureDetector(
          onTap: () {
            canLaunchUrl(url).then(
              (allowed) => {
                if (allowed)
                  {launchUrl(url, mode: LaunchMode.externalApplication)},
              },
            );
          },
          child: Text(
            link,
            textAlign: TextAlign.right,
            style: kNormalTextClickableStyle,
          ),
        ),
      ),
    ],
  );
}

Widget programItemDialog(BuildContext context) {
  ScrollController scrollController = ScrollController();
  var [ActivityRun run, ActivityItem activity] =
      ModalRoute.of(context)!.settings.arguments as List;

  return AlertDialog(
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(tr('common.close')),
      ),
    ],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: colorWhite,
    surfaceTintColor: colorWhite,
    insetPadding: EdgeInsets.all(10),
    contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
    actionsPadding: EdgeInsets.all(5),
    titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
    title: Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                image: DecorationImage(
                  image: AssetImage(getActivityImageLocation(activity.type)),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
              height: 150,
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Text(
                context.locale.languageCode == 'da'
                    ? activity.daTitle
                    : activity.enTitle,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
            child: Obx(
              () => IconButton(
                onPressed: () => programCtrl.toggleFavorite(run.id),
                icon: Icon(
                  programCtrl.favorites.contains(run.id)
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
                  color: colorOrangeDark,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${tr('common.runtime')}: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${activity.playHours.toInt()} '),
            Text(
              activity.playHours == 1 ? tr('common.hour') : tr('common.hours'),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              '${tr('common.players')}: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${activity.minPlayers} - ${activity.maxPlayers}'),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              '${tr('common.language')}: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(getLanguage(activity.language)),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Text(
              '${tr('common.place')}: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(run.localeName),
          ],
        ),
        if (activity.daText.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            '${tr('common.description')}:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 250,
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                controller: scrollController,
                child: Text(
                  Get.locale?.languageCode == 'da'
                      ? activity.daText
                      : activity.enText,
                ),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}
