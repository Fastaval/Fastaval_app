import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/controllers/boardgame.controller.dart';
import 'package:fastaval_app/models/scheduling.model.dart';
import 'package:fastaval_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoardgameVotingScreen extends StatelessWidget {
  final appCtrl = Get.find<AppController>();
  final boardgameCtrl = Get.find<BoardGameController>();

  @override
  Widget build(BuildContext context) {
    final ScrollController controller1 = ScrollController();
    boardgameCtrl.fetchAndSetInitialRankings();

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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('1. ${tr('boardgameVoting.instruction1')}'),
                  Text('2. ${tr('boardgameVoting.instruction2')}'),
                  Text('3. ${tr('boardgameVoting.instruction3')}'),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  tr('boardgameVoting.availableGames'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Expanded(
              child: Obx(() => Scrollbar(
                    thickness: 8,
                    radius: Radius.circular(8),
                    thumbVisibility: true,
                    controller: controller1,
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: controller1,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: boardgameCtrl.availableBoardgames.length,
                        itemBuilder: (context, index) {
                          var game = boardgameCtrl.availableBoardgames[index];
                          var gameTitle = Get.locale!.languageCode == 'da'
                              ? game.titleDa
                              : game.titleEn;

                          return Draggable<Scheduling>(
                            key: ValueKey(game.id),
                            data: game,
                            feedback: Material(
                              child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(gameTitle),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              margin: EdgeInsets.fromLTRB(8, 0, 60, 8),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                                child: Text(gameTitle),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )),
            ),
            SizedBox(height: 30),
            Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(children: [
                  Text(
                    tr('boardgameVoting.chosenGames'),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(" - ${tr('boardgameVoting.holdAndDrag')}"),
                ])),
            Expanded(
              child: DragTarget<Scheduling>(
                onAcceptWithDetails: (DragTargetDetails<Scheduling> details) {
                  boardgameCtrl.acceptItem(details.data);
                },
                builder: (BuildContext context, List<Scheduling?> accepted,
                    List<dynamic> rejected) {
                  return Obx(() => ReorderableListView.builder(
                        itemCount: boardgameCtrl.chosenBoardgames.length,
                        itemBuilder: (context, index) {
                          var game = boardgameCtrl.chosenBoardgames[index];
                          var gameTitle = Get.locale!.languageCode == 'da'
                              ? game.titleDa
                              : game.titleEn;
                          return Container(
                            key: Key(game.id.toString()),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text("${index + 1} - $gameTitle")),
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () =>
                                        boardgameCtrl.removeItem(game),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          boardgameCtrl.onReorder(oldIndex, newIndex);
                        },
                      ));
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    boardgameCtrl.sendBoardgameRankings(
                        appCtrl.user.id, appCtrl.user.password);
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
      ),
    );
  }
}
