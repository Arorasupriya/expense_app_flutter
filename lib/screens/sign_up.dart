//region Imports
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:onboarding_module/database/database.dart';
import 'package:onboarding_module/models/user_model.dart';
import 'package:onboarding_module/screens/sign_in.dart';
import 'package:onboarding_module/theme_provider/theme_provider_ld.dart';
import 'package:onboarding_module/util/app_colors.dart';
import 'package:onboarding_module/util/custom_widget.dart';
import 'package:onboarding_module/util/global_methods_and_variables.dart';
import 'package:onboarding_module/util/my_text_styles.dart';
import 'package:provider/provider.dart';
//endregion

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {

  //region VariableDeclare
  var formKey = GlobalKey<FormState>();
  var txtEmailController = TextEditingController();
  var txtMobileNoController = TextEditingController();
  var txtReEnteredPasswordController = TextEditingController();
  var txtPasswordController = TextEditingController();

  String? gender;
  String genderErrorMsg = "";
  String? matchPasswordText;
  String? passwordVerifyErrorMsg;
  bool? isVerifyPassword;
  bool isPasswordVisible = true;
  bool isValidForSign = false;

  AppDatabase? db;
  //endregion


  //region initMethod
  @override
  void initState() {
    db = AppDatabase.db;
    super.initState();
  }
  //endregion

  //region PrivateMethod
  addUserAccount(UserModel userModel) async {
    var check = await db!.addUserRecord(userModel);
    if (check) {
      stdout.write("record added $check");
    }
  }

  showDialogMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
            content: const Text("You have already an account please Login"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    goToNextScreen();
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }

  goToNextScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignInScreen()));
  }

  cHideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
  //endregion


  //region BuildMethod
  @override
  Widget build(BuildContext context) {
    // isDark = getThemeByMQAndThemeContext(context);
    bool isDark = context.watch<ThemeProvider>().isDark;
    getThemeColorAccordingLitDrk(context, isDark);

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.bgColor,
        //scenario of background only here isDark so we put color black
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //SizeBox
                  hSpacer(mHeight: 30),
                  //Title
                  Row(
                    children: [
                      Switch(
                          value: isDark,
                          onChanged: (value) {
                            isDark = value;
                            context.read<ThemeProvider>().setThemeValue(value);
                          }),
                      Text(
                        AppVariables.title,
                        style: mTextStyle12(
                            mFontColor: ColorConstant.textOnBGColor,
                            mWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  hSpacer(mHeight: 10),
                  //title text
                  Center(
                    child: Text(
                      "Sign Up",
                      style: mTextStyle25(
                          mFontColor: ColorConstant.textOnBGColor,
                          mWeight: FontWeight.bold),
                    ),
                  ),

                  //SizeBox
                  hSpacer(mHeight: 20),

                  //txtEmail
                  SizedBox(
                    height: 70,
                    child: TextFormField(
                        onFieldSubmitted: (value) async {
                          if (value != "") {
                            var existListRecordLength = await db!
                                .isUserAllReadyExistOrNot(
                                    email: txtEmailController.text.toString());
                            if (existListRecordLength > 0) {
                              showDialogMessage();
                              cHideKeyboard();
                              isValidForSign = true;
                            }
                          }
                        },
                        validator: (value) {
                          if (value == "") {
                            return "Please Fill Email Field First";
                          }
                          return null;
                        },
                        style: mTextStyle16(),
                        scrollPadding: const EdgeInsets.all(20.0),
                        controller: txtEmailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        decoration: myDecoration(
                          bColor: ColorConstant.secondaryColor,
                          mHintText: "Enter Email",
                          mLabelText: "Please Enter Email",
                          preFixIconName: Icons.email,
                        )),
                  ),
                  //SizeBox
                  hSpacer(mHeight: 5),
                  //txtMobileNumber
                  SizedBox(
                    height: 70,
                    child: TextFormField(
                      validator: (value) {
                        if (value != "") {
                          if (value!.length != 10) {
                            return "Please enter correct no ";
                          }
                        } else {
                          return "Please Fill Mobile Number Field First";
                        }

                        return null;
                      },
                      scrollPadding: const EdgeInsets.all(20.0),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: txtMobileNoController,
                      decoration: myDecoration(
                          bColor: ColorConstant.secondaryColor,
                          mHintText: "Enter Mobile Number",
                          mLabelText: "Please Enter Mobile Number",
                          preFixIconName: Icons.phone),
                    ),
                  ),
                  //SizeBox
                  hSpacer(mHeight: 10),

                  //txtPassword
                  SizedBox(
                    height: 70,
                    child: TextFormField(
                      validator: (value) {
                        if (value == "") {
                          return "Please Fill Password Field First";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          matchPasswordText = value;
                        }
                      },
                      onFieldSubmitted: (value){
                        if(value==""){
                          passwordVerifyErrorMsg="";
                          setState(() {});
                        }
                      },
                      scrollPadding: const EdgeInsets.all(20.0),
                      controller: txtPasswordController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      obscureText: isPasswordVisible,
                      decoration: myDecoration(
                        bColor: ColorConstant.secondaryColor,
                        mHintText: "Enter Password",
                        mLabelText: "Please Enter Password",
                        preFixIconName: Icons.password,
                      ),
                    ),
                  ),

                  //SizeBox
                  hSpacer(mHeight: 10),
                  //txtPasswordVerify
                  SizedBox(
                    height: 70,
                    child: TextFormField(
                        validator: (value) {
                          if (value == "") {
                            return "Please Type Password Again For Verify Password";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if(value != ""){
                            bool vPStatus = (value == matchPasswordText);
                            isVerifyPassword = vPStatus;
                            if (!vPStatus) {
                              passwordVerifyErrorMsg =
                              "Please type correct password! password not match";
                              setState(() {});
                            } else {
                              passwordVerifyErrorMsg = "Your password is match";
                              setState(() {});
                            }
                          }

                        },
                        onFieldSubmitted: (value){
                          if(value==""){
                            passwordVerifyErrorMsg="";
                            setState(() {});
                          }
                        },
                        scrollPadding: const EdgeInsets.all(20.0),
                        controller: txtReEnteredPasswordController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.text,
                        obscureText: isPasswordVisible,
                        decoration: myDecoration(
                            bColor: ColorConstant.secondaryColor,
                            mHintText: "Enter Password Again",
                            mLabelText: "Please Enter Password Again",
                            surFixIconName: isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            onSurFixIconTap: () {
                              isPasswordVisible = !isPasswordVisible;
                              setState(() {});
                            })),
                  ),
                  //SizeBox
                  hSpacer(mHeight: 10),
                  //txtShowErrorPassword
                  Text(
                    passwordVerifyErrorMsg == null ? "" : passwordVerifyErrorMsg!,
                    style: mTextStyle12(
                        mWeight: FontWeight.bold,
                        mFontColor: ColorConstant.textOnBGColor),
                  ),
                  //SizeBox
                  hSpacer(mHeight: 10),

                  //txtShowGenderErrorMsg
                  Text(
                    "Select Gender",
                    style: mTextStyle16(
                      mWeight: FontWeight.bold,
                      mFontColor: ColorConstant.textOnBGColor,
                    ),
                  ),

                  RadioListTile(
                    title:  Text("Male",style: mTextStyle16(mFontColor: ColorConstant.textOnBGColor),),
                    value: "male",
                    groupValue: gender,
                    //type of value i take String type
                    activeColor: ColorConstant.textOnBGColor,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                        genderErrorMsg = "";
                      });
                    },
                  ),

                  RadioListTile(
                    title:  Text("Female",style: mTextStyle16(mFontColor: ColorConstant.textOnBGColor),),
                    value: "female",
                    groupValue: gender,
                    activeColor: ColorConstant.textOnBGColor,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                        genderErrorMsg = "";
                      });
                    },
                  ),

                  Text(
                    genderErrorMsg,
                    style: mTextStyle12(
                        mWeight: FontWeight.bold,
                        mFontColor: ColorConstant.textOnBGColor),
                  ),

                  //SizeBox
                  hSpacer(),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstant.secondaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(21))),
                        onPressed: () {
                          //manage gender error msg
                          if (gender == null) {
                            genderErrorMsg = "Please select gender";
                            setState(() {});
                          } else if (gender != null) {
                            genderErrorMsg = "";
                            setState(() {});
                          }
                          //manage all text fields validations
                          if (formKey.currentState != null) {
                            if (formKey.currentState!.validate()) {
                              if (gender != null) {
                                var email = txtEmailController.text.toString();
                                var mobileNo =
                                    txtMobileNoController.text.toString();
                                String? password;
                                if (isVerifyPassword!) {
                                  password = txtReEnteredPasswordController.text
                                      .toString();
                                }
                                addUserAccount(UserModel(
                                    email: email,
                                    mobile_no: mobileNo,
                                    password: password!,
                                    gender: gender));
                                stdout.write("success now create account now ");
                                formKey.currentState!.reset();
                                goToNextScreen();
                              }
                            }
                          }
                        },
                        child: Text("Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: ColorConstant.secondaryTextColor,
                            ))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
//endregion
}

//region CommentedCode
/*
  Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.mattBlackColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21))),
                      onPressed: !isValidForSign
                          ? null
                          : () async {
                              var existListRecordLength = await db!
                                  .isUserAllReadyExistOrNot(
                                      email:
                                          txtEmailController.text.toString());
                              if (existListRecordLength > 0) {

                              }
                            },
                      child: const Text("Sign In",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ))),
                )
*/
//endregion
