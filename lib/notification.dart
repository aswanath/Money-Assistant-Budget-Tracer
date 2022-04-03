import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:money_assistant_final/main.dart';

import 'mainScreens/screen_transactions.dart';
import 'model/model_class.dart';

Future<void> createPersistentNotification() async {
  await AwesomeNotifications().resetGlobalBadge();
  await AwesomeNotifications().createNotification(
    content: NotificationContent(id: 0,
      channelKey: 'persistent_notification',
      color: Colors.purple,
      title: '💰 TOTAL: ₹${incomeSum(filteredList())-expenseSum(filteredList())}',
      body : '⬇️ INCOME: ₹ ${incomeSum(filteredList())}  ⬆️ EXPENSE: ₹ ${expenseSum(filteredList())}',
      notificationLayout: NotificationLayout.Default,
      autoDismissible: false,
      locked: true,
      displayOnBackground: true,
    ),
    actionButtons: [
      NotificationActionButton(key: 'EDIT', label: 'Close',color: secondaryPurple, autoDismissible: true,buttonType: ActionButtonType.DisabledAction)
    ]
  );
}

List<Transaction> filteredList() {
  var transBox = Hive.box<Transaction>(boxTrans);
  List<Transaction> _filteredList = [];
  List<Transaction> boxList = transBox.values.toList();
  for (int i = 0; i < boxList.length; i++) {
    if (boxList[i].date.month == DateTime.now().month && boxList[i].date.year == DateTime.now().year) {
      _filteredList.add(boxList[i]);
    }
  }
  return _filteredList;
}
