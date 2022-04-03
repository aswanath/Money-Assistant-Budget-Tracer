import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import '../globalUsageValues.dart';
import '../main.dart';
import '../model/model_class.dart';
import '../notification.dart';

class DeleteCategoryPage extends StatelessWidget {
  final int? keyCategory;
  final int? keyTransaction;
  var categoryBox = Hive.box<Category>(boxCat);
  var transactionBox = Hive.box<Transaction>(boxTrans);

  DeleteCategoryPage({Key? key, this.keyCategory, this.keyTransaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: CustomText(
        textData: 'Do you want to delete it?',
        textSize: 18,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context,false);
          },
          child: CustomText(textData: "NO", textSize: 18,textColor: secondaryPurple,),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: TextButton(
            onPressed: () {
              if (keyCategory == null) {
                transactionBox.delete(keyTransaction);
                Navigator.pop(context,true);
                createPersistentNotification();
              } else {
                if (!checkTransaction(keyCategory!)) {
                  categoryBox.delete(keyCategory);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      elevation: 10,
                      behavior: SnackBarBehavior.fixed,
                      backgroundColor: secondaryPurple,
                      content: CustomText(
                        textData: 'Transactions with this Category exists',
                        textSize: 16,
                        textColor: commonWhite,
                      ),
                    ),
                  );
                }
              }
            },
            child: CustomText(textData: 'YES', textSize: 18,textColor: secondaryPurple,),
          ),
        )
      ],
    );
  }

  bool checkTransaction(int key) {
    String _name = categoryBox.get(key)!.categoryName;
    List<Transaction> check = transactionBox.values
        .where((element) => element.category.contains(_name))
        .toList();
    return check.isEmpty ? false : true;
  }
}
