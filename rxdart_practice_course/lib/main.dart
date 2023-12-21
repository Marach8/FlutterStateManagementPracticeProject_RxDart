import 'package:flutter/material.dart';
import 'package:rxdart_practice_course/rx_example1/example1.dart';
import 'package:rxdart_practice_course/rx_example2/views/home_view.dart';
import 'package:rxdart_practice_course/rx_example3/example3.dart';

void main() {runApp(const MyApp());}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
        useMaterial3: true,
        unselectedWidgetColor: Colors.yellow
      ),
      home: const Example3()
    );
  }
}