import 'package:flutter/material.dart';
import 'package:moj_grad/login_registracija/LoginStrana.dart';
import 'package:moj_grad/pocetna/PocetnaStrana.dart';
import 'package:moj_grad/splash/SplashScreen.dart';
import 'package:moj_grad/tema/ThemeModel.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() => runApp(
  ChangeNotifierProvider<ThemeModel>(
    builder: (BuildContext context) => ThemeModel(), child: MyApp(),
    )
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return  MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Provider.of<ThemeModel>(context).currentTheme,
            home: SplashScreen(),
            routes: <String, WidgetBuilder>{
            '/LoginStrana': (BuildContext context) => new LoginStrana(),
            '/PocetnaStrana' : (BuildContext context) =>new PocetnaStrana()
          },
          );
  }
}
