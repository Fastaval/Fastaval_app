import 'dart:convert';

import 'package:fastaval_app/models/boardgame.model.dart';
import 'package:fastaval_app/models/scheduling.model.dart';
import 'package:fastaval_app/services/config.service.dart';
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
