import 'package:flutter/material.dart';

enum Views {loginView, registerView, contactListView, createContactView}

@immutable 
class ViewsBloc{
  final Sink<Views> goToView;
  final Stream<Views> currentView;
}