//region ImportLibrary
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_module/bloc/expense_bloc.dart';
import 'package:onboarding_module/bloc/expense_bloc_events.dart';
import 'package:onboarding_module/bloc/expense_bloc_states.dart';
import 'package:onboarding_module/models/expense_model.dart';
import 'package:onboarding_module/models/filtered_expense_model.dart';
import 'package:onboarding_module/theme_provider/theme_provider_ld.dart';
import 'package:onboarding_module/util/app_colors.dart';
import 'package:onboarding_module/util/custom_widget.dart';
import 'package:onboarding_module/util/global_methods_and_variables.dart';
import 'package:onboarding_module/util/my_text_styles.dart';
//endregion

class ExpenseDashboard extends StatefulWidget {
  const ExpenseDashboard({super.key});

  @override
  State<StatefulWidget> createState() => ExpenseDashboardState();
}

class ExpenseDashboardState extends State<ExpenseDashboard> {

  //region Variable Declarations
  List<String> expCatTypeList = ["Debit", "Credit"];
  List<FilteredExpenseModel> arrDataWiseExpenses = [];
  List<ExpenseModel> transactionList = [];

  var txtExpenseAddController = TextEditingController();

  int selectedCategoryImageIndex = 0;
  String selectedDDMItem = "Debit";
  num maxAmt = 0;
  num spentThisWeekAmount = 0;

  // String strTotalAmount = "";
  //endregion

  //region InitMethod
  //initMethodCall
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(FetchUserExpenseEvent());
  }

  //endregion

  //region BuildMethod
  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeProvider>().isDark;
    getThemeColorAccordingLitDrk(context, isDark);
    context.read<ExpenseBloc>().add(FetchUserExpenseEvent());
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.bgColor,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: BlocBuilder<ExpenseBloc, ExpenseBlocState>(
              builder: (BuildContext context, state) {
                if (state is ExpenseLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ExpenseLoadedState) {
                  //CallFunction
                  filterExpenseByDate(state.listExpense);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstant.textOnBGColor,
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(30, 30),
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15))),
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: ColorConstant.bgColor,
                                    enableDrag: false,
                                    isScrollControlled: true,
                                    // full screen bottom sheet use
                                    useSafeArea: false,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            topRight: Radius.circular(30))),
                                    context: context,
                                    builder: (context) {
                                      //Add button bottom sheet
                                      return _showAddExpenseSheet();
                                    });
                              },
                              child: Icon(
                                Icons.add,
                                color: ColorConstant.secondaryTextColor,
                                size: 22.0,
                              )),
                        ],
                      ),

                      hSpacer(mHeight: 50),
                      //Heading
                      Text(
                        "Spent this weak",
                        style: mTextStyle12(
                            mFontColor: ColorConstant.textThirdColor,
                            mWeight: FontWeight.w500),
                      ),
                      hSpacer(),

                      //use RichText
                      RichText(
                        text: TextSpan(children: [
                          WidgetSpan(
                              child: Transform.translate(
                            offset: const Offset(0.0, -5.0),
                            //-y superscript
                            child: Text(
                              "\$",
                              style: TextStyle(
                                  color: ColorConstant.textThirdColor,
                                  fontSize: 15,
                                  fontFeatures: const [
                                    FontFeature.superscripts()
                                  ]),
                            ),
                          )),
                          TextSpan(
                            text: spentThisWeekAmount.abs().toString(),
                            style: TextStyle(
                                fontSize: 20,
                                color: ColorConstant.textOnBGColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                      ),

                      hSpacer(mHeight: 50),

                      ListView.builder(
                          itemCount: arrDataWiseExpenses.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            // filterExpenseByDate(state.listExpense);
                            var currentItem = arrDataWiseExpenses[index];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                hSpacer(mHeight: 30),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(80, 4, 15, 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentItem.dayName,
                                        style: mTextStyle12(
                                            mWeight: FontWeight.w600,
                                            mFontColor:
                                                ColorConstant.textThirdColor),
                                      ),
                                      Text(
                                        currentItem.totalAmount
                                            .abs()
                                            .toString(),
                                        style: mTextStyle12(
                                            mWeight: FontWeight.w600,
                                            mFontColor:
                                                ColorConstant.textThirdColor),
                                      ),
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(80, 0, 15, 0),
                                  child: Divider(),
                                ),
                                ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: currentItem.arrExpenses.length,
                                    itemBuilder: (context, index) {
                                      var currentData =
                                          currentItem.arrExpenses[index];
                                      var expCategoryId =
                                          currentData.expCategory;
                                      var result = AppVariables.categories
                                          .where((element) =>
                                              element['id'] == expCategoryId)
                                          .toList();

                                      return ListTile(
                                        textColor: ColorConstant.textOnBGColor,
                                        leading: Image.asset(
                                          result[0]["img"].toString(),
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.contain,
                                        ),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(result[0]["name"].toString()),
                                            Text(
                                              currentData.expType == 0
                                                  ? "- ${currentData.expAmount.toString()}"
                                                  : "+ ${currentData.expAmount.toString()}",
                                              style: TextStyle(
                                                  color:
                                                      currentData.expType == 0
                                                          ? Colors.red
                                                          : Colors.green),
                                            ),
                                          ],
                                        ),
                                        titleTextStyle: mTextStyle12(
                                            mWeight: FontWeight.bold),
                                        subtitle: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(currentData.expType == 0
                                                    ? "Debit"
                                                    : "Credit"),
                                                 Text(
                                                   convertStringToDateTimeObjectToString(currentData.expDateTime.toString()))
                                               // convertStringToDateTimeObjectToString(currentData.expDateTime.toString())
                                              ],
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                        subtitleTextStyle: mTextStyle12(),
                                      );
                                    })
                              ],
                            );
                          }),
                    ],
                  );
                } else if (state is ExpenseErrorState) {
                  return Center(
                    child: Text(state.errMsg),
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }

  //endregion

  //region OpenBottomSheetsMethods
  Widget _showAddExpenseSheet() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel",
                            style: mTextStyle16(
                                mWeight: FontWeight.bold,
                                mFontColor: ColorConstant.textOnBGColor),
                          )),
                      Text(
                        "Expense",
                        style: mTextStyle16(
                            mWeight: FontWeight.bold,
                            mFontColor: ColorConstant.textOnBGColor),
                      ),
                      wSpacer(mWidth: 50),
                    ],
                  ),
                  hSpacer(mHeight: 100),
                  Text(
                    "\$00",
                    style: mTextStyle16(
                        mWeight: FontWeight.bold,
                        mFontColor: ColorConstant.textThirdColor),
                  ),
                  hSpacer(mHeight: 10),
                  //txtExpenseAmount
                  Center(
                    child: SizedBox(
                      width: 100,
                      child: TextField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {});
                          } else {}
                          setState(() {});
                        },
                        style: mTextStyle34(
                            mFontColor: ColorConstant.textOnBGColor),
                        controller: txtExpenseAddController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey)),
                          hintText: "\$00",
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.textThirdColor,
                              fontSize: 34),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
              child: Column(
                children: [
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton(
                            value: selectedDDMItem,
                            //value it means show text in dropdown not in menu list
                            items: expCatTypeList
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(
                                        e,
                                        style: mTextStyle12(
                                            mFontColor:
                                                ColorConstant.textOnBGColor),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              selectedDDMItem = value!;
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {});
                            }),
                        InkWell(
                          onTap: () {
                            //show categories sheet
                            showModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                context: context,
                                builder: (context) {
                                  return _showCategoriesSheet();
                                });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                AppVariables
                                        .categories[selectedCategoryImageIndex]
                                    ["img"],
                                width: 20,
                                height: 20,
                              ),
                              wSpacer(),
                              Text(
                                AppVariables
                                        .categories[selectedCategoryImageIndex]
                                    ["name"],
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.textOnBGColor),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorConstant.textOnBGColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            onPressed: txtExpenseAddController.text
                                    .toString()
                                    .isNotEmpty
                                ? () async {
                                    var id = await getUserIdFromSP();
                                    var amount = txtExpenseAddController.text
                                            .toString()
                                            .isNotEmpty
                                        ? int.parse(txtExpenseAddController.text
                                            .toString())
                                        : 0;
                                    context.read<ExpenseBloc>().add(AddExpenseEvent(
                                        newModel: ExpenseModel(
                                            userId: id,
                                            expTitle: "NA",
                                            expDesc: "NA",
                                            expAmount: amount,
                                            expBalance: 0,
                                            expType: selectedDDMItem == "Debit"
                                                ? 0
                                                : 1,
                                            expCategory: AppVariables
                                                        .categories[
                                                    selectedCategoryImageIndex]
                                                ['id'],
                                            expDateTime:
                                                DateTime.now().toString())));
                                    setState(() {
                                      txtExpenseAddController.clear();
                                      selectedCategoryImageIndex = 0;
                                    });
                                  }
                                : null,
                            child: Text(
                              "Save",
                              style: mTextStyle12(
                                  mFontColor: ColorConstant.secondaryTextColor,
                                  mWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget _showCategoriesSheet() {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Container(
            padding: const EdgeInsets.all(11),
            height: 300,
            child: GridView.builder(
                itemCount: AppVariables.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  var currData = AppVariables.categories[index];
                  return InkWell(
                    onTap: () {
                      selectedCategoryImageIndex = index;
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          currData["img"],
                          width: 30,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                        hSpacer(mHeight: 5),
                        FittedBox(
                            fit: BoxFit.cover,
                            child: Text(
                              currData["name"],
                              style: const TextStyle(
                                fontSize: 10,
                              ),
                            ))
                      ],
                    ),
                  );
                }));
      },
    );
  }

  //endregion

  //region FilterExpenseByDate
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

    }

//endregion
}

//region Commented code
/*
 /* void filterExpenseByDate(List<ExpenseModel> arrExpenses) {
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
    } //forloop1
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
  }*/
 spentThisWeekAmount += currentItem.totalAmount;
                            //print("************************$spentThisWeekAmount");
                            //strTotalAmount = spentThisWeekAmount.abs().toString();

List<String> arrMonthlyData = [];
List<String> arrYearlyData = [];


//Year
var myYear = eachDate.year.toString();
if (!arrYearlyData.contains(myYear)) {
arrYearlyData.add(myYear);
}

//Month
var myMonth = "${eachDate.year}"
"-${eachDate.month
    .toString()
    .length < 2 ? "0${eachDate.month}" : "${eachDate.month}"}";
if (!arrMonthlyData.contains(myMonth)) {
arrMonthlyData.add(myMonth);
}


//===========================Month==============================//
for (String eachMonthData in arrMonthlyData) {
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
print("asasasasasasasasa$eMA");
print("========>${eachMonthDateExpense.length}");
}

//++++++++++++++++++++++Year++++++++++++++++++++++++++//
for (String eachYearlyData in arrYearlyData) {
List<ExpenseModel> eachYearMonthDayExpense = [];
num eMA = 0;
for (ExpenseModel exp in arrExpenses) {
if (exp.expDateTime.contains(eachYearlyData)) {
eachYearMonthDayExpense.add(exp);

if (exp.expType == 0) {
//debit
eMA -= exp.expAmount;
} else {
//credit
eMA += exp.expAmount;
}
}
}
print("=================================$eMA");
print("========>>>>>>>>>>>>>>>>>${eachYearMonthDayExpense.length}");
}*/

/*Align(
                      alignment: Alignment.topRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstant.textOnBGColor,
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(30, 30),
                              elevation: 5.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          onPressed: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.white,
                                enableDrag: false,
                                isScrollControlled: true,
                                // full screen bottom sheet use
                                useSafeArea: false,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30))),
                                context: context,
                                builder: (context) {
                                  //Add button bottom sheet
                                  return _showAddExpenseSheet();
                                });
                          },
                          child: Icon(
                            Icons.add,
                            color: ColorConstant.secondaryTextColor,
                            size: 22.0,
                          )),
                    ),*/
//////////////////////////////////////////////////////
/*  for (String eachUniqueDate in arrUniqueDate) {
      List<ExpenseModel> eachDateExpense =
      []; //har din ka expense recode added hoga is  array me
      num expenseAmount = 0;

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
      }
      print(expenseAmount);

      if (expenseAmount > maxAmt) {
        maxAmt = expenseAmount;
      }
      arrDataWiseExpenses.add(FilteredExpenseModel(
          dayName: eachUniqueDate,
          totalAmount: expenseAmount,
          arrExpenses: eachDateExpense));

    }*/
/////////////////////////////
/* floatingActionButton: FloatingActionButton(
              onPressed: () {
                bool isLoggedIn = false;
                addIsLoggedInUserSF(isLoggedIn);
                //login page me move karna h
                int uid = 0;
                setUserIdInSP(uid);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()));
              },
              child: FittedBox(
                  child: Text(
                "SignOut",
                style:
                    mTextStyle12(mFontColor: ColorConstant.secondaryTextColor),
              )))*/

/*onPressed: () async {
await Navigator.push(
context,
MaterialPageRoute(
fullscreenDialog: true,
builder: (context) =>
ExpenseDetailScreen()));
},*/
//endregion
