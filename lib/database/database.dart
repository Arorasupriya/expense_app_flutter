//region ImportPackages
import 'dart:io';

import 'package:onboarding_module/models/expense_model.dart';
import 'package:onboarding_module/models/user_model.dart';
import 'package:onboarding_module/util/global_methods_and_variables.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
//endregions

class AppDatabase {
  ///Create single ton class using ._() and assign to in db variable type is as class AppDatabase
  AppDatabase._();

  static final AppDatabase db = AppDatabase._();

  /// create private variable of database which is type of Database class implement databaseExecutor
  /// from sqlite_api.dart file
  Database? _database; //null check applied

  //region CreateKeysForExpenseTable
  static const expense_table_name = "expense"; //table 1
  static const expense_id = "exp_id";
  static const expense_title = "exp_title";
  static const expense_desc = "exp_desc";
  static const expense_amt = "exp_amt";
  static const expense_bal = "exp_bal";
  static const expense_type = "exp_type"; //in 0 => debit or 1 => credit
  static const expense_cat_id = "exp_cat_id";
  static const expense_datetime = "exp_time";

  //endregion

  //region CreateKeysForUserTable
  // create static variable used in whole project
  static const user_table_name = "user"; //table 2
  static const user_id = "id";
  static const user_email = "email";
  static const user_moblite_no = "mobileNo";
  static const user_password = "password";
  static const user_gender = "gender";

  //endregion

  //region GetDataBase
//1s getDatabase
  Future<Database> getDB() async {
    if (_database != null) {
      return _database!;
    } else {
      return await initDB();
    }
  }

//endregion

  //region InitDatabaseCreateTables
  //initDB
  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    var dbPath = join(documentDirectory.path,
        "expense.db"); //data base name in this db manage 2 tables expense and user data
    return openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(
          "create table $user_table_name ($user_id integer primary key autoincrement,$user_email text unique,$user_moblite_no text unique,$user_password text,$user_gender text)");
      db.execute(
          "create table $expense_table_name ($expense_id integer primary key autoincrement,$user_id integer,$expense_title text,$expense_desc text,$expense_amt real,$expense_bal real,$expense_type integer,$expense_cat_id integer,$expense_datetime string)");
    });
  }

  //endregion

  //region OperationsPerformOnDatabase
  //Operation add op
  Future<bool> addUserRecord(UserModel userModel) async {
    var db = await getDB();
    var count = await db.insert(user_table_name, userModel.toMap());
    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addExpenseOfUser(ExpenseModel expenseModel) async {
    var db = await getDB();
    var count = await db.insert(expense_table_name, expenseModel.toMap());
    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

  // fetchData from user table
  Future<List<UserModel>> fetchAllUsersRecords() async {
    var db = await getDB();
    List<Map<String, dynamic>> users = await db.query(user_table_name);
    List<UserModel> listOfUsers = [];
    for (Map<String, dynamic> userRecord in users) {
      UserModel model = UserModel.fromMap(userRecord);
      listOfUsers.add(model);
      //print(listOfUsers.length);
    }
    return listOfUsers;
  }

  //fetchData from expense table
  Future<List<ExpenseModel>> fetchAllExpenseOfUser() async {
    var db = await getDB();
    int id;
    id = await getUserIdFromSP();
    print("get value from shared preferences=====> $id");

    List<Map<String, dynamic>> userExpenses = await db
        .query(expense_table_name, where: "$user_id=?", whereArgs: ["$id"]);
    List<ExpenseModel> exps = []; //create a array type is ExpenseModel
    for (Map<String, dynamic> expense in userExpenses) {
      //now fetch data in the form of ExpenseModel from ListofMap data
      exps.add(ExpenseModel.fromMap(
          expense)); //convert into ExpenseModel using fromMap factory function get data from data base
    }
    return exps;
  }

//update
  Future<bool> updateUserRecord(UserModel userModel) async {
    var db = await getDB();
    var count = await db.update(user_table_name, userModel.toMap(),
        where: "$user_id = ${userModel.id}");
    return count > 0;
  }

//delete
  Future<bool> deleteUserRecord(int id) async {
    var db = await getDB();
    var count = await db
        .delete(user_table_name, where: "$user_id = ?", whereArgs: ["$id"]);
    return count > 0;
  }

  //Find Field for user already exist or not
  Future<int> isUserAllReadyExistOrNot({required String email}) async {
    var db = await getDB();
    var record = await db.rawQuery(
        'SELECT * FROM $user_table_name WHERE $user_email LIKE ?',
        ['%$email%']);
    print("AEON Status $record");
    return record.length;
  }

  Future<int> isPasswordEmailNumber(
      {required String emailMobileNo, required String password}) async {
    var db = await getDB();
    var record = await db.rawQuery(
        "SELECT * FROM $user_table_name WHERE $user_email LIKE ? AND $user_password LIKE ?",
        ["%$emailMobileNo%", "%$password%"]);

    // addIsLoggedInUserSF(isLoggedIn);
    //save login status
    bool isLoggedIn = true;
    if (record.isNotEmpty) {
      var id = record[0][user_id];
      var userEmail = record[0][user_email]; //receive value in object
      print("SP===>$id,$userEmail");
      setUserDataInSP(
          isLoggedIn,
          int.parse(id.toString()),
          userEmail
              .toString()); // using toString convert object to string and int.parse use to value is int type
    }
    print("get email password mobile number $record");
    return record.length;
  }
//endregion
}

/*
var data;
for(var r in record){
data = r[user_id];
}
print("id $data");*/
