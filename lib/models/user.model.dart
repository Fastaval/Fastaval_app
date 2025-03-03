import 'package:fastaval_app/models/food.model.dart';
import 'package:fastaval_app/models/otto_party.model.dart';
import 'package:fastaval_app/models/scheduling.model.dart';
import 'package:fastaval_app/models/sleep.model.dart';
import 'package:fastaval_app/models/wear.model.dart';

class User {
  int id;
  String password;
  String name;
  bool hasCheckedIn;
  String? messages;
  Sleep sleep;
  String category;
  List<Food> food;
  List<Wear> wear;
  List<Scheduling> scheduling;
  int barcode;
  List<OttoParty> ottoParty;

  User({
    required this.id,
    required this.password,
    required this.name,
    required this.hasCheckedIn,
    required this.messages,
    required this.sleep,
    required this.category,
    required this.food,
    required this.wear,
    required this.scheduling,
    required this.barcode,
    required this.ottoParty,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        password = json['password'] ?? '',
        name = json['name'],
        hasCheckedIn = json['checked_in'] != 0,
        messages = json['messages'],
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
        'barcode': barcode,
        'food': food,
        'wear': wear,
        'scheduling': scheduling,
        'otto_party': ottoParty,
      };
}
