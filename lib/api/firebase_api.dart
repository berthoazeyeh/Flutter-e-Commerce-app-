import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> handleBackgroundNotification(RemoteMessage message) async {
  print(message.notification?.title);
  print(message.notification?.title);
  print(message.notification?.title);
}

class FirebaseApi {
  final _firebaseInstance = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> handleNotification(RemoteMessage? message) async {
    print("object-------------------------------------------------");
    // if (message != null) {
    //   print(message.notification?.title);
    // }
  }

  static Future<void> sendMessageToFcmRegistrationToken(String token) async {
    //  String registrationToken = "REPLACE_WITH_FCM_REGISTRATION_TOKEN";
    //  Message message =
    //      Message.builder()
    //          .putData("FCM", "https://firebase.google.com/docs/cloud-messaging")
    //          .putData("flutter", "https://flutter.dev/")
    //          .setNotification(
    //              Notification.builder()
    //                  .setTitle("Try this new app")
    //                  .setBody("Learn how FCM works with Flutter")
    //                  .build())
    //          .setToken(registrationToken)
    //          .build();

    //  FirebaseMessaging.instance.sendMessage(to: token);

    //  .send(message);

    //  System.out.println("Message to FCM Registration Token sent successfully!!");

    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // await messaging.subscribeToTopic send();
  }

  Future<void> initNotification() async {
    NotificationSettings settings = await _firebaseInstance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print(settings.authorizationStatus == AuthorizationStatus.authorized);
    // String? token = await _firebaseInstance.getToken();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);
    initPushNotification();
    initLocalNotification();
  }

  Future<void> initLocalNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings("playstore");
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {},
    );
  }

  Future showPushNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    notificationPlugin.show(id, title, body, await notificationDetails());
  }

  Future<void> initPushNotification() async {
    await _firebaseInstance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    _firebaseInstance.getInitialMessage().then(handleNotification);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!00000000000');
        print('Message data00000000000: ${message}');
      }

      if (message.notification != null) {
        showPushNotification(
            body: '${message.notification!.body?.toString()}',
            title: message.notification!.title.toString(),
            id: 90);
        log('Message also contained 4444a notification0000000000: ${message.notification!.title.toString()}');
        log('Message also contained 4444a notification0000000000: ${message.notification!.body.toString()}');
        log('Message also contained 4444a notification0000000000: ${message.notification!.bodyLocArgs.toString()}');
        log('Message also contained 4444a notification0000000000: ${message.notification!.bodyLocKey.toString()}');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!00000000000');
        print('Message data00000000000: ${message}');
      }

      if (message.notification != null) {
        showPushNotification(
            body: '${message.notification!.body?.toString()}',
            title: message.notification!.title.toString(),
            id: 90);
        log('Message also contained a notification0000000000: ${message.notification!.title.toString()}');
        log('Message also contained a notification0000000000: ${message.notification!.body.toString()}');
        log('Message also contained a notification0000000000: ${message.notification!.bodyLocArgs.toString()}');
        log('Message also contained a notification0000000000: ${message.notification!.bodyLocKey.toString()}');
      }
    });
    FirebaseMessaging.onBackgroundMessage(handleBackgroundNotification);
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails("channelId", "channelName",
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future<void> sendNotification(
      String deviceToken, String title, String body) async {
    try {
      final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      final headers = {
        'Authorization':
            'key=AAAAnDrf5TM:APA91bG_tF0SrqC-NTYaWCERBwJoeoIhcW_UbI6IP0N91YbzYWW4_hRJmRlRW_HqUaF_yo5DgJ-RcObJt4b1Uy6eBqK0M3ChqdZsMcxHHaoMYW8LnnsbHE-kQnQADKmuA_3sCpYtmkG2',
        'Content-Type': 'application/json',
      };
      final data = {
        'to': deviceToken,
        'notification': {'title': title, 'body': body},
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Notification envoyée avec succès! ${response}');
      } else {
        print(
            'Échec de l\'envoi de la notification. Code d\'erreur: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de l\'envoi de la notification-----------------: $e ');
    }
  }
}
