// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyDdU_pnVupl2etkYyWQ2zs-f95Usu8kEv0',
    appId: '1:6998541012:web:da8bc221288206e959b141',
    messagingSenderId: '6998541012',
    projectId: 'twitter-b8923',
    authDomain: 'twitter-b8923.firebaseapp.com',
    storageBucket: 'twitter-b8923.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAAIqNGrCeB5j7tYLjCdWNtMLmGGwkCYaM',
    appId: '1:6998541012:android:115d06052c21fd7b59b141',
    messagingSenderId: '6998541012',
    projectId: 'twitter-b8923',
    storageBucket: 'twitter-b8923.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCxnTU1PXDh7pe0x7YCAfUNK9xXIHyMMuk',
    appId: '1:6998541012:ios:89af549cc7c2e07859b141',
    messagingSenderId: '6998541012',
    projectId: 'twitter-b8923',
    storageBucket: 'twitter-b8923.appspot.com',
    iosBundleId: 'com.example.twitter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCxnTU1PXDh7pe0x7YCAfUNK9xXIHyMMuk',
    appId: '1:6998541012:ios:66ca14a01da562a559b141',
    messagingSenderId: '6998541012',
    projectId: 'twitter-b8923',
    storageBucket: 'twitter-b8923.appspot.com',
    iosBundleId: 'com.example.twitter.RunnerTests',
  );
}
