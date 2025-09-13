// File: lib/firebase_options.dart
// GENERATED FILE - DO NOT MODIFY

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      // ถ้ามี iOS หรือ Web ต้องเพิ่ม config ตรงนี้
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLL2RV_-FivcrkJfAE4bAg2VZi8-DciMU',
    appId: '1:888721889364:android:a6fe095f5cb4d78029f5c1',
    messagingSenderId: '888721889364',
    projectId: 'nekonime11-8d137',
    storageBucket: 'nekonime11-8d137.firebasestorage.app',
  );

}