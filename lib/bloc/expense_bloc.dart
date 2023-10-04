import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_module/bloc/expense_bloc_events.dart';
import 'package:onboarding_module/bloc/expense_bloc_states.dart';
import 'package:onboarding_module/database/database.dart';

class ExpenseBloc extends Bloc<ExpenseEvent,ExpenseBlocState>{
  AppDatabase db;
  ExpenseBloc({required this.db}):super(ExpenseInitialSate()){

    on<AddExpenseEvent>((event, emit) async{
      emit(ExpenseLoadingState());
     bool check = await db.addExpenseOfUser(event.newModel);
     print("chhhhhheck=====>$check");
     if(check){
       var userExpense = await db.fetchAllExpenseOfUser();

       emit(ExpenseLoadedState(listExpense: userExpense));
     }else{
       emit(ExpenseErrorState(errMsg: "Expense not added!"));
     }
    });

    on((event, emit) async{
      emit(ExpenseLoadingState());
      var listOfExpenses = await db.fetchAllExpenseOfUser();
      emit(ExpenseLoadedState(listExpense: listOfExpenses));
    });
  }
}