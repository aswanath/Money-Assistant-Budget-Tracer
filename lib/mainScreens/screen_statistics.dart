import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_assistant_final/customWidgets/custom_text.dart';
import 'package:money_assistant_final/globalUsageValues.dart';
import 'package:money_assistant_final/main.dart';
import 'package:money_assistant_final/mainScreens/screen_transactions.dart';
import '../customWidgets/sized_box_custom.dart';
import '../iconFont/my_flutter_app_icons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../model/model_class.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with TickerProviderStateMixin {
  Color? tabColor = incomeBlue;
  TabController? tabController;
  String? currentDate;
  String? lastDate;
  late DateTime finalDate;
  late DateTime initialDate;
  DateTime monthYear = DateTime.now();
  String popupItem = 'Monthly';
  var catBox = Hive.box<Category>(boxCat);
  var transBox = Hive.box<Transaction>(boxTrans);
  late List<Transaction> firstFilterList;

  @override
  void initState() {
    initialDate = DateTime.now();
    finalDate = DateTime.now();
    currentDate = dateFormatterFull.format(initialDate);
    lastDate = dateFormatterFull.format(finalDate);
    tabController = TabController(length: 2, vsync: this);
    firstFilterList = filteredLists(transBox)[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(deviceWidth);
    print(deviceHeight);
    return Scaffold(
      backgroundColor: commonWhite,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Row(
                children: [
                  CustomSizedBox(
                    heightRatio: 0.07,
                    widthRatio: 1,
                    widgetChild: DecoratedBox(
                      decoration: BoxDecoration(
                        color: commonWhite,
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
                                            firstDate: DateTime(
                                                DateTime.now().year - 10),
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
                                                    firstFilterList =
                                                        periodFilterList(
                                                            transBox);
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
                                                size:  14,
                                                color: secondaryPurple,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      CustomText(
                                          textData: ' ~ ',
                                          textSize:16),
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
                                              if (value != null){
                                                finalDate = value;
                                                lastDate = dateFormatterFull
                                                    .format(finalDate);
                                                if (value
                                                    .isBefore(initialDate)){
                                                  initialDate = value;
                                                  currentDate =
                                                      dateFormatterFull
                                                          .format(value);
                                                }
                                              }
                                              firstFilterList =
                                                  periodFilterList(transBox);
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
                                              monthYear = DateTime(
                                                  monthYear.year,
                                                  monthYear.month - 1);
                                              firstFilterList =
                                                  filteredLists(transBox)[0];
                                            } else if (popupItem == 'Yearly') {
                                              monthYear = DateTime(
                                                  monthYear.year - 1,
                                                  monthYear.month);
                                              firstFilterList =
                                                  filteredLists(transBox)[1];
                                            }
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        MyFlutterApp.left_open_outline,
                                        color: secondaryPurple,
                                        size:20,
                                      ),
                                      visualDensity:
                                          const VisualDensity(horizontal: -4),
                                    ),
                                    CustomText(
                                        textData: popupItem == 'Monthly'
                                            ? dateFormatterMonth
                                                .format(monthYear)
                                            : monthYear.year.toString(),
                                        textColor: commonBlack,
                                        textSize: 16),
                                    IconButton(
                                        splashRadius: .01,
                                        onPressed: () {
                                          setState(() {
                                            if (popupItem == 'Monthly') {
                                              monthYear = DateTime(
                                                  monthYear.year,
                                                  monthYear.month + 1);
                                              firstFilterList =
                                                  filteredLists(transBox)[0];
                                            } else if (popupItem == 'Yearly') {
                                              monthYear = DateTime(
                                                  monthYear.year + 1,
                                                  monthYear.month);
                                              firstFilterList =
                                                  filteredLists(transBox)[1];
                                            }
                                          });
                                        },
                                        icon: Icon(
                                          MyFlutterApp.right_open_outline,
                                          color: secondaryPurple,
                                          size: 20,
                                        ),
                                        visualDensity: const VisualDensity(
                                            horizontal: -4)),
                                  ],
                                ),
                          PopupMenuButton(
                            onSelected: (val) {
                              if (val != null) {
                                if (val == 'Monthly') {
                                  monthYear = DateTime.now();
                                  firstFilterList = filteredLists(transBox)[0];
                                  popupItem = val.toString();
                                  setState(() {});
                                } else if (val == 'Yearly') {
                                  monthYear = DateTime.now();
                                  firstFilterList = filteredLists(transBox)[1];
                                  popupItem = val.toString();
                                  setState(() {});
                                } else if (val == 'Period') {
                                  monthYear = DateTime.now();
                                  firstFilterList = periodFilterList(transBox);
                                  popupItem = val.toString();
                                  setState(() {});
                                }
                              }
                            },
                            child: Padding(
                              padding:
                                  EdgeInsets.only(right: deviceWidth * .03),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: secondaryPurple),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  children: [
                                    CustomText(
                                        textData: popupItem, textSize: 14),
                                    const Icon(
                                        Icons.keyboard_arrow_down_outlined)
                                  ],
                                ),
                              ),
                            ),
                            initialValue: popupItem,
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                child: CustomText(
                                    textData: 'Monthly', textSize: 14),
                                value: 'Monthly',
                              ),
                              PopupMenuItem(
                                child: CustomText(
                                    textData: 'Yearly', textSize: 14),
                                value: 'Yearly',
                              ),
                              PopupMenuItem(
                                child: CustomText(
                                    textData: 'Period', textSize: 14),
                                value: 'Period',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Builder(
                builder: (BuildContext context) {
                  tabController = DefaultTabController.of(context)!;
                  tabController!.addListener(() {
                    if (tabController!.index == 1) {
                      tabColor = expenseRed;
                    } else {
                      tabColor = incomeBlue;
                    }
                    setState(() {});
                  });
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TabBar(
                          padding: const EdgeInsets.only(
                              left: 40, right: 40, top: 10, bottom: 20),
                          indicator: BoxDecoration(
                              color: tabColor,
                              borderRadius: BorderRadius.circular(7)),
                          labelColor: commonWhite,
                          unselectedLabelColor: commonBlack,
                          tabs:  [
                            Tab(
                              child: CustomText(textData: 'INCOME', textSize: 18,textWeight: FontWeight.w600,),
                            ),
                            Tab(
                              child: CustomText(textData: 'EXPENSE', textSize: 18,textWeight: FontWeight.w600,),
                            ),
                          ]),
                      SizedBox(
                        child: CustomText(
                            textData: tabController!.index == 0
                                ? 'Total Income: ${incomeSum(firstFilterList)}'
                                : 'Total Expense: ${expenseSum(firstFilterList)}',
                            textSize: 20),
                      ),
                    ],
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ((getGdpDataIncome(firstFilterList).isEmpty &&
                              tabController!.index == 0) ||
                          (getGdpDataExpense(firstFilterList).isEmpty &&
                              tabController!.index == 1))
                      ? Center(
                          child: CustomText(
                              textData: 'No data to show', textSize: 18),
                        )
                      : SfCircularChart(
                          centerY: '160',
                          legend: Legend(
                            textStyle: const TextStyle(fontFamily: 'POPPINS'),
                            overflowMode: LegendItemOverflowMode.scroll,
                            offset: Offset(-140, deviceHeight*.42),
                            isVisible: true,
                            isResponsive: true,
                            orientation: LegendItemOrientation.vertical,
                            height: '40%',
                            width: '100%'
                          ),
                          tooltipBehavior: TooltipBehavior(
                            enable: true,
                            color: secondaryPurple,
                            textStyle: const TextStyle(fontFamily: 'Poppins'),
                          ),
                          palette: paletteColor,
                          backgroundColor: commonWhite,
                          series: <CircularSeries>[
                            PieSeries<GDPData, String>(
                              strokeColor: commonWhite,
                              strokeWidth: 1,
                              explodeGesture: ActivationMode.singleTap,
                              explode: tabController?.index==0?(getGdpDataIncome(firstFilterList).length==1?false:true):(getGdpDataExpense(firstFilterList).length==1?false:true),
                              radius: (deviceHeight*.16).toString(),
                              dataSource: tabController?.index == 0
                                  ? getGdpDataIncome(firstFilterList)
                                  : getGdpDataExpense(firstFilterList),
                              xValueMapper: (GDPData data, _) => data.continent,
                              yValueMapper: (GDPData data, _) => data.gdp,
                              dataLabelMapper: (GDPData data,_)=> data.text,
                              dataLabelSettings:  DataLabelSettings(
                                color: tabController?.index==0? incomeBlue:expenseRed,
                                connectorLineSettings: const ConnectorLineSettings(
                                    type: ConnectorType.curve),
                                labelPosition: ChartDataLabelPosition.outside,
                                isVisible: true,
                                textStyle: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 12),
                              ),
                            )
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<GDPData> getGdpDataIncome(List<Transaction> transactions) {
    final List<GDPData> chartDataIncome = [];
    List<Category> catList = catBox.values.toList();
    for (int i = 0; i < catList.length; i++) {
      double amount = 0;
      if (catList[i].transactionType == true) {
        for (int j = 0; j < transactions.length; j++) {
          if (catList[i].categoryName == transactions[j].category) {
            amount += transactions[j].amount;
          }
        }
        if (amount != 0) {
          var percentage = ((amount.roundToDouble()/incomeSum(firstFilterList))*100).toStringAsFixed(2);
          chartDataIncome.add(GDPData(catList[i].categoryName, amount.round(),'$percentage %'));
        }
      }
    }
    return chartDataIncome;
  }

  List<GDPData> getGdpDataExpense(List<Transaction> transactions) {
    final List<GDPData> charDataExpense = [];
    List<Category> catList = catBox.values.toList();
    for (int i = 0; i < catList.length; i++) {
      double amount = 0;
      if (catList[i].transactionType == false) {
        for (int j = 0; j < transactions.length; j++) {
          if (catList[i].categoryName == transactions[j].category) {
            amount += transactions[j].amount;
          }
        }
        if (amount != 0) {
          var percentage = ((amount.roundToDouble()/expenseSum(firstFilterList))*100).toStringAsFixed(2);
          charDataExpense.add(GDPData(catList[i].categoryName, amount.round(),'$percentage %'));
        }
      }
    }
    return charDataExpense;
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

class GDPData {
  GDPData(this.continent, this.gdp,this.text);

  final String continent;
  final int gdp;
  final String text;
}
