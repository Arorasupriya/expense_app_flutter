import 'package:onboarding_module/models/expense_model.dart';

class FilteredExpenseModel{
  String dayName;
  num totalAmount;
  List<ExpenseModel> arrExpenses;

  FilteredExpenseModel({required this.dayName,required this.totalAmount,required this.arrExpenses});
}