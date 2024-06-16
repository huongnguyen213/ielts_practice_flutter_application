import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ielts_practice_flutter_application/page/auth/pages/login_page.dart';
import 'package:ielts_practice_flutter_application/page/layout/home_page.dart';

import 'page/reading/cubit/test_cubit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TestCubit()..loadData(),
      child: MaterialApp(
        title: 'IELTS App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
