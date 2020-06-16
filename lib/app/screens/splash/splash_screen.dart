import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trellotest/app/navigation/routes.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = new Duration(seconds: 10);
    return new Timer(duration, routeToDashboard);
  }

  routeToDashboard() {
    Navigator.pushNamed(context, HomeRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }

  initScreen(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Opacity(
            opacity: 0.1,
            child: SvgPicture.asset(
              'assets/images/svgs/user_task.svg',
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border.all(color: Colors.white, width: 1),
                    borderRadius: BorderRadius.circular(30)),
                child: Icon(
                  MaterialIcons.dashboard,
                  size: MediaQuery.of(context).size.width * 0.5,
                  color: Colors.white,
                ),
              ),
              Center(
                  child: Text(
                "High Level\nTrello",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 64,
                    letterSpacing: -2,
                    height: 1.15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              )),
              Align(
                  alignment: Alignment.center,
                  child:
                  SpinKitFadingCircle(color: Color.fromRGBO(17, 73, 182, 1))),
            ],
          ),
        ],
      ),
    );
  }
}
