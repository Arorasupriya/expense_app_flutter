//region Imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_module/screens/sign_in.dart';
import 'package:onboarding_module/theme_provider/theme_provider_ld.dart';
import 'package:onboarding_module/util/app_colors.dart';
import 'package:onboarding_module/util/global_methods_and_variables.dart';
import 'package:onboarding_module/util/my_text_styles.dart';
//endregion

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<Settings> {

  //region CreateMaterialPropertyForThumbIcon
  //Switch button code
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.nightlight,
          color: Colors.blue,
        );
      }
      return const Icon(Icons.sunny, color: Colors.yellow);
    },
  );

  //endregion

  //region BuildMethod
  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<ThemeProvider>().isDark;
    getThemeColorAccordingLitDrk(context, isDark);
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: ColorConstant.bgColor,
        //region SetFrames
        body: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Settings",
                style: mTextStyle25(
                    mWeight: FontWeight.bold,
                    mFontColor: ColorConstant.textOnBGColor),
              ),
              const Divider(),
              Row(
                children: [
                  Switch(
                      thumbIcon: thumbIcon,
                      value: isDark,
                      onChanged: (value) {
                        isDark = value;
                        context.read<ThemeProvider>().setThemeValue(value);
                      }),
                  Text(
                    isDark == true ? "Dark Theme" : "Light Theme",
                    style: mTextStyle12(
                        mWeight: FontWeight.bold,
                        mFontColor: ColorConstant.textOnBGColor),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        // addIsLoggedInUserSF(isLoggedIn);
                        //login page me move karna h
                        bool isLoggedIn = false;
                        int uid = 0;
                        String email = "";
                        setUserDataInSP(isLoggedIn, uid,email);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      },
                      icon: const Icon(Icons.logout)),
                  InkWell(
                    onTap: () {
                      //addIsLoggedInUserSF(isLoggedIn);
                      //login page me move karna h
                      bool isLoggedIn = false;
                      int uid = 0;
                      String email = "";
                      setUserDataInSP(isLoggedIn, uid, email);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()));
                    },
                    child: Text(
                      "Sign Out",
                      style: mTextStyle12(
                          mWeight: FontWeight.bold,
                          mFontColor: ColorConstant.textOnBGColor),
                    ),
                  ),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
        //endregion
      ),
    );
  }
//endregion
}
