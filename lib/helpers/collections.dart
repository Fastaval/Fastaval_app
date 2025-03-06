import 'package:fastaval_app/models/food.model.dart';
import 'package:flutter/material.dart';

Map<String, Color> colorMap = {
  'braet': Color(0xFF64B5F6),
  'designer': Color(0xFFFFB851),
  'gds': Color(0xFFFFB851),
  'junior': Color(0xFFfdef90),
  'ottoviteter': Color(0x80FF9700),
  'rolle': Color(0x80AED581),
  'spilleder': Color(0x80FF9700),
  'system': Color(0x80FF9700),
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

Color getFoodColor(Food item) {
  if (item.received == 1) return Color(0xFFD4E9EC);
  if (item.titleEn.contains('Dinner')) return Color(0xFFC9ECFF);
  if (item.titleEn.contains('Breakfast')) return Color(0xFFF9FC70);
  if (item.titleEn.contains('Lunch')) return Color(0xFFAED581);
  return Color(0xFFD4E9EC);
}

String getActivityImageLocation(type) {
  return activityImageMap[type] ?? 'assets/images/fastaval.jpg';
}
