import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum ScreenViews {loginView, registerView, contactListView, createContactView}

@immutable 
class ViewsBloc{
  final Sink<ScreenViews> goToView;
  final Stream<ScreenViews> currentView;

  const ViewsBloc._({required this.goToView, required this.currentView});

  void dispose() => goToView.close();

  factory ViewsBloc(){
    final goToViewSubject = BehaviorSubject<ScreenViews>();
    return ViewsBloc._(
      goToView: goToViewSubject, currentView: goToViewSubject.startWith(ScreenViews.loginView)
    );
  }
}