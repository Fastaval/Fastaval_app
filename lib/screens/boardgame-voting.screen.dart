import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/controllers/boardgame.controller.dart';
import 'package:fastaval_app/controllers/program.controller.dart';
import 'package:fastaval_app/models/scheduling.model.dart';
import 'package:fastaval_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoardgameVotingScreen extends StatelessWidget {
  final appCtrl = Get.find<AppController>();
  final boardgameCtrl = Get.find<BoardGameController>();
  final programCtrl = Get.find<ProgramController>();

  @override
  Widget build(BuildContext context) {
    var schedule = appCtrl.user.scheduling
        .where((item) => item.activityType == "braet")
        .toList();

    boardgameCtrl.boardgameVoteList.assignAll([
      ...schedule,
      ...schedule,
      ...schedule,
    ]);

    return Scaffold(
        appBar: commonAppBar(
          title: tr('boardgameVoting.title'),
        ),
        body: Container(
          height: double.infinity,
          decoration: backgroundBoxDecorationStyle,
          padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  tr('boardgameVoting.instructionsTitle'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('1. ${tr('boardgameVoting.instruction1')}'),
                    Text('2. ${tr('boardgameVoting.instruction2')}'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Text(
                  tr('boardgameVoting.instructionsFooter'),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Expanded(
                child: Obx(() => ReorderableListView(
                        children: [
                          for (int index = 0;
                              index < boardgameCtrl.boardgameVoteList.length;
                              index += 1)
                            userProgramItem(
                                boardgameCtrl.boardgameVoteList[index],
                                Key('$index')),
                        ],
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          inspect("$oldIndex $newIndex");
                          inspect(boardgameCtrl.boardgameVoteList);
                          final Scheduling item = boardgameCtrl
                              .boardgameVoteList
                              .removeAt(oldIndex);
                          boardgameCtrl.boardgameVoteList
                              .insert(newIndex, item);
                        })),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement vote submission logic
                    },
                    child: Text(
                      tr('boardgameVoting.voteButton'),
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Center(
                  child: Text(
                    tr('boardgameVoting.voteInstruction'),
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ));
  }

  Widget userProgramItem(Scheduling game, Key key) {
    var title = Get.locale!.languageCode == 'da' ? game.titleDa : game.titleEn;
    var activity = programCtrl.activities[game.id];
    var author = Get.locale!.languageCode == 'da'
        ? "Af ${activity?.author}"
        : "By ${activity?.author}";
    inspect(activity);

    var expired = DateTime.now().isAfter(
      DateTime.fromMillisecondsSinceEpoch(game.stop * 1000),
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
        color: Colors.white,
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
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          color: expired ? Colors.black26 : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    author,
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
