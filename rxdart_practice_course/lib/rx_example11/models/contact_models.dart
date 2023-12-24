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

  Contact.fromFirebase(Map<String, dynamic> firebaseContact, {required this.id})
   :firstName = firebaseContact[Keys.firstNameKey] as String,
   lastName = firebaseContact[Keys.lastNameKey] as String,
   phone = firebaseContact[Keys.phoneKey] as String;

  String get fullName => '$firstName $lastName';
}


@immutable 
class Keys{
  const Keys();
  static const firstNameKey = 'first_name';
  static const lastNameKey = 'last_name';
  static const phoneKey = 'phone_number';
}