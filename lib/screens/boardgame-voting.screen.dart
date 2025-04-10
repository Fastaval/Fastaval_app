import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/controllers/boardgame.controller.dart';
import 'package:fastaval_app/models/activity.model.dart';
import 'package:fastaval_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoardgameVotingScreen extends StatelessWidget {
  final appCtrl = Get.find<AppController>();
  final boardgameCtrl = Get.find<BoardGameController>();

  @override
  Widget build(BuildContext context) {
    final ScrollController controller1 = ScrollController();
    final ScrollController controller2 = ScrollController();

    return Scaffold(
      appBar: commonAppBar(
        title: tr('boardgameVoting.title'),
      ),
      body: Container(
        height: double.infinity,
        decoration: backgroundBoxDecorationStyle,
        padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(children: [
                    Text(
                      tr('boardgameVoting.availableGames'),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(" - ${tr('boardgameVoting.pressToAdd')}"),
                  ])),
              Expanded(
                child: Scrollbar(
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

                          return Container(
                            key: ValueKey(game.id),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            margin: EdgeInsets.fromLTRB(8, 0, 24, 4),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(gameTitle),
                                  ),
                                  if (boardgameCtrl.chosenBoardgames.length < 5)
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(6),
                                        ),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: Colors.white,
                                        ),
                                        onPressed: boardgameCtrl
                                                    .chosenBoardgames.length <
                                                5
                                            ? () => boardgameCtrl.addItem(game)
                                            : null,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )),
              ),
              SizedBox(height: 30),
              Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Row(children: [
                    Text(
                      tr('boardgameVoting.chosenGames'),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(" - ${tr('boardgameVoting.holdAndDrag')}"),
                  ])),
              Expanded(
                child: DragTarget<Activity>(
                  onAcceptWithDetails: (DragTargetDetails<Activity> details) {
                    boardgameCtrl.acceptItem(details.data);
                  },
                  builder: (BuildContext context, List<Activity?> accepted,
                      List<dynamic> rejected) {
                    return Scrollbar(
                        thickness: 8,
                        radius: Radius.circular(8),
                        thumbVisibility: true,
                        controller: controller2,
                        child: ReorderableListView.builder(
                          scrollController: controller2,
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
                              margin: EdgeInsets.fromLTRB(8, 0, 24, 4),
                              height: 40,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child:
                                            Text("${index + 1} - $gameTitle")),
                                    Icon(Icons.drag_handle),
                                    SizedBox(width: 16),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.deepOrange,
                                        borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(6),
                                        ),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: Colors.white,
                                        ),
                                        onPressed: () =>
                                            boardgameCtrl.removeItem(game),
                                      ),
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
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed: () {
                        boardgameCtrl.sendBoardgameRankings(
                            appCtrl.user.id, appCtrl.user.password);
                      },
                      child: boardgameCtrl.isLoading.value
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.deepOrange,
                              ),
                            )
                          : Text(
                              tr('boardgameVoting.voteButton'),
                              style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  }),
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
          );
        }),
      ),
    );
  }
}
