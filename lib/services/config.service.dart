import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

String baseUrl = ConfigService.instance.getRemoteConfig('API');

class ConfigService {
  ConfigService._privateConstructor();

  static final ConfigService instance = ConfigService._privateConstructor();
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  initConfig() async {
    await _remoteConfig.setDefaults({
      'API': 'https://infosys.fastaval.dk/api',
      'APItest': 'https://infosys-test.fastaval.dk/api',
      'dates': "[]",
      'info_screen_boxes': "[]"
    });
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(minutes: 1),
        minimumFetchInterval: Duration(hours: 1),
      ),
    );
    await _remoteConfig.fetchAndActivate();
  }

  String getRemoteConfig(String string) {
    return _remoteConfig.getString(string);
  }

  List<String> getDates() {
    String datesJson = _remoteConfig.getString('dates');
    List<dynamic> datesList = jsonDecode(datesJson);
    return datesList.map((date) => date.toString()).toList();
  }
}
