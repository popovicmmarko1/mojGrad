import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';

class ThemeModel extends ChangeNotifier {

 ThemeModel(){
    loadTheme();
  }

  void loadTheme() async{
    SharedPreferences p = await SharedPreferences.getInstance();
    if(p.getBool('themeBool') != null){
      currentTheme = ( p.getBool('themeBool') == true ) ?  darkTheme : lightTheme;
      _themeType = ( p.getBool('themeBool') == true ) ? ThemeType.Dark : ThemeType.Light;

      return notifyListeners();
    }
    else{
      currentTheme = lightTheme;
      _themeType = ThemeType.Light;

      return notifyListeners();
    }
  }

  ThemeData currentTheme;
  ThemeType _themeType;

  //ThemeData currentTheme = lightTheme;
  //ThemeType _themeType = ThemeType.Light;

  toggleTheme() {
    if (_themeType == ThemeType.Dark) {
      currentTheme = lightTheme;

      _themeType = ThemeType.Light;

      return notifyListeners();
    }
    if (_themeType == ThemeType.Light) {
      currentTheme = darkTheme;

      _themeType = ThemeType.Dark;

      return notifyListeners();
    }
  }
  defaultTheme(){
    currentTheme = lightTheme;
    _themeType = ThemeType.Light;

    notifyListeners();
  }
}