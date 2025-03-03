import 'package:fastaval_app/helpers/formatting.dart';

class Boardgame {
  int id;
  String name;
  bool available;
  bool fastavalGame;
  int bbgId;

  Boardgame({
    required this.id,
    required this.name,
    required this.available,
    required this.fastavalGame,
    required this.bbgId,
  });

  factory Boardgame.fromJson(Map<String, dynamic> json) {
    return Boardgame(
      id: json['id'],
      name: json['name'].toString().capitalizeString(),
      available: json['available'],
      fastavalGame: json['fastavalGame'],
      bbgId: json['bggId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title_da': name,
        'available': available,
        'fastavalGame': fastavalGame,
        'bggId': bbgId,
      };
}

class Boardgames {
  List<Boardgame> games;

  Boardgames({required this.games});

  factory Boardgames.fromJson(dynamic json) {
    List<Boardgame> gamesList = List.empty(growable: true);
    for (var game in json) {
      gamesList.add(Boardgame.fromJson(game));
    }
    return Boardgames(games: gamesList);
  }
}
