import 'package:flutter/material.dart';
import 'db_page.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: DBTestPage(),
      ),
    );
  }
}