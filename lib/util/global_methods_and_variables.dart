import 'package:flutter/material.dart';
import 'package:onboarding_module/util/app_colors.dart';
import 'package:onboarding_module/util/image_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppVariables {
  //ListTypeVariables
  static List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "Travel", "img": ImageConstant.travelPath},
    {"id": 2, "name": "Shopping", "img": ImageConstant.shoppingPath},
    {
      "id": 3,
      "name": "MobileRecharge",
      "img": ImageConstant.mobileRechargePath
    },
    {"id": 4, "name": "Parlour", "img": ImageConstant.parlourPath},
    {"id": 5, "name": "Pet Food", "img": ImageConstant.petFoodPath},
    {"id": 6, "name": "Movie", "img": ImageConstant.moviePath},
    {"id": 7, "name": "Restaurant", "img": ImageConstant.restaurantPath},
    {"id": 8, "name": "Pug", "img": ImageConstant.pugPath},
  ];

  ///Variables
  static late String title;
  static late bool isDark;

  //Keys use in App
  static const String IS_LOGGED_IN_USER = "loggedIn";
  static const String USER_ID = "UserId";
  static const String USER_EMAIL = "UserEmail";
}

/*addIsLoggedInUserSF(bool isLoggedIn) async {
  SharedPreferences pre = await SharedPreferences.getInstance();
  pre.setBool(AppVariables.IS_LOGGED_IN_USER, isLoggedIn);
}*/

setUserDataInSP(bool isLoggedIn ,int userId,String userEmail) async {
  SharedPreferences pre = await SharedPreferences.getInstance();
  pre.setInt(AppVariables.USER_ID, userId);
  pre.setString(AppVariables.USER_EMAIL, userEmail);
  pre.setBool(AppVariables.IS_LOGGED_IN_USER, isLoggedIn);
}

Future<int> getUserIdFromSP() async {
  SharedPreferences pre = await SharedPreferences.getInstance();
  int? id;
  id = pre.getInt(AppVariables.USER_ID);
  return id ?? 0;
}
Future<String> getUserEmailFromSP() async {
  SharedPreferences pre = await SharedPreferences.getInstance();
  String userEmail;
  userEmail = pre.getString(AppVariables.USER_EMAIL)!;
  return userEmail ?? "";
}

hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

bool getThemeByMQAndThemeContext(BuildContext context) {
  //var mediaQueryData = MediaQuery.of(context); //for getting platform Brightness
  var getThemeData =
      Theme.of(context); //use for getting App theme will be dark and light
  bool isDark = getThemeData.brightness == Brightness.dark;
  return isDark;
}

getThemeColorAccordingLitDrk(BuildContext context, bool isDark) {
  if (isDark) {
    ColorConstant.bgColor = ColorConstant.mattBlackColor;
    ColorConstant.textOnBGColor = Colors.white;
    ColorConstant.secondaryColor = Colors.white;
    ColorConstant.secondaryTextColor = ColorConstant.mattBlackColor;
    ColorConstant.iconColorSM = Colors.blue;
    ColorConstant.textThirdColor = Colors.blueGrey.shade600;
    AppVariables.title = "Dark";

  } else {
    ColorConstant.bgColor = Colors.white;
    ColorConstant.textOnBGColor = ColorConstant.mattBlackColor;
    ColorConstant.secondaryColor = ColorConstant.mattBlackColor;
    ColorConstant.secondaryTextColor = Colors.white;
    ColorConstant.iconColorSM = Colors.yellow;
    ColorConstant.textThirdColor = Colors.blueGrey.shade600;
    AppVariables.title = "Light";
  }
}

//DateTime Format
String convertStringToDateTimeObjectToString(String myDateTime){
  var formatTime = DateTime.parse(myDateTime);
  var formatedDateTime = "${formatTime.year}-${formatTime.month}-${formatTime.day}";
  print("new date $formatedDateTime");
  return formatedDateTime;
}