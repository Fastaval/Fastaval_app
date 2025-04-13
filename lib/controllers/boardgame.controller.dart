import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/models/activity.model.dart';
import 'package:fastaval_app/models/boardgame.model.dart';
import 'package:fastaval_app/services/activities.service.dart';
import 'package:fastaval_app/services/config.service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BoardGameController extends GetxController {
  final appCtrl = Get.find<AppController>();
  final ActivitiesService activitiesService = ActivitiesService();

  RxList<Activity> availableBoardgames = <Activity>[].obs;
  RxList<Activity> chosenBoardgames = <Activity>[].obs;
  RxList boardgameList = [].obs;
  RxList filteredList = [].obs;
  RxInt listUpdatedAt = 0.obs;
  RxBool showSearchClear = false.obs;
  RxBool isLoading = false.obs;

  init() {
    getBoardGames();
    fetchAndSetInitialRankings();
  }

  getBoardGames() {
    fetchBoardgames().then((gamesList) => _updateBoardgameList(gamesList));
  }

  _updateBoardgameList(List<Boardgame> gamesList) {
    boardgameList(gamesList);
    listUpdatedAt((DateTime.now().millisecondsSinceEpoch / 1000).round());
  }

  applyFilterToList([String? filter]) {
    showSearchClear(filter != null && filter.isNotEmpty);

    filteredList(
      filter != null && filter.isNotEmpty
          ? boardgameList
              .where(
                (game) =>
                    game.name.toLowerCase().contains(filter.toLowerCase()),
              )
              .toList()
          : boardgameList,
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Activity item = chosenBoardgames.removeAt(oldIndex);
    chosenBoardgames.insert(newIndex, item);
  }

  void acceptItem(Activity item) {
    chosenBoardgames.add(item);
    availableBoardgames.remove(item);
  }

  void removeItem(Activity item) {
    availableBoardgames.add(item);
    chosenBoardgames.remove(item);
  }

  void addItem(Activity item) {
    chosenBoardgames.add(item);
    availableBoardgames.remove(item);
  }

  Future<void> sendBoardgameRankings(int id, String pass) async {
    isLoading(true);
    var url = Uri.parse('$baseUrl/boardgamerankings');
    var request = http.MultipartRequest('POST', url);

    request.fields['id'] = id.toString();
    request.fields['pass'] = pass.toString();

    if (chosenBoardgames.isEmpty) {
      request.fields['rankings[0]'] = "null";
    } else {
      for (int i = 0; i < chosenBoardgames.length; i++) {
        request.fields['rankings[$i]'] = chosenBoardgames[i].id.toString();
      }
    }

    try {
      var response = await request.send();
      if (chosenBoardgames.isEmpty && response.statusCode == 500) {
        Fluttertoast.showToast(msg: tr("boardgames.vote.reset"));
      } else if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: tr("boardgames.vote.successful"));
      } else {
        Fluttertoast.showToast(msg: tr('boardgames.vote.failed'));
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAndSetInitialRankings() async {
    activitiesService.fetchProgram().then((program) {
      var boardgameList = program.activities
          .where((item) => item.type == "braet")
          .toList()
        ..sort((a, b) => a.titleDa.compareTo(b.titleDa));

      availableBoardgames(boardgameList);
    });

    var url = Uri.parse('$baseUrl/boardgamerankings?id=${appCtrl.user.id}');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> rankings = data['rankings'] ?? [];

        chosenBoardgames.clear();

        for (var rankingId in rankings) {
          Activity? game = availableBoardgames.firstWhereOrNull(
            (game) => game.id == rankingId,
          );
          if (game != null) {
            chosenBoardgames.add(game);
            availableBoardgames.remove(game);
          }
        }
      } else {
        Fluttertoast.showToast(msg: tr("boardgames.vote.failedFetch"));
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'An error occurred while fetching rankings: $e');
    }
  }
}

Future<List<Boardgame>> fetchBoardgames() async {
  var response = await http.get(Uri.parse('$baseUrl/v1/boardgames'));

  if (response.statusCode == 200) {
    var boardgames = (jsonDecode(response.body) as List)
        .map((game) => Boardgame.fromJson(game))
        .toList();

    boardgames.sort((a, b) => a.name.compareTo(b.name));

    return boardgames;
  }

  throw Exception('Failed to load board games');
}
