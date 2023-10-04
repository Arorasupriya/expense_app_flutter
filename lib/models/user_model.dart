import 'package:onboarding_module/database/database.dart';

class UserModel {
  int? id;
  String? email;
  String? mobile_no;
  String? password;
  String? gender;

  //Constructor calling
  UserModel({this.id, this.email, this.mobile_no, this.password, this.gender});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        id: map[AppDatabase.user_id],
        email: map[AppDatabase.user_email],
        mobile_no: map[AppDatabase.user_moblite_no],
        password: map[AppDatabase.user_password],
        gender: map[AppDatabase.user_gender]);
  }

  Map<String, dynamic> toMap() {
    return {
      AppDatabase.user_id: id,
      AppDatabase.user_email: email,
      AppDatabase.user_moblite_no: mobile_no,
      AppDatabase.user_password: password,
      AppDatabase.user_gender: gender
    };
  }
}
