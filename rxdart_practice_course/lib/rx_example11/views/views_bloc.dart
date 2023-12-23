import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum Views {loginView, registerView, contactListView, createContactView}

@immutable 
class ViewsBloc{
  final Sink<Views> goToView;
  final Stream<Views> currentView;

  const ViewsBloc._({required this.goToView, required this.currentView});

  void dispose() => goToView.close();

  factory ViewsBloc(){
    final goToViewSubject = BehaviorSubject<Views>();
    return ViewsBloc._(goToView: goToViewSubject, currentView: goToViewSubject.startWith(Views.loginView));
  }
}