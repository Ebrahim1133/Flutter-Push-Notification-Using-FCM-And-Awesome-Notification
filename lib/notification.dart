import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'notification_messages.dart';

Future<void> messageHandler(RemoteMessage message) async {
  Data notificationMessage = Data.fromJson(message.data);
  print('notification from background : ${notificationMessage.title}');
  AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: 123,
        channelKey: 'call_channel',
        color: Colors.white,
        title: notificationMessage.title,
        body: notificationMessage.message,
        category: NotificationCategory.Message,
        wakeUpScreen: true,
        fullScreenIntent: true,
        autoDismissible: false,
        backgroundColor: Colors.orange),
  );
}

void firebaseMessagingListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Data notificationMessage = Data.fromJson(message.data);
    print('notification from foreground : ${notificationMessage.title}');
  });
}

Future<void> sendNotification() async {
  const postUrl = 'https://fcm.googleapis.com/fcm/send';
  Dio dio = Dio();

  var token = await getDeviceToken();
  print('device token : $token');

  final data = {
    "data": {
      "message": "Accept Ride Request",
      "title": "This is Ride Request",
    },
    "to": token
  };

  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers["Authorization"] =
      'key= put your key';

  try {
    final response = await dio.post(postUrl, data: data);

    if (response.statusCode == 200) {
      print('Request Sent To Driver');
    } else {
      print('notification sending failed');
    }
  } catch (e) {
    print('exception $e');
  }
}

Future<String?> getDeviceToken() async {
  return await FirebaseMessaging.instance.getToken();
}
