import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/app.constant.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/notification.controller.dart';
import 'package:fastaval_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class InfoScreen extends StatelessWidget {
  final notoficationCtrl = Get.find<NotificationController>();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorOrangeDark,
        foregroundColor: colorWhite,
        toolbarHeight: 40,
        centerTitle: true,
        titleTextStyle: kAppBarTextStyle,
        title: Text(tr('screenTitle.info')),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: backgroundBoxDecorationStyle,
              ),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 12),
                      _buildSafeFastavalCard(),
                      _buildOpenHoursCard(),
                      _buildWifiCard(),
                      _buildLostFoundCard(),
                      _buildTransportCard(),
                      _buildFastaWearCard(),
                      SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildFastaWearCard() => textAndIconCard(
      tr('info.fastaWear.title'),
      Icons.shopping_bag_outlined,
      Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 24, 16),
        child: Row(
          children: [
            Flexible(
              child: Text(tr('info.fastaWear.text'), style: kNormalTextStyle),
            ),
          ],
        ),
      ),
    );

Widget _buildLostFoundCard() => textAndIconCard(
      tr('info.lostAndFound.title'),
      Icons.move_to_inbox,
      Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 24, 16),
        child: Row(
          children: [
            Text(tr('info.lostAndFound.text'), style: kNormalTextStyle)
          ],
        ),
      ),
    );

Widget _buildOpenHoursCard() => textAndIconCard(
      tr('info.openHours.title'),
      Icons.access_time,
      Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 24, 16),
        child: Column(
          children: [
            textRowHeader(tr('info.openHours.bar.title')),
            twoTextRow(
              tr('info.openHours.bar.day1'),
              kServiceOpeningHours["bar"]!["day1"]!,
              sidePadding: true,
            ),
            SizedBox(height: 10),
            textRowHeader(tr('info.openHours.boardGames.title')),
            twoTextRow(
              tr('info.openHours.boardGames.day1'),
              kServiceOpeningHours["boardGames"]!["day1"]!,
              sidePadding: true,
            ),
            twoTextRow(
              tr('info.openHours.boardGames.day2'),
              kServiceOpeningHours["boardGames"]!["day2"]!,
              sidePadding: true,
            ),
            SizedBox(height: 10),
            textRowHeader(tr('info.openHours.information.title')),
            twoTextRow(
              tr('info.openHours.information.day1'),
              kServiceOpeningHours["information"]!["day1"]!,
              sidePadding: true,
            ),
            twoTextRow(
              tr('info.openHours.information.day2'),
              kServiceOpeningHours["information"]!["day2"]!,
              sidePadding: true,
            ),
            twoTextRow(
              tr('info.openHours.information.day3'),
              kServiceOpeningHours["information"]!["day3"]!,
              sidePadding: true,
            ),
            SizedBox(height: 10),
            textRowHeader(tr('info.openHours.kiosk.title')),
            twoTextRow(
              tr('info.openHours.kiosk.day1'),
              kServiceOpeningHours["kiosk"]!["day1"]!,
              sidePadding: true,
            ),
            twoTextRow(
              tr('info.openHours.kiosk.day2'),
              kServiceOpeningHours["kiosk"]!["day2"]!,
              sidePadding: true,
            ),
            SizedBox(height: 10),
            textRowHeader(tr('info.openHours.ottosLivingRoom.title')),
            twoTextRow(
              tr('info.openHours.ottosLivingRoom.day1'),
              kServiceOpeningHours["ottosLivingRoom"]!["day1"]!,
              sidePadding: true,
            ),
            twoTextRow(
              tr('info.openHours.ottosLivingRoom.day2'),
              kServiceOpeningHours["ottosLivingRoom"]!["day2"]!,
              sidePadding: true,
            ),
            SizedBox(height: 10),
            textRowHeader(tr('info.openHours.coffeeCafe.title')),
            twoTextRow(
              tr('info.openHours.coffeeCafe.day1'),
              kServiceOpeningHours["coffeeCafe"]!["day1"]!,
              sidePadding: true,
            ),
            twoTextRow(
              tr('info.openHours.coffeeCafe.day2'),
              kServiceOpeningHours["coffeeCafe"]!["day2"]!,
              sidePadding: true,
            ),
            twoTextRow(
              tr('info.openHours.coffeeCafe.day3'),
              kServiceOpeningHours["coffeeCafe"]!["day3"]!,
              sidePadding: true,
            ),
            SizedBox(height: 20),
            SizedBox(height: 1, child: Divider(color: colorBlack)),
            SizedBox(height: 20),
            textRowHeader(tr('info.stores.store1.title')),
            twoTextRow(
              tr('info.stores.store1.day1'),
              kStoreOpeningHours["store1"]!["day1"]!,
              sidePadding: true,
            ),
            SizedBox(height: 10),
            textRowHeader(tr('info.stores.store2.title')),
            twoTextRow(
              tr('info.stores.store2.day1'),
              kStoreOpeningHours["store2"]!["day1"]!,
              sidePadding: true,
            ),
            SizedBox(height: 10),
            textRowHeader(tr('info.stores.store3.title')),
            twoTextRow(
              tr('info.stores.store3.day1'),
              kStoreOpeningHours["store3"]!["day1"]!,
              sidePadding: true,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );

Widget _buildSafeFastavalCard() => textAndIconCard(
      tr('info.safe.title'),
      Icons.phone,
      Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 24, 16),
        child: Column(
          children: [
            twoTextRowWithTapAction(
              tr('info.safe.dutyGeneral'),
              kDutyGeneralPhoneNumber["name"]!,
              Uri(scheme: 'tel', path: kDutyGeneralPhoneNumber["value"]),
            ),
            SizedBox(height: 10),
            twoTextRowWithTapAction(
              tr('info.safe.heroForce'),
              kHeroForcePhoneNumber["name"]!,
              Uri(scheme: 'tel', path: kHeroForcePhoneNumber["value"]),
            ),
            SizedBox(height: 10),
            twoTextRowWithTapAction(
              tr('info.safe.safetyHost'),
              kSafetyHostPhoneNumber["name"]!,
              Uri(scheme: 'tel', path: kSafetyHostPhoneNumber["value"]),
            ),
            SizedBox(height: 10),
            twoTextRowWithTapAction(
              tr('info.safe.safetyMail'),
              kSafeFastavalMail,
              Uri(scheme: 'mailto', path: kSafeFastavalMail),
            ),
          ],
        ),
      ),
    );

Widget _buildTransportCard() => textAndIconCard(
      tr('info.transportAndParking.title'),
      Icons.local_parking,
      Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 24, 16),
        child: Column(
          children: [
            Text(tr('info.transportAndParking.text'), style: kNormalTextStyle),
            SizedBox(height: 20),
            twoTextRowWithTapAction(
              tr('info.transportAndParking.taxi1'),
              kTaxi1PhoneNumber['name']!,
              Uri(scheme: 'tel', path: kTaxi1PhoneNumber['value']),
            ),
            SizedBox(height: 20),
            twoTextRowWithTapAction(
              tr('info.transportAndParking.taxi2'),
              kTaxi2PhoneNumber['name']!,
              Uri(scheme: 'tel', path: kTaxi2PhoneNumber['value']),
            ),
          ],
        ),
      ),
    );

Widget _buildWifiCard() => textAndIconCard(
      tr('info.wifi.title'),
      Icons.wifi,
      Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            twoTextRow(tr('info.wifi.networkName'), kWifiNetworkName),
            SizedBox(height: 10),
            Text(tr('info.wifi.explainer'), style: kNormalTextStyle),
          ],
        ),
      ),
    );
