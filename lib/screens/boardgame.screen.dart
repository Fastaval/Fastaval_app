import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/boardgame.controller.dart';
import 'package:fastaval_app/helpers/formatting.dart';
import 'package:fastaval_app/models/boardgame.model.dart';
import 'package:fastaval_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BoardgameScreen extends StatelessWidget {
  final TextEditingController _searchInput = TextEditingController();
  final boardgameCtrl = Get.find<BoardGameController>();

  @override
  Widget build(BuildContext context) {
    boardgameCtrl.applyFilterToList('');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorOrangeDark,
        foregroundColor: colorWhite,
        toolbarHeight: 40,
        centerTitle: true,
        titleTextStyle: kAppBarTextStyle,
        actions: [
          IconButton(
            onPressed: () => boardgameCtrl.getBoardGames(),
            icon: Icon(CupertinoIcons.refresh),
          ),
        ],
        title: Text(tr('boardgames.title')),
      ),
      body: Container(
        height: double.infinity,
        decoration: backgroundBoxDecorationStyle,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Container(
                  height: 40,
                  child: Obx(
                    () => TextField(
                      controller: _searchInput,
                      onChanged:
                          (value) => boardgameCtrl.applyFilterToList(value),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(16, 0, 0, 0),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(CupertinoIcons.search),
                        hintText: tr("boardgames.search"),
                        suffixIcon:
                            boardgameCtrl.showSearchClear.value
                                ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed:
                                      () => {
                                        _searchInput.clear(),
                                        boardgameCtrl.applyFilterToList(),
                                      },
                                )
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => textAndTextCard(
                  tr('boardgames.title'),
                  "${tr('common.updated')} ${formatDay(boardgameCtrl.listUpdatedAt.value)} ${formatTime(boardgameCtrl.listUpdatedAt.value)}",
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: buildGameList(context),
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

  Widget buildGameList(BuildContext context) {
    return boardgameCtrl.filteredList.isNotEmpty
        ? ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: boardgameCtrl.filteredList.length,
          addRepaintBoundaries: true,
          separatorBuilder:
              (context, int index) => Divider(height: 0, color: Colors.grey),
          itemBuilder:
              (buildContext, index) =>
                  boardGameItem(boardgameCtrl.filteredList[index]),
        )
        : Padding(
          child: Text(
            textAlign: TextAlign.center,
            tr('boardgames.noGamesFound'),
            style: kNormalTextStyle,
          ),
          padding: EdgeInsets.fromLTRB(0, 48, 0, 48),
        );
  }

  Widget boardGameItem(Boardgame game) {
    return Container(
      color: !game.available ? Colors.red[100] : null,
      child: Column(
        children: [
          SizedBox(height: 10),
          InkWell(
            onTap: () => _launchDDB(game.bbgId),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        style: kNormalTextBoldStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: [
                          Text(
                            tr("boardgames.gameAvailable.${game.available}"),
                          ),
                          if (game.fastavalGame == true)
                            Text(" - ${tr('boardgames.fastavalGame')}"),
                        ],
                      ),
                    ],
                  ),
                ),
                if (game.bbgId > 0)
                  Padding(
                    padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Icon(Icons.public),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  _launchDDB(int gameID) async {
    if (gameID > 0) {
      final url = Uri.parse('https://boardgamegeek.com/boardgame/$gameID');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch website';
      }
    }
  }
}
