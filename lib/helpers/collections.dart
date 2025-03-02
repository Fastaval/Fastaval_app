import 'package:flutter/material.dart';

Map<String, Color> colorMap = {
  'braet': Color(0xBCB2DAFB),
  'designer': Color(0xFFFFB851),
  'gds': Color(0xFFFFB851),
  'junior': Color(0xFFfdef90),
  'ottoviteter': Color(0xFFFFB851),
  'rolle': Color(0xFFAED581),
  'spilleder': Color(0xFFFFB851),
  'system': Color(0xFFFFB851),
  'live': Color(0xFFAED581),
  'magic': Colors.purpleAccent.shade100,
  'workshop': Colors.amberAccent.shade200,
  'figur': Colors.red.shade300,
};

Map<String, String> activityImageMap = {
  'gds': 'assets/images/gds.jpg',
  'spilleder': 'assets/images/gamemaster.jpg',
  'rolle': 'assets/images/player.jpg',
  'live': 'assets/images/player.jpg',
  'braet': 'assets/images/boardgame.jpg',
  'junior': 'assets/images/junior.jpg',
  'magic': 'assets/images/magic.jpg',
};

Color getActivityColor(String type) {
  return colorMap[type] ?? Colors.grey;
}

String getActivityImageLocation(type) {
  return activityImageMap[type] ?? 'assets/images/fastaval.jpg';
}
