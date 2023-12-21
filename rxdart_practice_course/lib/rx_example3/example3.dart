import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Example3 extends StatelessWidget {
  const Example3({super.key});

  @override
  Widget build(BuildContext context) {
    testIt();
    return Scaffold(
      appBar: AppBar(title: const Text('Rx Example 3'), centerTitle: true), 
      body: Container()
    );
  }
}

void testIt() async{
  final stream1 = Stream.periodic(const Duration(seconds: 1), (count) => "Stream1 count is $count");
  final stream2 = Stream.periodic(const Duration(seconds: 3), (count) => 'Stream2 count is $count');
  final combinedStream = Rx.combineLatest2(stream1, stream2, (a, b) => 'One is $a, Two is $b');
  await for (final value in combinedStream){print(value);}
}