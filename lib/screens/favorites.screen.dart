import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/controllers/program.controller.dart';
import 'package:fastaval_app/helpers/collections.dart';
import 'package:fastaval_app/helpers/formatting.dart';
import 'package:fastaval_app/models/activity_item.model.dart';
import 'package:fastaval_app/models/activity_run.model.dart';
import 'package:fastaval_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatelessWidget {
  final programCtrl = Get.find<ProgramController>();
  final appCtrl = Get.find<AppController>();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorOrangeDark,
        foregroundColor: colorWhite,
        toolbarHeight: 40,
        centerTitle: true,
        titleTextStyle: kAppBarTextStyle,
        title: Text(tr('screenTitle.favorites')),
      ),
      body: Container(
        height: double.infinity,
        decoration: backgroundBoxDecorationStyle,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 12),
              Obx(
                () => textAndIconCard(
                  tr('favorites.yourFavorites'),
                  Icons.favorite,
                  buildFavorites(),
                ),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFavorites() {
    var sortedFavorites = programCtrl.favorites
        .map((id) => programCtrl.runs[id])
        .toList()
      ..sort((a, b) => a.start - b.start);

    return sortedFavorites.isNotEmpty
        ? Column(
            children: [
              SizedBox(height: 8),
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: sortedFavorites.length,
                separatorBuilder: (context, int index) => SizedBox(height: 0),
                itemBuilder: (buildContext, index) =>
                    favoriteItem(sortedFavorites[index]),
              ),
              SizedBox(height: 8),
            ],
          )
        : Padding(
            child: Text(tr('favorites.noFavorites'), style: kNormalTextStyle),
            padding: EdgeInsets.fromLTRB(16, 48, 16, 48),
          );
  }

  Widget favoriteItem(ActivityRun run) {
    ActivityItem activity = programCtrl.activities[run.activity];
    var title =
        Get.locale!.languageCode == 'da' ? activity.daTitle : activity.enTitle;
    var activityType = tr('activityType.${activity.type}');
    var expired = DateTime.now().isAfter(
      DateTime.fromMillisecondsSinceEpoch(run.stop * 1000),
    );

    return InkWell(
      onTap: () => showDialog(
        context: Get.context!,
        builder: activityDialog,
        routeSettings: RouteSettings(arguments: run),
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.75),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
          color: expired == true
              ? Color(0xFFD4E9EC)
              : getActivityColor(activity.type),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${formatDay(run.start)} ${formatTime(run.start)}-${formatTime(run.stop)}",
                          style: TextStyle(
                            fontSize: 16,
                            color: expired ? Colors.black26 : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "$activityType @ ${run.localeName}",
                            style: expired
                                ? kNormalTextSubduedExpired
                                : kNormalTextSubdued,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: expired ? kNormalTextDisabled : kNormalTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  CupertinoIcons.doc_text_viewfinder,
                  color: expired ? Colors.black26 : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget activityDialog(BuildContext context) {
    ScrollController scrollController = ScrollController();
    ActivityRun run = ModalRoute.of(context)!.settings.arguments as ActivityRun;
    ActivityItem activity = programCtrl.activities[run.activity];

    return AlertDialog(
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      actionsPadding: EdgeInsets.all(5),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(tr('common.close')),
        ),
      ],
      backgroundColor: colorWhite,
      surfaceTintColor: colorWhite,
      titlePadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
      title: Stack(
        children: [
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                  image: DecorationImage(
                    image: AssetImage(getActivityImageLocation(activity.type)),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                height: 150,
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Text(
                  context.locale.languageCode == 'da'
                      ? activity.daTitle
                      : activity.enTitle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 16, 0),
              child: Obx(
                () => IconButton(
                  onPressed: () => programCtrl.toggleFavorite(run.id),
                  icon: Icon(
                    programCtrl.favorites.contains(run.id)
                        ? CupertinoIcons.heart_fill
                        : CupertinoIcons.heart,
                    color: colorOrangeDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${tr('common.type')}: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(tr('activityType.${activity.type}')),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${tr('common.time')}: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${formatDay(run.start)} ${formatTime(run.start)} - ${formatTime(run.stop)}",
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${tr('common.place')}: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(child: Text(run.localeName)),
            ],
          ),
          if (activity.daText.isNotEmpty) ...[
            SizedBox(height: 8),
            Text(
              '${tr('common.description')}:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  controller: scrollController,
                  child: Text(
                    Get.locale?.languageCode == 'da'
                        ? activity.daText
                        : activity.enText,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
