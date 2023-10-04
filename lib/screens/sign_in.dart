//region Imports
import 'package:flutter/material.dart';
import 'package:onboarding_module/database/database.dart';
import 'package:onboarding_module/screens/bottom_navigation_bar.dart';
import 'package:onboarding_module/theme_provider/theme_provider_ld.dart';
import 'package:onboarding_module/util/app_colors.dart';
import 'package:onboarding_module/util/custom_widget.dart';
import 'package:onboarding_module/util/global_methods_and_variables.dart';
import 'package:onboarding_module/util/my_text_styles.dart';
import 'package:provider/provider.dart';
//endregion

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {

  //region VariableDeclare
  var txtEmailController = TextEditingController();
  var txtPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPasswordVisible = true;
  AppDatabase? db;
  //endregion

  //region InitMethod
  @override
  void initState() {
    db = AppDatabase.db;
    super.initState();
  }
  //endregion

  //region PrivateMethods
  showDialogMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
            content: const Text("Invalid Credentials"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }

  gotoDashboard() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>  const BottomNavigationBarFile()));
  }
  //endregion

  //region BuildMethod
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).getThemeValue();
    getThemeColorAccordingLitDrk(context, isDark);

    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: mTextStyle25(
                    mWeight: FontWeight.bold,
                    mFontColor: ColorConstant.textOnBGColor),
              ),
              hSpacer(mHeight: 10),
              SizedBox(
                height: 70,
                child: TextFormField(
                  validator: (value) {
                    if (value == "") {
                      return "Please enter email or mobile number";
                    }
                    return null;
                  },
                  scrollPadding: const EdgeInsets.all(20.0),
                  controller: txtEmailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: myDecoration(
                      bColor: ColorConstant.textOnBGColor,
                      mHintText: "Enter Email",
                      mLabelText: "Please Enter Email",
                      preFixIconName: Icons.email),
                ),
              ),
              hSpacer(mHeight: 10),
              SizedBox(
                height: 70,
                child: TextFormField(
                  validator: (value) {
                    if (value == "") {
                      return "Please enter password";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    //FocusManager.instance.primaryFocus?.unfocus();
                    //FocusScope.of(context).requestFocus( FocusNode());
                    FocusScope.of(context).unfocus();
                  },
                  scrollPadding: const EdgeInsets.all(20.0),
                  textInputAction: TextInputAction.done,
                  controller: txtPasswordController,
                  keyboardType: TextInputType.text,
                  obscureText: isPasswordVisible,
                  decoration: myDecoration(
                      bColor: ColorConstant.textOnBGColor,
                      mHintText: "Enter Password",
                      mLabelText: "Please Enter Password",
                      preFixIconName: Icons.password,
                      surFixIconName: isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      onSurFixIconTap: () {
                        isPasswordVisible = !isPasswordVisible;
                        setState(() {});
                      }),
                ),
              ),
              hSpacer(mHeight: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstant.secondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(21)),
                  ),
                  onPressed: () async {
                    if (formKey.currentState != null) {
                      if (formKey.currentState!.validate()) {
                        var existListRecordLength = await db!
                            .isPasswordEmailNumber(
                                emailMobileNo:
                                    txtEmailController.text.toString(),
                                password:
                                    txtPasswordController.text.toString());
                        if (existListRecordLength > 0) {
                          print("Success fully logged in ");

                          gotoDashboard();
                        } else {
                          showDialogMessage();
                        }
                      }
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.secondaryTextColor,
                        fontSize: 16),
                  ))
            ],
          ),
        ),
      ),
    );
  }
//endregion
}
