import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/constants/styles.constant.dart';
import 'package:fastaval_app/controllers/app.controller.dart';
import 'package:fastaval_app/controllers/notification.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController userIdInput = TextEditingController();
  final TextEditingController passwordInput = TextEditingController();
  final appCtrl = Get.find<AppController>();
  final notificationCtrl = Get.find<NotificationController>();

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorOrangeDark,
        foregroundColor: colorWhite,
        toolbarHeight: 40,
        centerTitle: true,
        titleTextStyle: kAppBarTextStyle,
        title: Text(tr('screenTitle.login')),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: backgroundBoxDecorationStyle,
        child: Padding(
          padding: EdgeInsets.fromLTRB(48, 100, 48, 0),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildUserIdInput(),
                SizedBox(height: 16),
                _buildPasswordInput(),
                SizedBox(height: 48),
                _buildLoginButton(),
                SizedBox(height: 16),
                Text(tr('login.helpTitle'), style: kLabelStyle),
                Text(textAlign: TextAlign.center, tr('login.helpText')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async => {
            HapticFeedback.heavyImpact(),
            await appCtrl.login(userIdInput.text, passwordInput.text),
            if (appCtrl.loggedIn.value == true)
              notificationCtrl.getNotificationsAndSetWaiting(),
          },
          child: Text(
            tr('login.signIn'),
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  Widget _buildPasswordInput() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(tr('login.password'), style: kLabelStyle),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kTextBoxDecorationStyle,
            height: 60,
            child: TextField(
              controller: passwordInput,
              keyboardType: TextInputType.number,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                hintText: tr('login.enterPassword'),
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      );

  Widget _buildUserIdInput() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(tr('login.participantNumber'), style: kLabelStyle),
          SizedBox(height: 1),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kTextBoxDecorationStyle,
            height: 60,
            child: TextField(
              controller: userIdInput,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.portrait, color: Colors.white),
                hintText: tr('login.enterParticipantNumber'),
                hintStyle: kHintTextStyle,
              ),
            ),
          ),
        ],
      );
}
