import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/program.controller.dart';
import 'package:fastaval_app/helpers/collections.dart';
import 'package:fastaval_app/models/activity_run.model.dart';
import 'package:fastaval_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgramScreen extends StatelessWidget {
  final programCtrl = Get.find<ProgramController>();

  @override
  Widget build(context) {
    return Obx(() => DefaultTabController(
          length: programCtrl.eventDates.length,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: colorOrangeDark,
              foregroundColor: colorWhite,
              toolbarHeight: 40,
              centerTitle: true,
              titleTextStyle: kAppBarTextStyle,
              title: Text(tr('screenTitle.program')),
              bottom: PreferredSize(
                preferredSize: _tabBar.preferredSize,
                child: ColoredBox(color: colorWhite, child: _tabBar),
              ),
            ),
            body: TabBarView(
              children:
                  programCtrl.eventDates.map((day) => buildday(day)).toList(),
            ),
          ),
        ));
  }

  TabBar get _tabBar => TabBar(
        labelColor: colorBlack,
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: colorOrange,
        tabs: programCtrl.eventDates.map((day) {
          DateTime date = DateTime.parse(day);
          String weekday = getDayNameShort(date);
          return Tab(text: weekday);
        }).toList(),
      );

  String getDayNameShort(DateTime date) {
    Map<int, String> dayTranslations = {
      3: 'program.wednesday.short',
      4: 'program.thursday.short',
      5: 'program.friday.short',
      6: 'program.saturday.short',
      7: 'program.sunday.short',
    };

    return tr(dayTranslations[date.weekday] ?? 'unknown');
  }

  Widget buildday(String day) {
    return ListView.builder(
      itemCount: programCtrl.activityRunForDay[day].length,
      itemBuilder: (context, index) {
        ActivityRun item = programCtrl.activityRunForDay[day][index];
        return programListItem(
          programCtrl.activities[item.activity],
          item,
          getActivityColor(programCtrl.activities[item.activity].type),
          context,
        );
      },
    );
  }
}
