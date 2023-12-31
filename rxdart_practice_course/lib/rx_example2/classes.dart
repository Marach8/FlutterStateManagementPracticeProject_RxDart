import 'package:flutter/material.dart';

@immutable 
class Thing{
  final String name;
  const Thing({required this.name});
}



@immutable 
class Animal extends Thing{
  final String type;
  const Animal({required String name, required this.type}): super(name: name);

  @override 
  String toString() => "Animal: name = $name, type = $type";

  factory Animal.fromRemoteJson(Map<String, dynamic> marach){
    return Animal(name: marach["name"] as String, type: marach["type"]);
  }
}



@immutable 
class Person extends Thing{
  final int age;
  const Person({required String name, required this.age}): super(name: name);

  @override 
  String toString() => "Person: name = $name, age = $age";

  Person.fromRemoteJson(Map<String, dynamic> marach)
    : age = marach["age"] as int, super(name: marach["name"] as String);
}