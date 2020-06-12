import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trellotest/app/navigation/router.dart' as Router;
import 'package:trellotest/app/navigation/routes.dart' as Routes;
import 'package:trellotest/app/screens/splash/splash_screen.dart';

class MainApp extends StatelessWidget {

  ThemeData theme = ThemeData(
    primaryColor: Colors.white,
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
