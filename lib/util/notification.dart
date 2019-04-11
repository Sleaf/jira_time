import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  Function onSelect = (String payload) async {
    print('notification payload: ' + payload);
  };
  final _settingsAndroid = AndroidInitializationSettings('launch_background');
  final _settingsIOS = IOSInitializationSettings();
  var _notification;

  display() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    _notification.show(0, '这是一条测试通知【标题】', '这是通知主体', platformChannelSpecifics,
        payload: '可携带数据');
  }

  LocalNotification({this.onSelect}) {
    _notification = FlutterLocalNotificationsPlugin()
      ..initialize(InitializationSettings(_settingsAndroid, _settingsIOS),
          onSelectNotification: onSelect);
  }
}
