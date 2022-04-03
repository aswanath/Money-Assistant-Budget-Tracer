import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:money_assistant_final/iconFont/my_flutter_app_icons.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:money_assistant_final/mainScreens/screen_category.dart';
import 'package:money_assistant_final/mainScreens/screen_settings.dart';
import 'package:money_assistant_final/mainScreens/screen_statistics.dart';
import 'package:money_assistant_final/mainScreens/screen_transactions.dart';
import 'package:money_assistant_final/subScreens/add_category_screen.dart';
import 'package:money_assistant_final/subScreens/add_transaction_screen.dart';

import '../main.dart';
import '../notification.dart';

class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen>
    with TickerProviderStateMixin {
  int indexNav = 0;
  final List<Widget> _pageList = [
    const TransactionsPage(),
    const StatisticsPage(),
    const CategoryPage(),
    const SettingsPage(),
  ];
  final PageController pageController = PageController();
  @override
  void initState() {
    if (prefs.getBool('notification')!) {
      createPersistentNotification();
    }
    AwesomeNotifications().displayedStream.listen((event) async {
      if (event.id == 0) {
        await AwesomeNotifications().resetGlobalBadge();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Visibility(
        visible: indexNav == 0 || indexNav == 2 ? true : false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            foregroundColor: commonWhite,
            backgroundColor: secondaryPurple,
            onPressed: () {
              indexNav == 0
                  ? Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddTransactionPage()))
                  : showDialog(
                      context: context,
                      builder: (context) => AddCategoryPage());
            },
            child: const Icon(
              Icons.add,
              size: 32,
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: FloatingNavbar(
            margin:  EdgeInsets.fromLTRB(deviceWidth*.02, 0, deviceWidth*.02, deviceWidth*.025),
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            borderRadius: 15,
            backgroundColor: secondaryPurple,
            selectedItemColor: commonWhite,
            selectedBackgroundColor: null,
            items: [
              FloatingNavbarItem(
                  customWidget: Column(
                children: [
                  Icon(
                    MyFlutterApp.book,
                    color: commonWhite,
                    size: 22,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Visibility(
                    child: FittedBox(
                      child: CustomText(
                          textData: 'Transactions',
                          textSize: 10,
                          textColor: commonWhite),
                    ),
                    visible: indexNav == 0 ? true : false,
                  )
                ],
              ),
              ),
              FloatingNavbarItem(
                  customWidget: Column(
                children: [
                  Icon(MyFlutterApp.chart_pie, color: commonWhite, size: 22),
                  const SizedBox(
                    height: 2,
                  ),
                  Visibility(
                    child: FittedBox(
                      child: CustomText(
                        textData: 'Statistics',
                        textColor: commonWhite,
                        textSize: 10,
                      ),
                    ),
                    visible: indexNav == 1 ? true : false,
                  )
                ],
              ),
              ),
              FloatingNavbarItem(
                  customWidget: Column(
                children: [
                  Icon(MyFlutterApp.boxes, color: commonWhite, size: 22),
                  const SizedBox(
                    height: 2,
                  ),
                  Visibility(
                    child: FittedBox(
                      child: CustomText(
                          textData: 'Category',
                          textSize: 10,
                          textColor: commonWhite),
                    ),
                    visible: indexNav == 2 ? true : false,
                  )
                ],
              )),
              FloatingNavbarItem(
                  customWidget: Column(
                children: [
                  Icon(MyFlutterApp.cog, color: commonWhite, size: 22),
                  const SizedBox(
                    height: 2,
                  ),
                  Visibility(
                    child: FittedBox(
                      child: CustomText(
                          textData: 'Settings',
                          textSize: 10,
                          textColor: commonWhite),
                    ),
                    visible: indexNav == 3 ? true : false,
                  )
                ],
              ),
              ),
            ],
            currentIndex: indexNav,
            onTap: (val) {
                // indexNav = val;
              pageController.animateToPage(val, duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
            }),
      ),
      backgroundColor: commonWhite,
      body: PageView(
        scrollBehavior: MyBehavior(),
      padEnds: false,
        onPageChanged: (val){
          setState(() {
            indexNav = val;
          });
        },
        controller: pageController,
        children: _pageList,
      ),
    );
  }
}
