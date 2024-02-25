import 'package:flutter/material.dart';

import 'home.dart';

void main (){
  runApp(MaterialApp(
  theme: ThemeData(
    textTheme: TextTheme(
      titleLarge: TextStyle(fontSize: 35.0, fontStyle: FontStyle.italic),
    ),
  )
  ,home: Runner(),debugShowCheckedModeBanner: false,));
}
class Runner extends StatefulWidget {
  const Runner({super.key});

  @override
  State<Runner> createState() => _RunnerState();
}

class _RunnerState extends State<Runner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Home(),
    );
  }
}
