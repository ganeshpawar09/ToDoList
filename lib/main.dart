import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todolist/const/theme.dart';
import 'package:todolist/pages/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/provider/notification.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  NotificationManager notificationManager =
      NotificationManager(notificationsPlugin);
  notificationManager.initializeNotifications();
  runApp(ProviderScope(child: ToDoList()));
}

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  bool isDarkModeEnabled = true;

  void toggleTheme() {
    setState(() {
      isDarkModeEnabled = !isDarkModeEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        isDarkModeEnabled: isDarkModeEnabled,
        toggleTheme: toggleTheme,
      ),
      // themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      // showSemanticsDebugger: true,
      theme: Themes.light,
      darkTheme: Themes.dark,
    );
  }
}
