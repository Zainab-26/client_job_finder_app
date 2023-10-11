// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

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
        return macos;
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
    apiKey: 'AIzaSyAKbpEy7Hqhel9jBrKpBR2nsSncSWbdm_k',
    appId: '1:703009119315:web:e45deca517ee2ee521baa6',
    messagingSenderId: '703009119315',
    projectId: 'cp-project-job-finder',
    authDomain: 'cp-project-job-finder.firebaseapp.com',
    storageBucket: 'cp-project-job-finder.appspot.com',
    measurementId: 'G-MYSWY7NJLS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbZ2ZeRML0jXZlBWPVtutwCvDTzHp-Oxk',
    appId: '1:703009119315:android:0396308dbfc8e91021baa6',
    messagingSenderId: '703009119315',
    projectId: 'cp-project-job-finder',
    storageBucket: 'cp-project-job-finder.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAyhhXD8Q_CZGRx13dQ-DHJCIz-IzXN7dc',
    appId: '1:703009119315:ios:406f544368378e4421baa6',
    messagingSenderId: '703009119315',
    projectId: 'cp-project-job-finder',
    storageBucket: 'cp-project-job-finder.appspot.com',
    iosClientId:
        '703009119315-8hlfhdudnnc8i8nehhie8iai0uoepcfb.apps.googleusercontent.com',
    iosBundleId: 'com.example.clientCpFinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAyhhXD8Q_CZGRx13dQ-DHJCIz-IzXN7dc',
    appId: '1:703009119315:ios:406f544368378e4421baa6',
    messagingSenderId: '703009119315',
    projectId: 'cp-project-job-finder',
    storageBucket: 'cp-project-job-finder.appspot.com',
    iosClientId:
        '703009119315-8hlfhdudnnc8i8nehhie8iai0uoepcfb.apps.googleusercontent.com',
    iosBundleId: 'com.example.clientCpFinal',
  );
}
