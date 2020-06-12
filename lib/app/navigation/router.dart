import 'package:flutter/material.dart';
import 'package:trellotest/app/navigation/routes.dart';
import 'package:trellotest/app/screens/splash/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashRoute:
      MaterialPageRoute(builder: (context) => SplashScreen());
    defalult:
      MaterialPageRoute(builder: (context) => SplashScreen());
  }
}