import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

class Example1 extends HookWidget {
  const Example1({super.key});

  @override
  Widget build(BuildContext context) {
    final subject = useMemoized(() => BehaviorSubject<String>(), [key]);
    useEffect(() => subject.close, [subject]);
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
          stream: subject.stream.distinct().debounceTime(const Duration(seconds: 1)),
          initialData: 'Please Start typing', 
          builder: (context, snapshot) {
            return Text(snapshot.requireData);
          }
        ),
        centerTitle: true,),
      body: Center(child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          onChanged: subject.sink.add,
        ),
      ))
    );
  }
}