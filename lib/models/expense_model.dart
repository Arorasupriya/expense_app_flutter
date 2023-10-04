import 'package:onboarding_module/database/database.dart';

class ExpenseModel {
  int userId;
  int? expId;
  String expTitle;
  String expDesc;
  num expAmount;
  num expBalance;
  int expType;
  int expCategory;
  String expDateTime;

  ExpenseModel({this.expId,
    required this.userId,
    required this.expTitle,
    required this.expDesc,
    required this.expAmount,
    required this.expBalance,
    required this.expType,
    required this.expCategory,
    required this.expDateTime});

  //what is the meaning of . (dot) .fromMap ? it means factory function always return class object it initialize by .  and this fuction start from class name
  factory ExpenseModel.fromMap(Map<String, dynamic>map){
    return ExpenseModel(
        expId: map[AppDatabase.expense_id],
        userId: map[AppDatabase.user_id],
        expTitle: map[AppDatabase.expense_title],
        expDesc: map[AppDatabase.expense_desc],
        expAmount: map[AppDatabase.expense_amt],
        expBalance: map[AppDatabase.expense_bal],
        expType: map[AppDatabase.expense_type],
        expCategory: map[AppDatabase.expense_cat_id],
        expDateTime: map[AppDatabase.expense_datetime]);
  }


  //Insert query use karte h tb hume map ka need hota h data ko table ke column me set karne ke  liye
  Map<String, dynamic> toMap() =>
      {
        //AppDatabase.expense_id: expId,
        AppDatabase.user_id: userId,
        AppDatabase.expense_title: expTitle,
        AppDatabase.expense_desc: expDesc,
        AppDatabase.expense_amt: expAmount,
        AppDatabase.expense_bal: expBalance,
        AppDatabase.expense_type: expType,
        AppDatabase.expense_cat_id: expCategory,
        AppDatabase.expense_datetime: expDateTime,

      };
}

