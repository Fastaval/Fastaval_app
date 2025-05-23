import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:fastaval_app/controllers/boardgame.controller.dart';
import 'package:fastaval_app/models/user.model.dart';
import 'package:fastaval_app/services/user.service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppController extends GetxController {
  final fetchingUser = false.obs;
  final loggedIn = false.obs;
  final navIndex = 1.obs;
  final userUpdateTime = 0.obs;
  final Rx<PackageInfo?> packageInfo = Rx<PackageInfo?>(null);
  User user = User();

  updateLoggedIn(bool status) {
    loggedIn(status);
  }

  updateNavIndex(int index) {
    navIndex(index);
  }

  updateUser(User updatedUser) {
    user = updatedUser;
    userUpdateTime((DateTime.now().millisecondsSinceEpoch / 1000).round());
  }

  Future<void> fetchPackageInfo() async {
    try {
      packageInfo.value = await PackageInfo.fromPlatform();
    } catch (e) {
      print('Failed to get package info: $e');
    }
  }

  init() async {
    await fetchPackageInfo();
    await UserService().getUserFromStorage().then(
          (newUser) => {
            if (newUser != null) {updateUser(newUser), updateLoggedIn(true)},
          },
        );
    await updateUserProfile();
  }

  updateUserProfile() async {
    if (user.id == 0) return;

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
      Get.find<BoardGameController>().fetchAndSetInitialRankings();
    } catch (error) {
      Fluttertoast.showToast(msg: tr('error.login'));
    }
  }

  logout() {
    var boardCtrl = Get.find<BoardGameController>();
    UserService().removeUser();
    user.id = 0;
    user.password = '';
    loggedIn(false);
    updateNavIndex(0);
    Fluttertoast.showToast(msg: tr('logout.message'));

    boardCtrl.availableBoardgames.clear();
    boardCtrl.chosenBoardgames.clear();
  }
}
