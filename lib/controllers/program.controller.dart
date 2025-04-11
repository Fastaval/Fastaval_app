import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/helpers/formatting.dart';
import 'package:fastaval_app/models/activity_item.model.dart';
import 'package:fastaval_app/models/activity_run.model.dart';
import 'package:fastaval_app/services/activities.service.dart';
import 'package:fastaval_app/services/local_storage.service.dart';
import 'package:fastaval_app/services/config.service.dart';
import 'package:get/get.dart';

class ProgramController extends GetxController {
  final LocalStorageService storageService = LocalStorageService();
  final ActivitiesService activitiesService = ActivitiesService();
  final appCtrl = Get.find<AppController>();

  RxMap activities = {}.obs;
  RxMap runs = {}.obs;
  RxList favorites = [].obs;
  RxMap activityItemForDay = {}.obs;
  RxMap activityRunForDay = {}.obs;
  RxList<String> eventDates = <String>[].obs;

  init() async {
    eventDates.value = ConfigService.instance.getDates();

    for (String day in eventDates) {
      await addDayToList(day);
    }

    await getFavoritesFromStorage();
  }

  addDayToList(day) async {
    await activitiesService.getDay(day).then((list) {
      List runlist = [];
      activityItemForDay[day] = list;

      for (ActivityItem activity in list) {
        if (activity.type != 'system') {
          activities[activity.id] = activity;
          for (ActivityRun run in activity.runs) {
            if (formatTimestampToDateTime(
                  run.start,
                ).toString().substring(0, 10) ==
                day) {
              runs[run.id] = run;
              runlist.add(run);
            }
          }
        }
      }

      activityRunForDay[day] = runlist..sort((a, b) => a.start - b.start);
    });
  }

  getFavoritesFromStorage() async {
    await activitiesService.retrieveFavorites().then((favoritesList) {
      favorites(favoritesList);
    });
  }

  toggleFavorite(int id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);

    activitiesService.storeFavorites(favorites.toList());
  }
}
