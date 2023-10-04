import 'package:flutter/foundation.dart';

class ThemeProvider extends ChangeNotifier{
  bool isDark = false;

  void setThemeValue(bool value){
    isDark = value;

    notifyListeners();
  }

  bool getThemeValue(){
    return isDark;
  }

}