import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/main.dart';
import 'package:money_assistant_final/subScreens/details_transaction_screen.dart';
import '../customWidgets/sized_box_custom.dart';
import '../globalUsageValues.dart';
import '../iconFont/my_flutter_app_icons.dart';
import '../model/model_class.dart';

double? totalIncome;
double? totalExpense;

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with TickerProviderStateMixin {
  IconData _changeIcon = Icons.search_outlined;
  late AnimationController _animationController;
  late AnimationController _animationControllerOut;
  DateTime monthYear = DateTime.now();
  String searchText = "";
  String? currentDate;
  String? lastDate;
  late DateTime finalDate;
  late DateTime initialDate;
  String popupItem = 'Monthly';
  var transBox = Hive.box<Transaction>(boxTrans);
  bool isVisible = true;

  @override
  void initState() {
    initialDate = DateTime.now();
    finalDate = DateTime.now();
    currentDate = dateFormatterFull.format(initialDate);
    lastDate = dateFormatterFull.format(finalDate);
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animationController.forward();
    _animationControllerOut = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: commonWhite,
      appBar: AppBar(
        backgroundColor: commonWhite,
        elevation: .5,
        centerTitle: false,
        title: _changeIcon == Icons.search_outlined
            ? CustomText(
                textData: 'Money Assistant',
                textSize: 22,
                textColor: secondaryPurple,
                textWeight: FontWeight.w600,
              )
            : FadeTransition(
                opacity: _animationControllerOut,
                child: Row(
                  children: [
                    CustomSizedBox(
                      widthRatio: .76,
                      heightRatio: .048,
                      widgetChild: DecoratedBox(
                        decoration: BoxDecoration(
                            color: searchTabGrey,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            const CustomSizedBox(
                              widthRatio: .01,
                            ),
                            Icon(
                              Icons.search_outlined,
                              color: secondaryPurple,
                              size: 30,
                            ),
                            const CustomSizedBox(widthRatio: .01,),
                            Container(
                              alignment: Alignment.center,
                              child: TextField(
                                onChanged: (val) {
                                  setState(() {
                                    searchText = val;
                                  });
                                },
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 16),
                                textInputAction: TextInputAction.search,
                                autofocus: true,
                                decoration: null,
                                cursorHeight: 22,
                                cursorColor: commonBlack,
                                textAlignVertical: TextAlignVertical.center,
                              ),
                              width: deviceWidth*.65,
                              height: deviceHeight* .048,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
        actions: [
          Visibility(
              visible: _changeIcon == Icons.search_outlined,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: Icon(
                  Icons.filter_alt_outlined,
                  color: secondaryPurple,
                ),
                splashRadius: 0.01,
              )),
          IconButton(
            splashRadius: 0.01,
            onPressed: () {
              setState(() {
                if (_changeIcon == Icons.search_outlined) {
                  _animationController.reverse();
                  _animationControllerOut.forward();
                  _changeIcon = Icons.close;
                } else {
                  searchText = "";
                  _animationControllerOut.reverse();
                  _animationController.forward();
                  _changeIcon = Icons.search_outlined;
                }
              });
            },
            icon: FadeTransition(
              opacity: _changeIcon == Icons.search_outlined
                  ? _animationController
                  : _animationControllerOut,
              child: Icon(
                _changeIcon,
                color: secondaryPurple,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              visible: isVisible,
              child: CustomSizedBox(
                heightRatio: 0.06,
                widthRatio: 1,
                widgetChild: DecoratedBox(
                  decoration: BoxDecoration(
                    color: commonWhite,
                    border: Border(
                      bottom: BorderSide(color: secondaryPurple, width: .4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      popupItem == 'Period'
                          ? Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDatePicker(
                                        builder: (context, child) {
                                          return Theme(
                                              data: ThemeData(
                                                  colorScheme:
                                                      ColorScheme.light(
                                                          primary:
                                                              secondaryPurple)),
                                              child: child!);
                                        },
                                        context: context,
                                        initialDate: initialDate,
                                        firstDate:
                                            DateTime(DateTime.now().year - 10),
                                        lastDate: DateTime.now(),
                                      ).then(
                                        (value) {
                                          if (value != null) {
                                            initialDate = value;
                                            currentDate = dateFormatterFull
                                                .format(initialDate);
                                            if (value.isAfter(finalDate)) {
                                              finalDate = value;
                                              lastDate = dateFormatterFull
                                                  .format(value);
                                            }
                                            setState(() {});
                                          }
                                        },
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: secondaryPurple,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          CustomText(
                                              textData: '$currentDate ',
                                              textSize: 15),
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: secondaryPurple,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  CustomText(textData: ' ~ ', textSize: 16),
                                  GestureDetector(
                                    onTap: () {
                                      showDatePicker(
                                              builder: (context, child) {
                                                return Theme(
                                                    data: ThemeData(
                                                      colorScheme:
                                                          ColorScheme.light(
                                                              primary:
                                                                  secondaryPurple),
                                                    ),
                                                    child: child!);
                                              },
                                              context: context,
                                              initialDate: finalDate,
                                              firstDate: DateTime(
                                                  DateTime.now().year - 10),
                                              lastDate: DateTime.now())
                                          .then((value) {
                                        setState(() {
                                          if (value != null) {
                                            finalDate = value;
                                            lastDate = dateFormatterFull
                                                .format(finalDate);
                                            if (value.isBefore(initialDate)) {
                                              initialDate = value;
                                              currentDate = dateFormatterFull
                                                  .format(value);
                                            }
                                          }
                                        });
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: secondaryPurple,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          CustomText(
                                              textData:
                                                  '${lastDate ?? dateFormatterFull.format(DateTime.now())} ',
                                              textSize: 15),
                                          Icon(
                                            Icons.calendar_today,
                                            size: 14,
                                            color: secondaryPurple,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Row(
                              children: [
                                const CustomSizedBox(
                                  widthRatio: .01,
                                ),
                                IconButton(
                                  splashRadius: 0.01,
                                  onPressed: () {
                                    setState(
                                      () {
                                        if (popupItem == 'Monthly') {
                                          monthYear = DateTime(monthYear.year,
                                              monthYear.month - 1);
                                        } else if (popupItem == 'Yearly') {
                                          monthYear = DateTime(
                                              monthYear.year - 1,
                                              monthYear.month);
                                        }
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    MyFlutterApp.left_open_outline,
                                    color: secondaryPurple,
                                    size: 20,
                                  ),
                                  visualDensity:
                                      const VisualDensity(horizontal: -4),
                                ),
                                CustomText(
                                    textData: popupItem == 'Monthly'
                                        ? dateFormatterMonth.format(monthYear)
                                        : monthYear.year.toString(),
                                    textColor: commonBlack,
                                    textSize: 16),
                                IconButton(
                                    splashRadius: .01,
                                    onPressed: () {
                                      setState(() {
                                        if (popupItem == 'Monthly') {
                                          monthYear = DateTime(monthYear.year,
                                              monthYear.month + 1);
                                        } else if (popupItem == 'Yearly') {
                                          monthYear = DateTime(
                                              monthYear.year + 1,
                                              monthYear.month);
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      MyFlutterApp.right_open_outline,
                                      color: secondaryPurple,
                                      size: 20,
                                    ),
                                    visualDensity:
                                        const VisualDensity(horizontal: -4)),
                              ],
                            ),
                      PopupMenuButton(
                        onSelected: (val) {
                          if (val != null) {
                            if (val == 'Monthly') {
                              monthYear = DateTime.now();
                              popupItem = val.toString();
                              setState(() {});
                            } else if (val == 'Yearly') {
                              monthYear = DateTime.now();
                              popupItem = val.toString();
                              setState(() {});
                            } else if (val == 'Period') {
                              monthYear = DateTime.now();
                              popupItem = val.toString();
                              setState(() {});
                            }
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: deviceWidth * .03),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                border: Border.all(color: secondaryPurple),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                CustomText(textData: popupItem, textSize: 14),
                                const Icon(Icons.keyboard_arrow_down_outlined)
                              ],
                            ),
                          ),
                        ),
                        initialValue: popupItem,
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child:
                                CustomText(textData: 'Monthly', textSize: 14),
                            value: 'Monthly',
                          ),
                          PopupMenuItem(
                            child: CustomText(textData: 'Yearly', textSize: 14),
                            value: 'Yearly',
                          ),
                          PopupMenuItem(
                            child: CustomText(textData: 'Period', textSize: 14),
                            value: 'Period',
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Transaction>(boxTrans).listenable(),
                builder: (BuildContext context, Box<Transaction> newBox,
                    Widget? child) {
                  List<Transaction> transactionList = popupItem == 'Period'
                      ? periodFilterList(transBox)
                      : (popupItem == 'Monthly'
                          ? filteredLists(newBox)[0]
                          : filteredLists(newBox)[1]);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomSizedBox(
                        heightRatio: .085,
                        widthRatio: .28,
                        widgetChild: Column(
                          children: [
                            CustomText(
                              textData: 'INCOME',
                              textSize: 18,
                              textColor: commonBlack,
                            ),
                            FittedBox(
                              child: CustomText(
                                textData:
                                    '₹ ${incomeSum(transactionList).toStringAsFixed(2)}',
                                textSize: 18,
                                textColor: incomeBlue,
                                textWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomSizedBox(
                        heightRatio: .085,
                        widthRatio: .28,
                        widgetChild: Column(
                          children: [
                            CustomText(
                              textData: 'EXPENSE',
                              textSize: 18,
                              textColor: commonBlack,
                            ),
                            FittedBox(
                              child: CustomText(
                                  textData:
                                      '₹ ${expenseSum(transactionList).toStringAsFixed(2)}',
                                  textSize: 18,
                                  textColor: expenseRed,
                                  textWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      CustomSizedBox(
                        heightRatio: .085,
                        widthRatio: .28,
                        widgetChild: Column(
                          children: [
                            CustomText(
                              textData: 'TOTAL',
                              textSize: 18,
                              textColor: commonBlack,
                            ),
                            FittedBox(
                              child: CustomText(
                                  textData:
                                      '₹ ${(incomeSum(transactionList) - expenseSum(transactionList)).toStringAsFixed(2)}',
                                  textSize: 18,
                                  textColor: commonBlack,
                                  textWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            CustomSizedBox(
              heightRatio: .01,
              widthRatio: 1,
              widgetChild: DecoratedBox(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: secondaryPurple, width: .4),
                )),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box<Transaction>(boxTrans).listenable(),
              builder: (BuildContext context, Box<Transaction> newBox,
                  Widget? child) {
                List<Transaction> filterList = popupItem == 'Period'
                    ? periodFilterList(transBox)
                    : (popupItem == 'Monthly'
                        ? filteredLists(newBox)[0]
                        : filteredLists(newBox)[1]);
                List<Transaction> newTransactionList = filterList
                    .where((element) {
                      if(element.category.toLowerCase().contains(searchText.toLowerCase())){
                        return element.category.toLowerCase().contains(searchText.toLowerCase());
                      }else{
                       return element.notes.toLowerCase().contains(searchText.toLowerCase());
                      }
                      })
                    .toList();
                return Expanded(
                  child: newTransactionList.isEmpty
                      ? Center(
                          child: CustomText(
                              textData: 'No Transactions', textSize: 18))
                      : ListView.builder(
                          itemCount: newTransactionList.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailsTransactionPage(
                                    detailTileKey: newTransactionList[index],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                              child: CustomSizedBox(
                                widthRatio: 1,
                                heightRatio: .065,
                                widgetChild: DecoratedBox(
                                  decoration: BoxDecoration(color: tileGrey),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            //Date of Transaction
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                  width: deviceWidth*.09,
                                                  height: deviceHeight*.022,
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: dateFormatterDay.format(
                                                                    newTransactionList[
                                                                            index]
                                                                        .date) ==
                                                                'Sun'
                                                            ? Colors.redAccent
                                                            : (dateFormatterDay.format(
                                                                        newTransactionList[index]
                                                                            .date) ==
                                                                    'Sat'
                                                                ? Colors.blue
                                                                : dateGrey)),
                                                    child: CustomText(
                                                      textSize: 12,
                                                      textData: dateFormatterDay
                                                          .format(
                                                              newTransactionList[
                                                                      index]
                                                                  .date),
                                                      textAlignment:
                                                          TextAlign.center,
                                                      textColor: commonWhite,
                                                    ),
                                                  ),
                                                ),
                                                const CustomSizedBox(
                                                  heightRatio: .005,
                                                ),
                                                CustomSizedBox(
                                                  widthRatio: .12,
                                                  heightRatio: .022,
                                                  widgetChild: CustomText(
                                                    textAlignment:
                                                        TextAlign.center,
                                                    textData: dateFormatterDate
                                                        .format(
                                                            newTransactionList[
                                                                    index]
                                                                .date),
                                                    textSize: 12,
                                                    textWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        //Transaction Category
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              child: CustomText(
                                                maxLines: 1,
                                                textData:
                                                    newTransactionList[index]
                                                        .category,
                                                textOverflow: TextOverflow.clip,
                                                textSize: 16,
                                                textWeight: FontWeight.w600,
                                                textAlignment: TextAlign.start,
                                              ),
                                              width: deviceWidth*.51,
                                            ),
                                            newTransactionList[index]
                                                    .notes
                                                    .isNotEmpty
                                                ? CustomSizedBox(
                                                    widgetChild: CustomText(
                                                      maxLines: 1,
                                                      textData:
                                                          newTransactionList[
                                                                  index]
                                                              .notes,
                                                      textOverflow:
                                                          TextOverflow.clip,
                                                      textSize: 12,
                                                      textAlignment:
                                                          TextAlign.start,
                                                    ),
                                                    widthRatio: .51,
                                                    heightRatio: .025,
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                        //Transaction Amount
                                        CustomSizedBox(
                                          widthRatio: .24,
                                          heightRatio: .065,
                                          widgetChild: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              FittedBox(
                                                child: CustomText(
                                                  textColor: newTransactionList[
                                                                  index]
                                                              .transactionType ==
                                                          true
                                                      ? incomeBlue
                                                      : expenseRed,
                                                  textData:
                                                      '₹ ${newTransactionList[index].amount.toStringAsFixed(2)}',
                                                  textSize: 16,
                                                  textWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<List<Transaction>> filteredLists(Box<Transaction> transBox) {
    List<Transaction> filteredListMonth = [];
    List<Transaction> filteredListYear = [];
    List<List<Transaction>> filteredLists = [
      filteredListMonth,
      filteredListYear
    ];
    List<Transaction> boxList = transBox.values.toList();
    for (int i = 0; i < boxList.length; i++) {
      if (boxList[i].date.year == monthYear.year) {
        filteredListYear.add(boxList[i]);
        if (boxList[i].date.month == monthYear.month) {
          filteredListMonth.add(boxList[i]);
        }
      }
    }
    return filteredLists;
  }

  List<Transaction> periodFilterList(Box<Transaction> transBox) {
    List<Transaction> periodFilter = [];
    List<Transaction> boxList = transBox.values.toList();
    for (int i = 0; i < boxList.length; i++) {
      if ((boxList[i].date.isAfter(initialDate) ||
              dateFormatterPeriod.format(boxList[i].date) ==
                  dateFormatterPeriod.format(initialDate)) &&
          (boxList[i].date.isBefore(finalDate) ||
              dateFormatterPeriod.format(boxList[i].date) ==
                  dateFormatterPeriod.format(finalDate))) {
        periodFilter.add(boxList[i]);
      }
    }
    return periodFilter;
  }
}

double incomeSum(List<Transaction> list) {
  double incomeTotal = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i].transactionType == true) {
      incomeTotal += list[i].amount;
    }
  }
  totalIncome = incomeTotal;
  return incomeTotal;
}

double expenseSum(List<Transaction> list) {
  double expenseTotal = 0;
  for (int i = 0; i < list.length; i++) {
    if (list[i].transactionType == false) {
      expenseTotal += list[i].amount;
    }
  }
  totalExpense = expenseTotal;
  return expenseTotal;
}
