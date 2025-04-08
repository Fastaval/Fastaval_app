import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/controllers/boardgame.controller.dart';
import 'package:fastaval_app/helpers/collections.dart';
import 'package:fastaval_app/helpers/formatting.dart';
import 'package:fastaval_app/models/scheduling.model.dart';
import 'package:fastaval_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoardgameVotingScreen extends StatelessWidget {
  final appCtrl = Get.find<AppController>();
  final boardgameCtrl = Get.find<BoardGameController>();

  @override
  Widget build(BuildContext context) {
    var schedule = appCtrl.user.scheduling
        .where((item) => item.activityType == "braet")
        .toList();

    // Initialize boardgameVoteList with the schedule items
    boardgameCtrl.boardgameVoteList.assignAll(schedule);

    return Scaffold(
      appBar: commonAppBar(
        title: tr('boardgameVoting.title'),
      ),
      body: Obx(() => ReorderableListView(
              children: [
                for (int index = 0;
                    index < boardgameCtrl.boardgameVoteList.length;
                    index += 1)
                  userProgramItem(
                      boardgameCtrl.boardgameVoteList[index], Key('$index')),
              ],
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final Scheduling item =
                    boardgameCtrl.boardgameVoteList.removeAt(oldIndex);
                boardgameCtrl.boardgameVoteList.insert(newIndex, item);
              })),
    );
  }

  Widget userProgramItem(Scheduling item, Key key) {
    var room = Get.locale!.languageCode == 'da' ? item.roomDa : item.roomEn;
    var title = Get.locale!.languageCode == 'da' ? item.titleDa : item.titleEn;
    var activityType = tr('activityType.${item.activityType}');

    var expired = DateTime.now().isAfter(
      DateTime.fromMillisecondsSinceEpoch(item.stop * 1000),
    );

    return Container(
      key: key,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(191),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
        color: expired == true
            ? Color(0xFFD4E9EC)
            : getActivityColor(item.activityType),
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "${formatDay(item.start)} ${formatTime(item.start)}-${formatTime(item.stop)}",
                        style: TextStyle(
                          fontSize: 16,
                          color: expired ? Colors.black26 : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: expired ? kNormalTextDisabled : kNormalTextStyle,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Icon(
                Icons.drag_handle,
                color: expired ? Colors.black26 : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
