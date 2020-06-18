import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trellotest/app/navigation/router.dart' as Router;
import 'package:trellotest/app/navigation/routes.dart' as Routes;
import 'package:trellotest/app/screens/splash/splash_screen.dart';

class MainApp extends StatelessWidget {
  ThemeData theme = ThemeData(
      primaryColor: Color.fromRGBO(17, 73, 182, 1),
      cursorColor: Color.fromRGBO(17, 73, 182, 1),
      toggleableActiveColor: Color.fromRGBO(17, 73, 182, 1),
      textSelectionColor: Color.fromRGBO(17, 73, 182, 0.5),
      textSelectionHandleColor: Color.fromRGBO(17, 73, 182, 0.5),
//      inputDecorationTheme: InputDecorationTheme(
//          border: const OutlineInputBorder(
//              borderSide: BorderSide(color: Color.fromRGBO(17, 73, 182, 1))),
//          enabledBorder: OutlineInputBorder(
//              borderSide: BorderSide(color: Color.fromRGBO(17, 73, 182, 0.5))),
//          focusedBorder: const OutlineInputBorder(
//              borderSide: BorderSide(color: Color.fromRGBO(17, 73, 182, 1))))
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Router.generateRoute,
      initialRoute: Routes.SplashRoute,
      home: SplashScreen(),
    );
  }
}
