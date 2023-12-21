import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum TypeOfThing{person, animal}

@immutable 
class Thing{
  final TypeOfThing type; final String name;
  const Thing({required this.type, required this.name});
}


@immutable
class Bloc{
  final Sink<TypeOfThing?> setTypeOfThing; //write only
  final Stream<TypeOfThing?> readTypeOfThing; //read only
  final Stream<Iterable<Thing>> things;

  const Bloc._({required this.setTypeOfThing, required this.readTypeOfThing, required this.things});

  void dispose(){setTypeOfThing.close();}

  factory Bloc({required Iterable<Thing> things}){
    final typeOfThingSubject = BehaviorSubject<TypeOfThing?>();
    final filteredTypeOfThing = typeOfThingSubject.debounceTime(const Duration(milliseconds: 500))
      .map<Iterable<Thing>>((typeOfThing) {
        if(typeOfThing != null){return things.where((thing) => thing.type == typeOfThing);}
        else {return things;}
      }).startWith(things);
    return Bloc._(
      readTypeOfThing: typeOfThingSubject.stream,
      setTypeOfThing: typeOfThingSubject.sink,
      things: filteredTypeOfThing
    );
  }
}


const things = [
  Thing(name: 'Emmanuel', type: TypeOfThing.person),
  Thing(name: 'David', type: TypeOfThing.person),
  Thing(name: 'Kredo', type: TypeOfThing.animal),
  Thing(name: 'Goat', type: TypeOfThing.animal),
  Thing(name: 'Marach', type: TypeOfThing.person),
  Thing(name: 'Dog', type: TypeOfThing.animal)
];


class Example8 extends StatefulWidget {
  const Example8({super.key});

  @override
  State<Example8> createState() => _Example8State();
}

class _Example8State extends State<Example8> {
  late final Bloc bloc;

  @override 
  void initState(){super.initState(); bloc = Bloc(things: things);}

  @override 
  void dispose(){bloc.dispose(); super.dispose();}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FilterChip with RxDart'), centerTitle: true),
      body: Column(
        children: [
          StreamBuilder<TypeOfThing?> (
            stream: bloc.readTypeOfThing,
            builder: (context, snapshot){
              return Wrap(
                children: TypeOfThing.values.map((typeOfThing) {
                  return FilterChip(
                    selectedColor: Colors.blueAccent[100],
                    onSelected: (selected){
                      final type = selected ? typeOfThing : null;
                      bloc.setTypeOfThing.add(type);
                    },
                    label: Text(typeOfThing.name),
                    selected: snapshot.data == typeOfThing
                  );
                }).toList()
              );
            }
          ),
          Expanded(
            child: StreamBuilder<Iterable<Thing>>(
              stream: bloc.things,
              builder: (context, snapshot){
                final things = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: things.length, 
                  itemBuilder: (context, listIndex){
                    final thing = things.elementAt(listIndex);
                    return ListTile(
                      title: Text(thing.name),
                      subtitle: Text(thing.type.name)
                    );
                  }
                );
              }
            )
          )
        ]
      )
    );
  }
}