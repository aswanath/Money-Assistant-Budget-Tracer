import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/model_class.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/services.dart';

import 'onBoardingScreens/bottom_navigation_bar.dart';
import 'onBoardingScreens/on_boarding_one_screen.dart';

const boxCat = 'category_box';
const boxTrans = 'transaction_box';
late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Category>(boxCat);
  await Hive.openBox<Transaction>(boxTrans);
  prefs = await SharedPreferences.getInstance();
  AwesomeNotifications().initialize(
    'resource://drawable/res_splash',
    [
      NotificationChannel(
        playSound: false,
        enableVibration: false,
        icon: 'resource://drawable/res_splash',
        channelKey: 'persistent_notification',
        channelName: 'Persistent Notification',
        channelDescription: 'Showing permanent notification',
        importance: NotificationImportance.Max,
        channelShowBadge: true,
      )
    ],
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
      ),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: prefs.getBool('isViewed') == true
          ? const NavigationBarScreen()
          : const ScreenOnboardingOne(),
    );
  }
}
