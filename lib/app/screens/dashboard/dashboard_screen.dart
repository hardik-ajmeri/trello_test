import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trellotest/app/screens/dashboard/bloc/bloc.dart';
import 'package:trellotest/app/screens/dashboard/dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<DashboardBloc>(
        create: (context) => DashboardBloc(),
        child: GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: DashboardView()),
      ),
    );
  }
}
