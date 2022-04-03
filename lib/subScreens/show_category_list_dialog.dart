import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_assistant_final/customWidgets/custom_separator.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:money_assistant_final/main.dart';
import 'package:money_assistant_final/mainScreens/screen_category.dart';
import 'package:money_assistant_final/subScreens/add_category_screen.dart';
import '../model/model_class.dart';

class ShowCategoryPage extends StatelessWidget {
  const ShowCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      AlertDialog(
        contentPadding: const EdgeInsets.only(
          top: 5,
        ),
        insetPadding: EdgeInsets.zero,
        content: CustomSizedBox(
          widthRatio: 1,
          heightRatio: .4,
          widgetChild: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CustomText(
                      textData: 'CATEGORY',
                      textSize:  20,
                      textColor: secondaryPurple,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AddCategoryPage());
                        },
                        icon: Icon(
                          Icons.add,
                          color: secondaryPurple,
                          size: 30,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.close,
                          color: secondaryPurple,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              CustomSeparator(),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<Category>(boxCat).listenable(),
                  builder: (BuildContext context, Box<Category> newBox,
                      Widget? child) {
                    List<Category> _incomeList = checkIncome(newBox);
                    List<Category> _expenseList = checkExpense(newBox);
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(controllerIndex == 0
                                ? _incomeList[index].categoryName
                                : _expenseList[index].categoryName);
                          },
                          child: Column(
                            children: [
                              CustomSizedBox(
                                widthRatio: 1,
                                heightRatio: .055,
                                widgetChild: DecoratedBox(
                                  decoration: BoxDecoration(color: commonWhite),
                                  child: Center(
                                    child: CustomText(
                                        textData: controllerIndex == 0
                                            ? _incomeList[index].categoryName
                                            : _expenseList[index].categoryName,
                                        textSize: 18),
                                  ),
                                ),
                              ),
                              CustomSeparator(
                                separatorColor: commonBlack,
                                width: .6,
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: controllerIndex == 0
                          ? _incomeList.length
                          : _expenseList.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
