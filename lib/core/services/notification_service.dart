import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import 'firebase_providers.dart';

class NotificationService {
  NotificationService(this._messaging, this._firestore);

  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  bool _initialized = false;

  Future<void> initNotifications(String userId, BuildContext context) async {
    if (_initialized) return;
    _initialized = true;

    // 1. Request Permission and FCM Token
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.denied) {
        final token = await _messaging.getToken(vapidKey: AppConstants.vapidKey);
        if (token != null) {
          debugPrint("FCM Registration Token: $token");
          // Save token to user document
          await _firestore.collection('users').doc(userId).update({
            'fcmToken': token,
            'lastLoginAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      debugPrint("FCM initialization failed: $e");
    }

    // 2. Setup Foreground Messaging listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (context.mounted) {
          _showForegroundDialog(
            context,
            message.notification!.title ?? "Priticious Notification",
            message.notification!.body ?? "",
          );
        }
      }
    });

    // 3. Setup Firestore Real-Time Targeted Notifications Listener
    final launchTime = DateTime.now();
    _firestore
        .collection('notifications')
        .where('userId', whereIn: ['all', userId])
        .where('createdAt', isGreaterThan: Timestamp.fromDate(launchTime))
        .snapshots()
        .listen((snapshot) {
          for (final change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.added) {
              final data = change.doc.data();
              if (data != null) {
                final title = data['title'] as String? ?? 'Notification';
                final body = data['body'] as String? ?? '';
                if (context.mounted) {
                  _showForegroundDialog(context, title, body);
                }
              }
            }
          }
        }, onError: (err) {
          debugPrint("Firestore notification listener failed: $err");
        });
  }

  void _showForegroundDialog(BuildContext context, String title, String body) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.orange),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(
    ref.watch(firebaseMessagingProvider),
    ref.watch(firestoreProvider),
  );
});
