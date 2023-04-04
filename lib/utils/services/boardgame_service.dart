import 'dart:convert';

import 'package:fastaval_app/config/models/boardgame.dart';
import 'package:fastaval_app/constants/app_constants.dart';
import 'package:http/http.dart' as http;

Future<List<BoardGame>> fetchBoardGames() async {
  print("fetching boardgames");
  var response = await http.get(Uri.parse('$baseUrl/v1/boardgames'));

  if (response.statusCode == 200) {
    return (jsonDecode(response.body) as List)
        .map((game) => BoardGame.fromJson(game))
        .toList();
  }

  throw Exception('Failed to load boardgames');
}
