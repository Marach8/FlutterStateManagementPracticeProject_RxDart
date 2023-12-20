import 'dart:convert';
import 'dart:io';
import 'package:rxdart_practice_course/rx_example2/classes.dart';

typedef SearchTerm = String;

class Api{
  List<Animal>? _animals; List<Person>? _persons;
  Api();

  Future<List<Thing>> getFromRemote(SearchTerm item) async{
    final term = item.trim().toLowerCase();
    final result = getFromCache(term);
    if(result != null){return Future.value(result);}
    else{
      final personsFromRemote = await getJsonFromRemote(
        'http://192.168.0.167:5500/rxdart_practice_course/apis/persons.json'
      )
      .then((value) => value.map((finalValue) => Person.fromRemoteJson(finalValue)));
      _persons = personsFromRemote.toList();

      final animalsFromRemote = await getJsonFromRemote(
        'http://192.168.0.167:5500/rxdart_practice_course/apis/animals.json'
      )
      .then((value) => value.map((finalValue) => Animal.fromRemoteJson(finalValue)));
      _animals = animalsFromRemote.toList();

      return Future.value(getFromCache(term) ?? []);
    }
  }

  List<Thing>? getFromCache(SearchTerm term){
    if(_animals != null && _persons != null){
      List<Thing> listOfThings = [];
      for(final animal in _animals!){
        if (animal.name.trimedCase(term) || animal.type.trimedCase(term))
          {listOfThings.add(animal);}
      }
      for(final person in _persons!){
        if (person.name.trimedCase(term) || person.age.toString().trimedCase(term))
          {listOfThings.add(person);}
      }
      return listOfThings;
    } else{return null;}
  }

  Future<List<dynamic>> getJsonFromRemote(String url ) => 
    HttpClient().getUrl(Uri.parse(url)).then((request) => request.close())
    .then((response) => response.transform(utf8.decoder).join())
    .then((jsonString) => json.decode(jsonString) as List<dynamic>);
}


extension TrimingCaseInsensitive on String{
  bool trimedCase(String other) => trim().toLowerCase()
    .contains(other.trim().toLowerCase());
}