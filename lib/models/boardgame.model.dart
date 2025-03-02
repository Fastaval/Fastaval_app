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

  Boardgame.fromJson(dynamic json)
      : id = json['id'],
        name = json['name'].toString().capitalizeString(),
        available = json['available'],
        fastavalGame = json['fastavalGame'],
        bbgId = json['bggId'] ?? 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title_da': name,
        'available': available,
        'fastavalGame': fastavalGame,
        'bggId': bbgId,
      };
}

class Boardgames {
  List<Boardgame> games = List.empty(growable: true);

  Boardgames({required this.games});

  Boardgames.fromJson(dynamic json) {
    for (var game in json) {
      games.add(Boardgame.fromJson(game));
    }
  }
}
