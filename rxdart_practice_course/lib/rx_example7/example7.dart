import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as marach show log;

extension LogValue on Object{
  void logV() => marach.log(toString());
}

class Example7 extends StatefulWidget {
  const Example7({super.key});

  @override
  State<Example7> createState() => _Example6State();
}

class _Example6State extends State<Example7> {
  late final BehaviorSubject<DateTime> subject;
  late final Stream<String> stream;

  @override 
  void initState(){
    super.initState(); 
    subject = BehaviorSubject<DateTime>();
    stream = subject.switchMap((dateTime) 
      => Stream.periodic(const Duration(seconds: 1), (count) 
        => 'Stream count = $count, dateTime = $dateTime'));
  }

  @override 
  void dispose(){subject.close(); super.dispose();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rx Example 7'), centerTitle: true), 
      body: Column(
        children: [
          StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData){
                return Text(snapshot.data!);
              } else {
                return const Text('Waiting for the button to be pressed');
              }
            }
          ),
          TextButton(
            onPressed: () => subject.add(DateTime.now()),
            child: const Text('Start Stream')
          )
        ]
      )
    );
  }
}

