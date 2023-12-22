import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@immutable 
class Contact{
  final String id, firstName, lastName, phone;

  const Contact({
    required this.id, required this.firstName, required this.lastName, required this.phone
  });

  Contact.withoutId({required this.firstName, required this.lastName, required this.phone})
    : id = const Uuid().v4();
}