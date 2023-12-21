import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as marach show log;

extension LogValue on Object{
  void logV() => marach.log(toString());
}

class Example6 extends StatelessWidget {
  const Example6({super.key});

  @override
  Widget build(BuildContext context) {
    testIt();
    return Scaffold(
      appBar: AppBar(title: const Text('Rx Example 4'), centerTitle: true), 
      body: Container()
    );
  }
}


void testIt() async{
  final stream1 = Stream.periodic(const Duration(seconds: 1), (count) => "Stream1 count is $count");
  final stream2 = Stream.periodic(const Duration(seconds: 10), (count) => 'Stream2 count is $count');
  final results = Rx.zip2(stream1, stream2, (a, b) => 'A: $a and B: $b');
  await for (final result in results){result.logV();}
}