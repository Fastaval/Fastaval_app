import 'package:fastaval_app/models/activity.model.dart';

class Program {
  List<Activity> activities;

  Program({required this.activities});

  factory Program.fromJson(dynamic json) {
    List<Activity> activityList = <Activity>[];
    for (var activity in json) {
      activityList.add(Activity.fromJson(activity));
    }
    return Program(activities: activityList);
  }
}
