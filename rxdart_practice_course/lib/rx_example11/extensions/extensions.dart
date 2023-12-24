import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_practice_course/rx_example11/models/contact_models.dart';

extension Data on Contact {
  Map<String, dynamic> get toJson => {
    Keys.firstNameKey : firstName,
    Keys.lastNameKey: lastName,
    Keys.phoneKey: phone
  };
}

extension Loading<E> on Stream<E> {
  Stream<E> setLoading(bool isLoading, Sink<bool> onSink)
    => doOnEach((_) => onSink.add(isLoading));
}

extension IsDebugging on String{
  String? get isInDebugMode => kDebugMode ? this : null;
  }