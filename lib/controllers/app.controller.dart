import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/models/user.model.dart';
import 'package:fastaval_app/services/user.service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final fetchingUser = false.obs;
  final loggedIn = false.obs;
  final navIndex = 1.obs;
  late User user;
  final userUpdateTime = 0.obs;

  updateLoggedIn(bool status) {
    loggedIn(status);
  }

  updateNavIndex(int index) {
    navIndex(index);
  }

  updateUser(User newUser) {
    user = newUser;
    userUpdateTime((DateTime.now().millisecondsSinceEpoch / 1000).round());
  }

  init() async {
    await UserService().getUserFromStorage().then(
          (newUser) => {
            if (newUser != null) {updateUser(newUser), updateLoggedIn(true)},
          },
        );
  }

  updateUserProfile() async {
    fetchingUser(true);
    User newUser = await fetchUser(user.id.toString(), user.password);
    newUser.password = user.password;

    await UserService().setUser(newUser);
    updateUser(newUser);
    fetchingUser(false);
  }

  Future<void> login(String id, String password) async {
    try {
      User newUser = await fetchUser(id, password);
      newUser.password = password;
      updateUser(newUser);
      updateLoggedIn(true);
      await UserService().setUser(newUser);
      await UserService().registerToInfosys(newUser);
      updateNavIndex(0);
    } catch (error) {
      Fluttertoast.showToast(msg: tr('error.login'));
    }
  }

  logout() {
    UserService().removeUser();
    user.id = 0;
    user.password = '';
    loggedIn(false);
    updateNavIndex(0);
    Fluttertoast.showToast(msg: tr('logout.message'));
  }
}
