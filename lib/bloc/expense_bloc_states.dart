import 'package:onboarding_module/models/expense_model.dart';

abstract class ExpenseBlocState {}
class ExpenseInitialSate extends ExpenseBlocState{}
class ExpenseLoadingState extends ExpenseBlocState{}
class ExpenseLoadedState extends ExpenseBlocState{
  List<ExpenseModel> listExpense = [];

 //type of state "means data type. kis type ka data chhahiye "
  ExpenseLoadedState({required this.listExpense});
}
class ExpenseErrorState extends ExpenseBlocState{
  String errMsg = "";
  ExpenseErrorState({required this.errMsg});
}