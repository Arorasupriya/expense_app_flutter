//region Imports
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_module/bloc/expense_bloc.dart';
import 'package:onboarding_module/bloc/expense_bloc_states.dart';
import 'package:onboarding_module/models/expense_model.dart';
import 'package:onboarding_module/models/filtered_expense_model.dart';
import 'package:onboarding_module/util/app_colors.dart';
import 'package:onboarding_module/util/custom_widget.dart';
import 'package:onboarding_module/util/global_methods_and_variables.dart';
import 'package:onboarding_module/util/my_text_styles.dart';
//endregion

class ExpenseDetailScreen extends StatefulWidget {
  const ExpenseDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() => ExpenseDetailScreenState();
}

class ExpenseDetailScreenState extends State<ExpenseDetailScreen> {

  //region VariableDeclare
  List<int> arrTotalCount = [];
  List<FilteredExpenseModel> arrMonthWiseExpenses = [];
  List<FilteredExpenseModel> arrYearWiseExpenses = [];
  List<FilteredExpenseModel> arrDataWiseExpenses = [];
  num spentThisWeekAmount = 0;
  int selectedButton = 0; //0=>week, 1=>month, 2=>year
  int categoryEntriesCount = 0;
  num spentThisMonthAmount = 0;
  num spentThisYearAmount = 0;
  num maxAmt = 0;

  //endregion

  //region BuildMethods
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          backgroundColor: ColorConstant.bgColor,
          body: Padding(
            padding: const EdgeInsets.all(13.0),
            child: BlocBuilder<ExpenseBloc, ExpenseBlocState>(
              builder: (BuildContext context, state) {
                if (state is ExpenseLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExpenseErrorState) {
                  return Center(child: Text(state.errMsg));
                } else if (state is ExpenseLoadedState) {
                  filterExpenseByDate(state.listExpense);
                  filterExpenseByMonth(state.listExpense);
                  filterExpenseByYears(state.listExpense);
                  FilteredExpenseModel result;
                  FilteredExpenseModel resultM;
                  FilteredExpenseModel resultY;

                  //code for get maximum value from list
                  result = arrDataWiseExpenses.reduce((value, element) =>
                      value.totalAmount.abs() > element.totalAmount.abs()
                          ? value
                          : element);
                  print("values${result.totalAmount.abs()}");

                  resultM = arrMonthWiseExpenses.reduce((value, element) =>
                      value.totalAmount.abs() > element.totalAmount.abs()
                          ? value
                          : element);
                  print("values Month${resultM.totalAmount.abs()}");

                  resultY = arrYearWiseExpenses.reduce((value, element) =>
                      value.totalAmount.abs() > element.totalAmount.abs()
                          ? value
                          : element);
                  print("values Year${resultY.totalAmount.abs()}");

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      hSpacer(mHeight: 10),
                      //Heading
                      RichText(
                        text: TextSpan(children: [
                          WidgetSpan(
                              child: Transform.translate(
                            offset: const Offset(0.0, 0.0),
                            //-y superscript
                            child: Text(
                              "\$",
                              style: TextStyle(
                                  color: ColorConstant.textOnBGColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  fontFeatures: const [
                                    FontFeature.superscripts()
                                  ]),
                            ),
                          )),
                          TextSpan(
                            text: selectedButton == 1
                                ? spentThisMonthAmount.abs().toString()
                                : selectedButton == 2
                                    ? spentThisYearAmount.abs().toString()
                                    : spentThisWeekAmount.abs().toString(),
                            style: TextStyle(
                                fontSize: 25,
                                color: ColorConstant.textOnBGColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ]),
                      ),
                      //SubHeading
                      Text(
                        selectedButton == 1
                            ? "Spent this month"
                            : selectedButton == 2
                                ? "Spent this year"
                                : "Spent this Week",
                        style: mTextStyle12(
                            mFontColor: ColorConstant.textThirdColor),
                      ),
                      hSpacer(),
                      //GraphPresent
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                            itemCount: selectedButton == 0
                                ? arrDataWiseExpenses.length
                                : selectedButton == 1
                                    ? arrMonthWiseExpenses.length
                                    : arrYearWiseExpenses.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: selectedButton == 0
                                              ? result.totalAmount
                                                  .abs()
                                                  .toDouble()
                                              : selectedButton == 1
                                                  ? resultM.totalAmount
                                                      .abs()
                                                      .toDouble()
                                                  : resultY.totalAmount
                                                      .abs()
                                                      .toDouble(),
                                          width: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                            color: ColorConstant.textThirdColor
                                                .withAlpha(100),
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 0,
                                            child: Container(
                                              height: selectedButton == 0
                                                  ? 185 *
                                                      (arrDataWiseExpenses[
                                                                  index]
                                                              .totalAmount
                                                              .abs() /
                                                          result.totalAmount
                                                              .abs())
                                                  : selectedButton == 1
                                                      ? 185 *
                                                          (arrMonthWiseExpenses[
                                                                      index]
                                                                  .totalAmount
                                                                  .abs() /
                                                              resultM
                                                                  .totalAmount
                                                                  .abs())
                                                      : 185 *
                                                          (arrYearWiseExpenses[
                                                                      index]
                                                                  .totalAmount
                                                                  .abs() /
                                                              resultY
                                                                  .totalAmount
                                                                  .abs()),
                                              width: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                                color: ColorConstant
                                                    .secondaryColor,
                                              ),
                                            )),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                      //Tabs
                      Row(
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                  side: selectedButton == 0
                                      ? BorderSide(
                                          style: BorderStyle.solid,
                                          color: ColorConstant.textThirdColor)
                                      : BorderSide.none),
                              onPressed: () {
                                filterExpenseByDate(state.listExpense);
                                setState(() {
                                  selectedButton = 0;
                                });
                              },
                              child: Text(
                                "Week",
                                style: mTextStyle12(
                                    mFontColor: selectedButton == 0
                                        ? ColorConstant.textOnBGColor
                                        : ColorConstant.textThirdColor,
                                    mWeight: selectedButton == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              )),
                          wSpacer(),
                          TextButton(
                              style: TextButton.styleFrom(
                                  side: selectedButton == 1
                                      ? BorderSide(
                                          style: BorderStyle.solid,
                                          color: ColorConstant.textThirdColor)
                                      : BorderSide.none),
                              onPressed: () {
                                filterExpenseByMonth(state.listExpense);
                                setState(() {
                                  selectedButton = 1;
                                });
                              },
                              child: Text(
                                "Month",
                                style: mTextStyle12(
                                    mFontColor: selectedButton == 1
                                        ? ColorConstant.textOnBGColor
                                        : ColorConstant.textThirdColor,
                                    mWeight: selectedButton == 1
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              )),
                          wSpacer(),
                          TextButton(
                              style: TextButton.styleFrom(
                                  side: selectedButton == 2
                                      ? BorderSide(
                                          style: BorderStyle.solid,
                                          color: ColorConstant.textThirdColor)
                                      : BorderSide.none),
                              onPressed: () {
                                filterExpenseByYears(state.listExpense);
                                setState(() {
                                  selectedButton = 2;
                                });
                              },
                              child: Text(
                                "Year",
                                style: mTextStyle12(
                                    mFontColor: selectedButton == 2
                                        ? ColorConstant.textOnBGColor
                                        : ColorConstant.textThirdColor,
                                    mWeight: selectedButton == 2
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              )),
                        ],
                      ),
                      hSpacer(),

                      //ShowList
                      Expanded(
                        child: ListView.separated(
                          itemCount: arrTotalCount.length,
                          separatorBuilder: (context, sIndex) => const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50.0),
                            child: Divider(),
                          ),
                          itemBuilder: (context, index) {
                            return ListTile(
                              visualDensity: const VisualDensity(vertical: -4),
                              //VisualDensity(horizontal: , vertical:)
                              textColor: ColorConstant.textOnBGColor,
                              leading: Image.asset(
                                AppVariables.categories[index]["img"],
                                width: 30,
                                height: 30,
                              ),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppVariables.categories[index]["name"],
                                    style: mTextStyle12(
                                        mWeight: FontWeight.bold,
                                        mFontColor:
                                            ColorConstant.textOnBGColor),
                                  ),
                                  Text(
                                    "\$000",
                                    style: mTextStyle12(
                                        mWeight: FontWeight.bold,
                                        mFontColor:
                                            ColorConstant.textOnBGColor),
                                  )
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    arrTotalCount[index].toString(),
                                    style: mTextStyle12(
                                        mFontColor:
                                            ColorConstant.textOnBGColor),
                                  ),
                                  Text(
                                    "something",
                                    style: mTextStyle12(
                                        mFontColor:
                                            ColorConstant.textOnBGColor),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                }
                return Container();
              },
            ),
          )),
    );
  }

  //endregion

  //region PrivateMethods
  getCategoryEntries(List<ExpenseModel> expenseModel) {
    List<int> arrCId = [];
    arrTotalCount.clear();

    for (var r in AppVariables.categories) {
      arrCId.add(r["id"]);
    }
    print("totalCount${arrCId.length}");

    for (int cId in arrCId) {
      List<ExpenseModel> categoryWiseExpCount = [];
      categoryEntriesCount = 0;
      for (ExpenseModel exp in expenseModel) {
        if (exp.expCategory.toString().contains(cId.toString())) {
          categoryWiseExpCount.add(exp);
          categoryEntriesCount++;
        }
      }
      arrTotalCount.add(categoryEntriesCount);
    }
    print(arrTotalCount);
  }

  void filterExpenseByMonth(List<ExpenseModel> arrExpenses) {
    //2023-09-09 dateFormat

    arrMonthWiseExpenses.clear();
    spentThisMonthAmount = 0;

    List<String> arrUniqueMonths = [];

    //step 1 loop1
    for (ExpenseModel eachExp in arrExpenses) {
      var eachDate = DateTime.parse(eachExp.expDateTime);

      //Month
      var myMonth = "${eachDate.year}"
          "-${eachDate.month.toString().length < 2 ? "0${eachDate.month}" : "${eachDate.month}"}";
      if (!arrUniqueMonths.contains(myMonth)) {
        arrUniqueMonths.add(myMonth);
      }
    } //forLoop1

    //===========================Month==============================//
    for (String eachMonthData in arrUniqueMonths) {
      List<ExpenseModel> eachMonthDateExpense = [];
      num eMA = 0;
      for (ExpenseModel exp in arrExpenses) {
        if (exp.expDateTime.contains(eachMonthData)) {
          eachMonthDateExpense.add(exp);

          if (exp.expType == 0) {
            //debit
            eMA -= exp.expAmount;
          } else {
            //credit
            eMA += exp.expAmount;
          }
        }
      }
      if (eMA > maxAmt) {
        maxAmt = eMA;
      }
      arrMonthWiseExpenses.add(FilteredExpenseModel(
          dayName: eachMonthData,
          totalAmount: eMA,
          arrExpenses: eachMonthDateExpense));
      spentThisMonthAmount += eMA;

      print("$arrUniqueMonths");
      print("month total $eMA");
      print("each month data entries count := ${eachMonthDateExpense.length}");
      print("all months total amount $spentThisMonthAmount");
      print("total month count => ${arrMonthWiseExpenses.length}");
    }

    getCategoryEntries(arrExpenses);
  }

  void filterExpenseByYears(List<ExpenseModel> arrExpenses) {
    //2023-09-09 dateFormat

    arrYearWiseExpenses.clear();
    spentThisYearAmount = 0;

    List<String> arrUniqueYears = [];

    //step 1 loop1
    for (ExpenseModel eachExp in arrExpenses) {
      var eachDate = DateTime.parse(eachExp.expDateTime);

      //Month
      var year = "${eachDate.year}";
      if (!arrUniqueYears.contains(year)) {
        arrUniqueYears.add(year);
      }
    } //forLoop1

    //===========================Month==============================//
    for (String eachYearData in arrUniqueYears) {
      List<ExpenseModel> eachYearDateExpense = [];
      num eYearAmount = 0;
      for (ExpenseModel exp in arrExpenses) {
        if (exp.expDateTime.contains(eachYearData)) {
          eachYearDateExpense.add(exp);

          if (exp.expType == 0) {
            //debit
            eYearAmount -= exp.expAmount;
          } else {
            //credit
            eYearAmount += exp.expAmount;
          }
        }
      }
      if (eYearAmount > maxAmt) {
        maxAmt = eYearAmount;
      }
      arrYearWiseExpenses.add(FilteredExpenseModel(
          dayName: eachYearData,
          totalAmount: eYearAmount,
          arrExpenses: eachYearDateExpense));
      spentThisYearAmount += eYearAmount;

      print("$arrUniqueYears");
      print("year total $eYearAmount");
      print("each month data entries count := ${eachYearDateExpense.length}");
      print("all months total amount $spentThisYearAmount");
      print("total month count => ${arrYearWiseExpenses.length}");
    }

    getCategoryEntries(arrExpenses);
  }

  void filterExpenseByDate(List<ExpenseModel> arrExpenses) {
    //2023-09-09 dateFormat
    arrDataWiseExpenses.clear();
    spentThisWeekAmount = 0;

    List<String> arrUniqueDate = [];

    //step 1 loop1
    for (ExpenseModel eachExp in arrExpenses) {
      var eachDate = DateTime.parse(eachExp.expDateTime);
      var mdate = "${eachDate.year}"
          "-${eachDate.month.toString().length < 2 ? "0${eachDate.month}" : "${eachDate.month}"}"
          "-${eachDate.day.toString().length < 2 ? "0${eachDate.day}" : "${eachDate.day}"}";

      //condition ye h ki agr jo date model se aa rhi h wo isme nhi h toh add karega array me use hume unique date milegi
      if (!arrUniqueDate.contains(mdate)) {
        arrUniqueDate.add(mdate); // hum yha unique dates ko add kar rhe h
      }
    } //forLoop1
    print("$arrUniqueDate");

    //Step 2 (fetch date wise expenses) //loop2
    for (String eachUniqueDate in arrUniqueDate) {
      List<ExpenseModel> eachDateExpense =
          []; //har din ka expense recode added hoga is  array me
      num expenseAmount = 0;

      //loop3
      for (ExpenseModel exp in arrExpenses) {
        if (exp.expDateTime.contains(eachUniqueDate)) {
          eachDateExpense.add(exp);

          if (exp.expType == 0) {
            //debit
            expenseAmount -= exp.expAmount;
          } else {
            //credit
            expenseAmount += exp.expAmount;
          }
        }
      } //loop3
      print(expenseAmount);

      if (expenseAmount > maxAmt) {
        maxAmt = expenseAmount;
      }
      arrDataWiseExpenses.add(FilteredExpenseModel(
          dayName: eachUniqueDate,
          totalAmount: expenseAmount,
          arrExpenses: eachDateExpense));
      spentThisWeekAmount += expenseAmount;
    } //loop2

    print(spentThisWeekAmount);
    print(arrDataWiseExpenses.length);
    getCategoryEntries(arrExpenses);
  }
//endregion
}

//region CommentedCode
// CategoryWiseData

/* List<int> arrCId = [];
   arrTotalCount.clear();

   for (var r in AppVariables.categories) {
     arrCId.add(r["id"]);
   }
   print("totalCount${arrCId.length}");

   for (int cId in arrCId) {
     List<ExpenseModel> categoryWiseExpCount = [];
     categoryEntriesCount = 0;
     for (ExpenseModel exp in arrExpenses) {
       if (exp.expCategory.toString().contains(cId.toString())) {
         categoryWiseExpCount.add(exp);
         categoryEntriesCount++;
       }
     }
     arrTotalCount.add(categoryEntriesCount);
   }
   print(arrTotalCount);*/

/*  var currentData =
                                arrMonthWiseExpenses;
                           var largestValue =  currentData.reduce((value, element) => value.totalAmount>element.totalAmount?value:element);
                             print(currentData);
                             print(largestValue.totalAmount);
                            // print("largest${largestValue.expAmount}");*/
//endregion
