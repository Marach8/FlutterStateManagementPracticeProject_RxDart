import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';


Stream<String> getName(String filePath){
  final names = rootBundle.loadString(filePath);
  return Stream.fromFuture(names).transform(const LineSplitter());
}


Stream<String> getAllNames() => 
  getName('assets/texts/cats.txt').concatWith([getName('assets/texts/dogs.txt')])
    .delay(const Duration(seconds:3));



class Example10 extends StatelessWidget {
  const Example10({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('concatWith in RxDart'), centerTitle: true),
      body: FutureBuilder<List<String>>(
        future: getAllNames().toList(),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              final names = snapshot.requireData;
              return ListView.separated(
                separatorBuilder: (_, __) => const Divider(color: Colors.black),
                itemCount: names.length,
                itemBuilder: (_, index){
                  return ListTile(title: Text(names.elementAt(index)));
                }
              );
          }
        }
      )
    );
  }
}