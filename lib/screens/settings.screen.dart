import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/settings.controller.dart';
import 'package:fastaval_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  final settingsCtrl = Get.find<SettingsController>();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: commonAppBar(
        title: tr('settings.title'),
      ),
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: backgroundBoxDecorationStyle,
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [settingsCard(tr('common.language'), Icons.language)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget settingsCard(String title, IconData icon) {
    return Card(
      surfaceTintColor: Colors.white,
      color: Colors.white,
      margin: kMenuCardMargin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.black12, width: 1),
      ),
      elevation: 1,
      child: Column(
        children: [
          ListTile(
            trailing: DropdownButton(
              items: [
                DropdownMenuItem(value: 'da', child: Text('Dansk')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              value: settingsCtrl.language.value,
              onChanged: (Object? value) => {
                settingsCtrl.updateLanguage(value as String),
              },
            ),
            title: Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Icon(icon),
                ),
                Text(title, style: kMenuCardHeaderStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
