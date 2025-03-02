import 'package:fastaval_app/models/food.model.dart';
import 'package:fastaval_app/models/otto_party.model.dart';
import 'package:fastaval_app/models/scheduling.model.dart';
import 'package:fastaval_app/models/sleep.model.dart';
import 'package:fastaval_app/models/wear.model.dart';

class User {
  late int id;
  late String password;
  late String name;
  late bool hasCheckedIn;
  late String messages;
  late Sleep sleep;
  late String category;
  late List<Food> food;
  late List<Wear> wear;
  late List<Scheduling> scheduling;
  late int barcode;
  late List<OttoParty> ottoParty;

  User({
    this.id = 0,
    this.password = '',
    this.name = '',
    this.hasCheckedIn = false,
    this.messages = '',
    this.category = '',
    this.food = const [],
    this.wear = const [],
    this.scheduling = const [],
    this.barcode = 0,
    this.ottoParty = const [],
  }) {
    sleep = Sleep(id: 0, access: 0, mattress: 0, areaName: '', areaId: '');
  }

  User.fromJson(dynamic json)
    : id = json['id'],
      password = json['password'] ?? '',
      name = json['name'],
      hasCheckedIn = json['checked_in'] != 0,
      messages = json['messages'] ?? '',
      sleep = Sleep.fromJson(json['sleep']),
      category = json['category'],
      barcode = json['barcode'],
      food = List<Food>.from(json['food'].map((item) => Food.fromJson(item))),
      wear = List<Wear>.from(json['wear'].map((item) => Wear.fromJson(item))),
      scheduling = List<Scheduling>.from(
        json['scheduling'].map((item) => Scheduling.fromJson(item)),
      ),
      ottoParty = List<OttoParty>.from(
        json['otto_party'].map((item) => OttoParty.fromJson(item)),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'password': password,
    'name': name,
    'checked_in': hasCheckedIn,
    'messages': messages,
    'sleep': sleep,
    'category': category,
    'food': food,
    'wear': wear,
    'scheduling': scheduling,
    'barcode': barcode,
    'otto_party': ottoParty,
  };
}
