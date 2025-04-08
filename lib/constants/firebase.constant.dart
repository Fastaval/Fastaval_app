import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAYfeO9vOnHlm4RikA7eEbmFmRXmSnwitk',
    appId: '1:998751652413:web:76c4d76c9b3c0aade67854',
    messagingSenderId: '998751652413',
    projectId: 'fastaval-it',
    authDomain: 'fastaval-it.firebaseapp.com',
    storageBucket: 'fastaval-it.appspot.com',
    measurementId: 'G-6DMQGHY748',
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBEkmeEFlapNnW_VEvNzhCzrmZ9RSGcDk4',
    appId: '1:998751652413:android:eeb224c27a4fc564e67854',
    messagingSenderId: '998751652413',
    projectId: 'fastaval-it',
    storageBucket: 'fastaval-it.appspot.com',
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUR48lZrkRKb3DVLPLMGiTZP4ImFvN_xc',
    appId: '1:998751652413:ios:97a588cd97e45cc5e67854',
    messagingSenderId: '998751652413',
    projectId: 'fastaval-it',
    storageBucket: 'fastaval-it.appspot.com',
    iosClientId:
        '998751652413-t3scq75i98cff1unkamf0dnlqvjmepcp.apps.googleusercontent.com',
    iosBundleId: 'dk.fastaval.fastavappen',
  );
}
