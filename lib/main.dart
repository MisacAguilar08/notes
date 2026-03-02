
import 'package:flutter/material.dart';
import 'package:notes/app/pages/task_list/task_provider.dart';
import 'package:notes/app/services/notifications.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService ns = NotificationService();
  await ns.init();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => TaskProvider()..fetchTasks()),
  ],
  child: MyApp(),));
}
