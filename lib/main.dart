//region Imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onboarding_module/bloc/expense_bloc.dart';
import 'package:onboarding_module/database/database.dart';
import 'package:onboarding_module/screens/splash.dart';
import 'package:onboarding_module/theme_provider/theme_provider_ld.dart';
import 'package:provider/provider.dart';
//endregion

//region MainMethod

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
      ),
      BlocProvider(create: (context) => ExpenseBloc(db: AppDatabase.db)),
    ],
    child: const MyApp(),
  ));
}
//endregion

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  //by default
  //region BuildMethod
  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).getThemeValue();
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: ColorConstant.bgColor, statusBarIconBrightness:isDark?Brightness.light:Brightness.dark ));*/
    return Consumer<ThemeProvider>(builder: (context, provider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OnBoarding',
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        //ThemMode mene light or dark kiya so print(themedata.brightness)==> light,dark jo bhi yha set hoga
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        theme: ThemeData(
            brightness: Brightness.light, primarySwatch: Colors.blueGrey),
        home: const Splash(), //const SignUpScreen(),
      );
    });
  }
//endregion
}
