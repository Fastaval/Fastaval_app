import 'dart:convert';

import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/models/boardgame.model.dart';
import 'package:fastaval_app/models/scheduling.model.dart';
import 'package:fastaval_app/services/config.service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BoardGameController extends GetxController {
  RxList<Scheduling> availableBoardgames = <Scheduling>[].obs;
  RxList<Scheduling> chosenBoardgames = <Scheduling>[].obs;
  RxList boardgameList = [].obs;
  RxList filteredList = [].obs;
  RxInt listUpdatedAt = 0.obs;
  RxBool showSearchClear = false.obs;

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
    final Scheduling item = chosenBoardgames.removeAt(oldIndex);
    chosenBoardgames.insert(newIndex, item);
  }

  void acceptItem(Scheduling item) {
    chosenBoardgames.add(item);
    availableBoardgames.remove(item);
  }

  void removeItem(Scheduling item) {
    availableBoardgames.add(item);
    chosenBoardgames.remove(item);
  }

  Future<void> sendBoardgameRankings(int id, String pass) async {
    var url = Uri.parse('$baseUrl/boardgamerankings');
    var request = http.MultipartRequest('POST', url);

    request.fields['id'] = id.toString();
    request.fields['pass'] = pass.toString();

    for (int i = 0; i < chosenBoardgames.length; i++) {
      request.fields['rankings[$i]'] = chosenBoardgames[i].id.toString();
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: 'Board game rankings submitted successfully!');
      } else {
        Fluttertoast.showToast(msg: 'Failed to submit board game rankings.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'An error occurred: $e');
    }
  }

  Future<void> fetchAndSetInitialRankings() async {
    var appCtrl = Get.find<AppController>();
    var schedule = appCtrl.user.scheduling
        .where((item) => item.activityType == "braet")
        .toList();

    var url = Uri.parse('$baseUrl/boardgamerankings?id=${appCtrl.user.id}');
    availableBoardgames.assignAll(schedule);
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<dynamic> rankings = data['rankings'];

        // Clear existing chosenBoardgames
        chosenBoardgames.clear();

        // Populate chosenBoardgames based on the rankings array
        for (var rankingId in rankings) {
          Scheduling? game = availableBoardgames.firstWhereOrNull(
            (game) => game.id == rankingId,
          );
          if (game != null) {
            chosenBoardgames.add(game);
            availableBoardgames.remove(game);
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Failed to fetch initial board game rankings.');
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
