import 'package:flutter/material.dart';
import 'package:e_records/pages/homepage.dart';
import 'utils/constant.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-Records',
      theme: ThemeData.dark().copyWith(
        textTheme: kTextTheme,
      ),
      home: HomePage(),
    );
  }
}
