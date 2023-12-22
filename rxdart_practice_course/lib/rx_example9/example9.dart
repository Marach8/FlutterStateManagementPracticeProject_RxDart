import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


@immutable 
class Bloc{
  final Sink<String?> firstNameSink;
  final Sink<String?> lastNameSink;
  final Stream<String> fullName;
  

  const Bloc._({required this.firstNameSink, required this.lastNameSink, required this.fullName});

  void dispose(){firstNameSink.close(); lastNameSink.close();}

  factory Bloc(){
    final firstNameSubject = BehaviorSubject<String?>();
    final lastNameSubject = BehaviorSubject<String?>();
    final Stream<String> fullName = Rx.combineLatest2(
      firstNameSubject.startWith(null), lastNameSubject.startWith(null),
      (firstName, lastName){
        if(firstName != null && firstName.isNotEmpty && lastName != null && lastName.isNotEmpty){
          return '$firstName $lastName';
        } else{return 'Please provide both the first and last name!';}
      }
    );
    return Bloc._(firstNameSink: firstNameSubject.sink, lastNameSink: lastNameSubject.sink, fullName: fullName);
  }
}


typedef AsyncSnapshotBuilderCallback<T> = Widget Function(BuildContext context, T? value);

class AsyncSnapshotBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final AsyncSnapshotBuilderCallback<T>? onNone;
  final AsyncSnapshotBuilderCallback<T>? onDone;
  final AsyncSnapshotBuilderCallback<T>? onActive;
  final AsyncSnapshotBuilderCallback<T>? onWaiting;

  const AsyncSnapshotBuilder({
    required this.stream, this.onNone, this.onDone,
    this.onActive, this.onWaiting, super.key
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream, 
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.none:
            final callback = onNone ?? (_, __) => const SizedBox();
            return callback(context, snapshot.data);
          case ConnectionState.waiting:
            final callback = onWaiting ?? (_, __) => const CircularProgressIndicator();
            return callback(context, snapshot.data);
          case ConnectionState.active:
            final callback = onActive ?? (_, __) => const SizedBox();
            return callback(context, snapshot.data);
          case ConnectionState.done:
            final callback = onDone ?? (_, __) => const SizedBox();
            return callback(context, snapshot.data);
        }
      }
    );
  }
}



class Example9 extends StatefulWidget {
  const Example9({super.key});

  @override
  State<Example9> createState() => _Example9State();
}

class _Example9State extends State<Example9> {
  late final Bloc bloc;

  @override 
  void initState(){super.initState(); bloc = Bloc();}

  @override 
  void dispose(){bloc.dispose(); super.dispose();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CombineLatest Example with RxDart'), centerTitle: true),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Enter firstName'),
            onChanged: bloc.firstNameSink.add
          ),
          TextField(
            decoration: const InputDecoration(hintText: 'Enter lastName'),
            onChanged: bloc.lastNameSink.add
          ),
          AsyncSnapshotBuilder<String>(
            stream: bloc.fullName,
            onActive: (context, value) => Text(value ?? '')
          )
        ]
      )
    );
  }
}
