import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/customWidgets/settings_list.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:money_assistant_final/main.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/model_class.dart';
import '../notification.dart';
import 'package:share_plus/share_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: commonWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.notifications_none_outlined,
                              color: commonBlack,
                            ),
                            const CustomSizedBox(
                              widthRatio: .04,
                            ),
                            CustomText(textData: 'Notification', textSize: 18),
                          ],
                        ),
                        FlutterSwitch(
                          value: prefs.getBool('notification')!,
                          onToggle: (val) {
                            if (val == false) {
                              setState(() {
                                AwesomeNotifications().cancelAll().then((_) =>
                                    prefs.setBool('notification', false));
                                AwesomeNotifications().resetGlobalBadge();
                              });
                            } else {
                              setState(() {});
                              requestNotificationPermission();
                            }
                          },
                          width: 44,
                          height: 22,
                          activeColor: secondaryPurple,
                          inactiveColor: commonBlack,
                          padding: 2.5,
                          toggleSize: 20,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: const SettingsListItems(
                        iconData: Icons.cleaning_services_outlined,
                        string: 'Reset everything'),
                    onTap: _clearEverything,
                  ),
                  GestureDetector(
                    child: const SettingsListItems(
                        iconData: Icons.share_outlined, string: 'Share'),
                    onTap: _shareApp,
                  ),
                  GestureDetector(
                    child: const SettingsListItems(
                        iconData: Icons.rate_review_outlined,
                        string: 'Write a review'),
                    onTap: _launchPlaystore,
                  ),
                  GestureDetector(
                      child: const SettingsListItems(
                          iconData: Icons.feedback_outlined,
                          string: 'Feedback'),
                      onTap: _launchMail),
                  GestureDetector(
                    child: const SettingsListItems(
                        iconData: Icons.privacy_tip_outlined,
                        string: 'Privacy Policy'),
                    onTap: _launchPrivacyPolicy,
                  ),
                  GestureDetector(
                    child: const SettingsListItems(
                        iconData: Icons.info_outline, string: 'About Us'),
                    onTap: _aboutUs,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CustomText(
                    textData: 'Version 1.2',
                    textSize: 16,
                    textColor: secondaryPurple,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void requestNotificationPermission() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: CustomText(
                  textData: 'Allow Notifications',
                  textSize: 20,
                  textColor: secondaryPurple,
                ),
                content: CustomText(
                  textData:
                      'App would need access to notification to send notifications',
                  textSize: 18,
                  textColor: commonBlack,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: CustomText(
                      textData: "Don't allow",
                      textSize: 18,
                      textColor: dateGrey,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      prefs.setBool('notification', true);
                      AwesomeNotifications()
                          .requestPermissionToSendNotifications()
                          .then((checkAllowed) {
                        setState(() {});
                        Navigator.pop(context);
                        createPersistentNotification();
                      });
                    },
                    child: CustomText(
                      textData: 'Allow',
                      textSize: 18,
                      textColor: commonBlack,
                    ),
                  ),
                ],
              );
            });
      } else {
        setState(() {});
        createPersistentNotification();
        prefs.setBool('notification', true);
      }
    });
  }

  void _launchMail() async {
    final String uri =
        'mailto:aswanathck.ramesh@gmail.com?subject=${Uri.encodeFull('Money Assistant app feedback')}&body=${Uri.encodeFull('')}';
    await launch(uri);
  }

  void _launchPrivacyPolicy() async {
    const String uri =
        'https://github.com/aswanath/Money-Assistant/blob/master/README.md';
    await launch(uri);
  }

  void _launchPlaystore() async {
    const String uri =
        'https://play.google.com/store/apps/details?id=in.brototype.money_assistant';
    await launch(uri);
  }

  void _shareApp() async {
    final box = context.findRenderObject() as RenderBox?;
    const String uri =
        'https://play.google.com/store/apps/details?id=in.brototype.money_assistant';
    await Share.share(
        '''Hey, I'm sharing this financial application which help me to control my financial habits and I hope, it will also help you.  Download it!!!

$uri''',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
        subject: "Sharing the #1 financial application");
  }

  void _aboutUs() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
              child: CustomText(
            textData: 'About Me',
            textSize: 20,
            textColor: secondaryPurple,
            textWeight: FontWeight.w600,
          )),
          content: CustomText(
            textAlignment: TextAlign.center,
            textData:
                'I am Aswanath C K from Kerala, India. I am enthusiastic in building application. This app is developed in Flutter',
            textSize: 16,
            textColor: commonBlack,
          ),
        );
      },
    );
  }

  void _clearEverything() {
    int first = randomNumberGenerator();
    int second = randomNumberGenerator();
    TextEditingController textController = TextEditingController();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            title: CustomText(
              textData: 'Making sure it is you',
              textSize: 18,
              textWeight: FontWeight.bold,
              textAlignment: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  textData: 'Add the numbers given below',
                  textSize: 16,
                ),
                const CustomSizedBox(
                  heightRatio: .01,
                ),
                CustomText(
                  textData: '$first + $second',
                  textSize: 18,
                  textWeight: FontWeight.bold,
                ),
                SizedBox(
                  height: deviceHeight * .05,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.top,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(r"[\s,]"),
                      ),
                    ],
                    textAlign: TextAlign.center,
                    controller: textController,
                    cursorColor: secondaryPurple,
                    style: const TextStyle(fontFamily: 'Poppins'),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: secondaryPurple)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: secondaryPurple)),
                    ),
                  ),
                ),
                const CustomSizedBox(
                  heightRatio: .01,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: CustomText(textData: 'Cancel', textSize: 18),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7))),
                          backgroundColor:
                              MaterialStateProperty.all(secondaryPurple),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (int.parse(textController.text) ==
                              first + second) {
                            Hive.box<Transaction>(boxTrans).clear();
                            Hive.box<Category>(boxCat).clear();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: CustomText(
                                  textData: 'Reset Success', textSize: 16),
                              backgroundColor: secondaryPurple,
                            ));
                          }
                        },
                        child: CustomText(textData: 'Reset', textSize: 18),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7))),
                          backgroundColor:
                              MaterialStateProperty.all(secondaryPurple),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  int randomNumberGenerator() {
    var rng = Random();
    int num = 0;
    for (int i = 0; i < 10; i++) {
      num = rng.nextInt(10);
    }
    return num;
  }
}
