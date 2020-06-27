import 'package:flutter/material.dart';
import 'package:trellotest/app/model/hl_board.dart';
import 'package:trellotest/app/navigation/routes.dart';
import 'package:trellotest/app/screens/boards/task_list_screen.dart';
import 'package:trellotest/app/screens/dashboard/dashboard_screen.dart';
import 'package:trellotest/app/screens/home/home_screen.dart';
import 'package:trellotest/app/screens/new_board/new_board_screen.dart';
import 'package:trellotest/app/screens/splash/splash_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SplashRoute:
      return MaterialPageRoute(builder: (context) => SplashScreen());
    case HomeRoute:
      return MaterialPageRoute(builder: (context) => HomeScreen());
    case DashboardRoute:
      return MaterialPageRoute(builder: (context) => DashboardScreen());
    case DashboardRoute:
      return MaterialPageRoute(builder: (context) => DashboardScreen());
    case AddNewCardRoute:
      return MaterialPageRoute(builder: (context) => NewBoardScreen(), fullscreenDialog: true);
    case ViewBoardRoute:
      var board = settings.arguments as HLBoard;
      return MaterialPageRoute(builder: (context) => TaskListScreen(board: board));
    defalult:
      return MaterialPageRoute(builder: (context) => SplashScreen());
  }
}