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
    apiKey: 'AIzaSyAAXqGUAOW5WwJaIZmD04pYXfyUt_xU0NM',
    appId: '1:496832788537:web:ffd38a27af50e8126df5e8',
    messagingSenderId: '496832788537',
    projectId: 'video-editing-app-b4ded',
    authDomain: 'video-editing-app-b4ded.firebaseapp.com',
    storageBucket: 'video-editing-app-b4ded.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZjTV-p9CdaKQUEnrDx-B96xv1e6OschQ',
    appId: '1:496832788537:android:b805e3288f4ae3b86df5e8',
    messagingSenderId: '496832788537',
    projectId: 'video-editing-app-b4ded',
    storageBucket: 'video-editing-app-b4ded.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC2tE0ANND9B2rbd5P50vbJwn9JnFDHw6Y',
    appId: '1:496832788537:ios:1c2e563c6b79c1086df5e8',
    messagingSenderId: '496832788537',
    projectId: 'video-editing-app-b4ded',
    storageBucket: 'video-editing-app-b4ded.appspot.com',
    iosBundleId: 'com.sandapp.sandapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC2tE0ANND9B2rbd5P50vbJwn9JnFDHw6Y',
    appId: '1:496832788537:ios:9ea9e6bcfacba9246df5e8',
    messagingSenderId: '496832788537',
    projectId: 'video-editing-app-b4ded',
    storageBucket: 'video-editing-app-b4ded.appspot.com',
    iosBundleId: 'com.sandapp.sandapp.RunnerTests',
  );
}
