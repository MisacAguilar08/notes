import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Map<int, String> listNotification = {
  0: "everyMinute",
  1: "hourly",
  2: "daily",
  3: "weekly",
  4: "none"
};

Map<int, RepeatInterval> notificationOption = {
  0: RepeatInterval.everyMinute,
  1: RepeatInterval.hourly,
  2: RepeatInterval.daily,
  3: RepeatInterval.weekly,
};