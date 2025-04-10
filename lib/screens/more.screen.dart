import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/controllers/boardgame.controller.dart';
import 'package:fastaval_app/controllers/notification.controller.dart';
import 'package:fastaval_app/screens/boardgame-voting.screen.dart';
import 'package:fastaval_app/screens/boardgame.screen.dart';
import 'package:fastaval_app/screens/notifications.screen.dart';
import 'package:fastaval_app/screens/settings.screen.dart';
import 'package:fastaval_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatelessWidget {
  final notificationCtrl = Get.find<NotificationController>();
  final appCtrl = Get.find<AppController>();
  final boardgameCtrl = Get.find<BoardGameController>();

  @override
  Widget build(context) {
    var newsletter = Uri.parse(
      'https://fastaval.us21.list-manage.com/subscribe?u=0929f085b293ddfa9eb2bc60a&id=13f4440b66',
    );
    var x = Uri.parse('https://twitter.com/fastaval');
    var facebook = Uri.parse('https://www.facebook.com/Fastaval');
    var instagram = Uri.parse('https://www.instagram.com/fastaval/');
    var school = 'assets/images/mariagerfjord_${Get.locale!.languageCode}.jpg';
    var gym = 'assets/images/idraetcenter_${Get.locale!.languageCode}.jpg';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorOrangeDark,
        foregroundColor: colorWhite,
        toolbarHeight: 40,
        centerTitle: true,
        titleTextStyle: kAppBarTextStyle,
        title: Text(tr('screenTitle.more')),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: backgroundBoxDecorationStyle,
          child: Obx(
            () => Column(
              children: [
                if (appCtrl.loggedIn.value == true)
                  InkWell(
                    child: menuCard(
                      tr('notifications.title'),
                      Icons.notifications_outlined,
                      true,
                      notificationCtrl.notificationsWaiting.value,
                    ),
                    onTap: () => {
                      HapticFeedback.selectionClick(),
                      Get.to(
                        () => NotificationsScreen(),
                        transition: Transition.rightToLeft,
                      ),
                      notificationCtrl.clearNotificationsWaiting(),
                    },
                  ),
                InkWell(
                  child: menuCard(
                    tr('boardgames.title'),
                    Icons.casino_outlined,
                    true,
                  ),
                  onTap: () => {
                    HapticFeedback.selectionClick(),
                    Get.to(
                      () => BoardgameScreen(),
                      transition: Transition.rightToLeft,
                    )
                  },
                ),
                if (appCtrl.loggedIn.value == true)
                  InkWell(
                    child: menuCard(
                      tr('boardgameVoting.title'),
                      Icons.how_to_vote_outlined,
                      true,
                    ),
                    onTap: () => {
                      HapticFeedback.selectionClick(),
                      Get.to(
                        () => BoardgameVotingScreen(),
                        transition: Transition.rightToLeft,
                      )
                    },
                  ),
                InkWell(
                  child: menuCard(
                    tr('more.map.school'),
                    CupertinoIcons.map_pin_ellipse,
                  ),
                  onTap: () => {
                    HapticFeedback.selectionClick(),
                    fastaMap(context, AssetImage(school))
                  },
                ),
                InkWell(
                  child: menuCard(
                    tr('more.map.gym'),
                    CupertinoIcons.map_pin_ellipse,
                  ),
                  onTap: () => {
                    HapticFeedback.selectionClick(),
                    fastaMap(context, AssetImage(gym))
                  },
                ),
                SizedBox(height: 50),
                InkWell(
                  child: menuCard(tr('more.settings'), Icons.settings, true),
                  onTap: () => {
                    HapticFeedback.selectionClick(),
                    Get.to(
                      () => SettingsScreen(),
                      transition: Transition.rightToLeft,
                    )
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => canLaunchUrl(facebook).then(
                              (allowed) => {
                                if (allowed)
                                  launchUrl(
                                    facebook,
                                    mode: LaunchMode.externalApplication,
                                  ),
                              },
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.facebook,
                              size: 40,
                              color: colorBlack,
                            ),
                          ),
                          SizedBox(width: 24),
                          IconButton(
                            onPressed: () => canLaunchUrl(instagram).then(
                              (allowed) => {
                                if (allowed)
                                  launchUrl(
                                    instagram,
                                    mode: LaunchMode.externalApplication,
                                  ),
                              },
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.instagram,
                              size: 40,
                              color: colorBlack,
                            ),
                          ),
                          SizedBox(width: 24),
                          IconButton(
                            onPressed: () => canLaunchUrl(x).then(
                              (allowed) => {
                                if (allowed)
                                  launchUrl(
                                    x,
                                    mode: LaunchMode.externalApplication,
                                  ),
                              },
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.xTwitter,
                              size: 40,
                              color: colorBlack,
                            ),
                          ),
                          SizedBox(width: 24),
                          IconButton(
                            onPressed: () => canLaunchUrl(newsletter).then(
                              (allowed) => {
                                if (allowed)
                                  launchUrl(
                                    newsletter,
                                    mode: LaunchMode.externalApplication,
                                  ),
                              },
                            ),
                            icon: FaIcon(
                              FontAwesomeIcons.envelopeOpenText,
                              size: 40,
                              color: colorBlack,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        tr('more.socialMedia'),
                        style: kNormalTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 8, right: 16),
                          child: Obx(() => Text(
                                '${appCtrl.packageInfo.value?.version} © Fastaval IT',
                                style: kNormalTextSubdued,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future fastaMap(BuildContext context, AssetImage image) => showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            PhotoView(imageProvider: image),
            Positioned(
              right: 10,
              top: 10,
              child: Material(
                color: Colors.transparent,
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 20,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    color: Colors.black,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
