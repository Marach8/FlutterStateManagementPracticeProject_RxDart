import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Example4 extends StatelessWidget {
  const Example4({super.key});

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
  final stream1 = Stream.periodic(const Duration(seconds: 1), (count) => "Stream1 count is $count").take(3);
  final stream2 = Stream.periodic(const Duration(seconds: 1), (count) => 'Stream2 count is $count');
  final results = stream1.concatWith([stream2]);
  await for (final result in results){print(result);}
}