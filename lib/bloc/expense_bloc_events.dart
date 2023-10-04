import 'package:onboarding_module/models/expense_model.dart';

abstract class ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent{
  ExpenseModel newModel;
  AddExpenseEvent({required this.newModel});
}
class FetchUserExpenseEvent extends ExpenseEvent{}