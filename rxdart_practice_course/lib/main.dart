import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rxdart_practice_course/firebase_options.dart';
import 'package:rxdart_practice_course/rx_example1/example1.dart';
import 'package:rxdart_practice_course/rx_example10/example10.dart';
import 'package:rxdart_practice_course/rx_example2/views/home_view.dart';
import 'package:rxdart_practice_course/rx_example3/example3.dart';
import 'package:rxdart_practice_course/rx_example4/example4.dart';
import 'package:rxdart_practice_course/rx_example5/example5.dart';
import 'package:rxdart_practice_course/rx_example6/example6.dart';
import 'package:rxdart_practice_course/rx_example7/example7.dart';
import 'package:rxdart_practice_course/rx_example8/example8.dart';
import 'package:rxdart_practice_course/rx_example9/example9.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

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
      home: const Example10()
    );
  }
}