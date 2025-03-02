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
    return DefaultTabController(
      length: 5,
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
          children: [
            buildday("2025-04-16"),
            buildday("2025-04-17"),
            buildday("2025-04-18"),
            buildday("2025-04-19"),
            buildday("2025-04-20"),
          ],
        ),
      ),
    );
  }

  TabBar get _tabBar => TabBar(
        labelColor: colorBlack,
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: colorOrange,
        tabs: [
          Tab(text: tr('program.wednesday.short')),
          Tab(text: tr('program.thursday.short')),
          Tab(text: tr('program.friday.short')),
          Tab(text: tr('program.saturday.short')),
          Tab(text: tr('program.sunday.short')),
        ],
      );

  Widget buildday(String day) {
    return ListView.builder(
      itemCount: programCtrl.activityRunForDay[day]!.length,
      itemBuilder: (context, index) {
        ActivityRun item = programCtrl.activityRunForDay[day]![index];
        return programListItem(
          programCtrl.activities[item.activity]!,
          item,
          getActivityColor(programCtrl.activities[item.activity]!.type),
          context,
        );
      },
    );
  }
}
