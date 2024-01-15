//region Imports
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:onboarding_module/screens/bottom_navigation_bar.dart';
import 'package:onboarding_module/screens/sign_up.dart';
import 'package:onboarding_module/theme_provider/theme_provider_ld.dart';
import 'package:onboarding_module/util/global_methods_and_variables.dart';
import 'package:onboarding_module/util/my_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//endregion

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends State<Splash> {

  //region InitMethod
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      checkUserLogin();
    });
  }
  //endregion
  
  //region PrivateMethods
  checkUserLogin() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    bool? loggedInStatus = pre.getBool(AppVariables.IS_LOGGED_IN_USER) ?? false;
    print("Check Key Value $loggedInStatus");
    if (loggedInStatus) {
      // if get ture value
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => BottomNavigationBarFile()));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const SignUpScreen()));
    }
  }
  //endregion

  //region BuildMethod
  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeProvider>().isDark;
    getThemeColorAccordingLitDrk(context, isDark);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.blueGrey,
        child: Center(
            child: Text(
          "Splash",
          style:
              mTextStyle43(mFontColor: Colors.white, mWeight: FontWeight.bold),
        )),
      ),
    );
  }
//endregion
}


