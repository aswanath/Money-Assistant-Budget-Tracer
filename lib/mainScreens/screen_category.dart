import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/customWidgets/sized_box_custom.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:money_assistant_final/main.dart';
import 'package:money_assistant_final/subScreens/delete_confirmation_dialog.dart';
import 'package:money_assistant_final/subScreens/edit_category_screen.dart';
import '../model/model_class.dart';

late int controllerIndex = 0;

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin {
  Color? tabColor = incomeBlue;
  TabController? tabController;

  @override
  void initState() {
    controllerIndex = 0;
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: commonWhite,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Builder(
                builder: (BuildContext context) {
                  tabController = DefaultTabController.of(context)!;
                  tabController!.addListener(() {
                    setState(() {
                      controllerIndex = tabController!.index;
                      if (tabController!.index == 1) {
                        tabColor = expenseRed;
                      } else {
                        tabColor = incomeBlue;
                      }
                    });
                  });
                  return Column(
                    children: [
                      TabBar(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, top: 40, bottom: 20),
                        indicator: BoxDecoration(
                            color: tabColor,
                            borderRadius: BorderRadius.circular(7)),
                        labelColor: commonWhite,
                        unselectedLabelColor: commonBlack,
                        tabs: [
                          Tab(
                            child: CustomText(textData: 'INCOME', textSize: 18,textWeight: FontWeight.w600,),
                          ),
                          Tab(
                            child: CustomText(textData: 'EXPENSE', textSize: 18,textWeight: FontWeight.w600,),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: Hive.box<Category>(boxCat).listenable(),
                builder: (BuildContext context, Box<Category> newBox,
                    Widget? child) {
                  List<Category> _incomeList = checkIncome(newBox);
                  List<Category> _expenseList = checkExpense(newBox);
                  return Expanded(
                    child: (tabController!.index == 0
                            ? _incomeList.isEmpty
                            : _expenseList.isEmpty)
                        ? Center(
                            child: CustomText(
                              textData: 'No Categories Added',
                              textSize: 18,
                            ),
                          )
                        : ListView.separated(
                            itemCount: tabController!.index == 0
                                ? _incomeList.length
                                : _expenseList.length,
                            itemBuilder: (context, index) {
                              return CustomSizedBox(
                                widthRatio: 1,
                                heightRatio: .06,
                                widgetChild: DecoratedBox(
                                  decoration: BoxDecoration(color: commonWhite),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          // heightRatio: .06,
                                          child: CustomText(
                                            textData: tabController!.index == 0
                                                ? _incomeList[index]
                                                    .categoryName
                                                : _expenseList[index]
                                                    .categoryName,
                                            textSize: 18,
                                            maxLines: 1,
                                            textOverflow: TextOverflow.clip,
                                          ),
                                          width: deviceWidth*.62,
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              visualDensity:
                                                  VisualDensity.compact,
                                              splashRadius: .01,
                                              onPressed: () {
                                                int key =
                                                    tabController!.index == 0
                                                        ? _incomeList[index].key
                                                        : _expenseList[index]
                                                            .key;
                                                bool type =
                                                    tabController!.index == 0
                                                        ? _incomeList[index]
                                                            .transactionType
                                                        : _expenseList[index]
                                                            .transactionType;
                                                showDialog(
                                                    context: (context),
                                                    builder: (context) =>
                                                        EditCategoryPage(
                                                          indexKey: key,
                                                          transactionType: type,
                                                        ));
                                              },
                                              icon: Icon(
                                                Icons.edit_outlined,
                                                color: secondaryPurple,
                                              ),
                                            ),
                                            IconButton(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              splashRadius: .01,
                                              onPressed: () {
                                                int key =
                                                    tabController!.index == 0
                                                        ? _incomeList[index].key
                                                        : _expenseList[index]
                                                            .key;
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      DeleteCategoryPage(
                                                    keyCategory: key,
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete_outline_outlined,
                                                color: expenseRed,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return CustomSizedBox(
                                widthRatio: 1,
                                heightRatio: .0005,
                                widgetChild: DecoratedBox(
                                  decoration: BoxDecoration(color: commonBlack),
                                ),
                              );
                            },
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Category> checkIncome(Box<Category> box) {
  List<Category> _list = box.values.toList();
  List<Category> incomeList = [];
  for (int i = 0; i < _list.length; i++) {
    if (_list[i].transactionType == true) {
      incomeList.add(_list[i]);
    }
  }
  return incomeList;
}

List<Category> checkExpense(Box<Category> box) {
  List<Category> _list = box.values.toList();
  List<Category> expenseList = [];
  for (int i = 0; i < _list.length; i++) {
    if (_list[i].transactionType == false) {
      expenseList.add(_list[i]);
    }
  }
  return expenseList;
}
