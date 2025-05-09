// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAGSD_JktzXR5OwzrcNZZQVwxMBnot4Byo',
    appId: '1:936496190525:web:c01d7c6b899ccbb6a08654',
    messagingSenderId: '936496190525',
    projectId: 'programovilocta',
    authDomain: 'programovilocta.firebaseapp.com',
    storageBucket: 'programovilocta.firebasestorage.app',
    measurementId: 'G-G87QTKDC1B',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcMg27u073ATOuKZp7vguGMLMf_PWzRUg',
    appId: '1:936496190525:android:0b0c8f987044699ca08654',
    messagingSenderId: '936496190525',
    projectId: 'programovilocta',
    storageBucket: 'programovilocta.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAvdOOGPQoc3tbejovNL47bbmDWLLqwfqk',
    appId: '1:936496190525:ios:c086eb8714ea577ca08654',
    messagingSenderId: '936496190525',
    projectId: 'programovilocta',
    storageBucket: 'programovilocta.firebasestorage.app',
    iosBundleId: 'com.example.flutterApplication1',
  );
}
