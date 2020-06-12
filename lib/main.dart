import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trellotest/app/common_bloc_delegate.dart';
import 'package:trellotest/app/main_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = CommonBlocDelegate();
  runApp(MainApp());
}