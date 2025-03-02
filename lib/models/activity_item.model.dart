import 'dart:core';

import 'activity_run.model.dart';

class ActivityItem {
  final int id;
  final List<ActivityRun> runs;
  final String daTitle;
  final String daText;
  final String daDescription;
  final String enTitle;
  final String enText;
  final String enDescription;
  final String author;
  final int price;
  final int minPlayers;
  final int maxPlayers;
  final String type;
  final double playHours;
  final String language;
  final int wpId;
  final int canSignUp;

  ActivityItem({
    required this.id,
    required this.runs,
    required this.daTitle,
    required this.daText,
    required this.daDescription,
    required this.enTitle,
    required this.enText,
    required this.enDescription,
    required this.author,
    required this.price,
    required this.minPlayers,
    required this.maxPlayers,
    required this.type,
    required this.playHours,
    required this.language,
    required this.wpId,
    required this.canSignUp,
  });

  ActivityItem.fromJson(Map<String, dynamic> json)
    : id = json['aktivitet_id'],
      runs =
          List.from(
            json['afviklinger'],
          ).map((run) => ActivityRun.fromJson(run)).toList(),
      daTitle = json['title_da'],
      daText = json['text_da'],
      daDescription = json['description_da'],
      enTitle = json['title_en'],
      enText = json['text_en'],
      enDescription = json['description_en'],
      author = json['author'],
      price = json['price'],
      minPlayers = json['min_player'],
      maxPlayers = json['max_player'],
      type = json['type'],
      playHours = json['play_hours'] + .0,
      language = json['language'],
      wpId = json['wp_id'],
      canSignUp = json['can_sign_up'];
}
