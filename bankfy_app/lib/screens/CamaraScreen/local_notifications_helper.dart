import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

NotificationDetails get _ongoing {
  final androidChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: true,
    autoCancel: true    
  );
  final iOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(androidChannelSpecifics, iOSChannelSpecifics);
}

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
    @required String title,
    @required String body,
    @required NotificationAppLaunchDetails type,
    int id = 0,
  }
) => _showNotification(notifications, title: "Se hizo una transaccion", body: "Alguien ha visto Gundam? :V", type: _ongoing);


Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
    @required String title,
    @required String body,
    @required NotificationDetails type,
    int id = 0,
  }
) => notifications.show(id, title, body, type);