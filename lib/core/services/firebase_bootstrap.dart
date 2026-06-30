import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
    } on FirebaseException catch (error) {
      _isInitialized = false;
      debugPrint('Firebase startup skipped: ${error.message}');
    } catch (error) {
      _isInitialized = false;
      debugPrint('Firebase startup skipped: $error');
    }
  }
}
