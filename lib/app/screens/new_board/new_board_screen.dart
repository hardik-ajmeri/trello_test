import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trellotest/app/screens/new_board/bloc/bloc.dart';
import 'package:trellotest/app/screens/new_board/new_board_form.dart';

class NewBoardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(15),
      body: BlocProvider<NewBoardBloc>(
        create: (context) => NewBoardBloc(),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: NewBoardForm()
        ),
      ),
    );
  }
}
