import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_practice_course/rx_example11/bloc/auth_bloc.dart';
import 'package:rxdart_practice_course/rx_example11/bloc/auth_error.dart';
import 'package:rxdart_practice_course/rx_example11/bloc/contacts_bloc.dart';
import 'package:rxdart_practice_course/rx_example11/models/contact_models.dart';
import 'package:rxdart_practice_course/rx_example11/views/views_bloc.dart';

@immutable 
class AppBloc{
  final AuthBloc _authBloc; final ViewsBloc _viewsBloc; final ContactBloc _contactBloc;
  final Stream<ScreenViews> currentView; final Stream<bool> isLoading;
  final Stream<AuthError?> authError; final StreamSubscription<String?> userIdChanges;

  const AppBloc._({
    required authBloc, required ViewsBloc viewsBloc, 
    required ContactBloc contactBloc, required this.currentView, 
    required this.isLoading, required this.authError, required this.userIdChanges
  }) : _authBloc = authBloc, _viewsBloc = viewsBloc, _contactBloc = contactBloc;

  void dispose(){
    _authBloc.dispose(); _viewsBloc.dispose(); _contactBloc.dispose(); userIdChanges.cancel();
  }

  factory AppBloc(){
    final authBloc = AuthBloc(); final viewsBloc = ViewsBloc(); final contactBloc = ContactBloc();
    final userIdChanges = authBloc.userId.listen((id) => contactBloc.userId.add(id));

    final Stream<ScreenViews> currentViewBasedOnAuthStatus = authBloc.authStatus.map<ScreenViews>((status) {
      if(status is AuthStatusLoggedIn){return ScreenViews.contactListView;}
      else{return ScreenViews.loginView;}
    });

    final Stream<ScreenViews> currentView = Rx.merge([currentViewBasedOnAuthStatus, viewsBloc.currentView]);

    final Stream<bool> isLoading = Rx.merge([authBloc.isLoading]);
    return AppBloc._(
      authBloc: authBloc, viewsBloc: viewsBloc,  authError: authBloc.authError.asBroadcastStream(),
      contactBloc: contactBloc, userIdChanges: userIdChanges,
      currentView: currentView, isLoading: isLoading.asBroadcastStream(),
    );
  }

  void deleteContact(Contact contact)
    => _contactBloc.deleteContact.add(contact);

  void createContact(String firstName, String lastName, String phone)
    => _contactBloc.createContact.add(Contact.withoutId(
      firstName: firstName, lastName: lastName, phone: phone
    ));

  void logout() => _authBloc.logoutCommand.add(null);

  void register(String email, String password)
    => _authBloc.registerCommand.add(RegisterCommand(email: email, password: password));

  void login(String email, String password) 
    => _authBloc.loginCommand.add(LoginCommand(email: email, password: password));

  void goToContactListView() => _viewsBloc.goToView.add(ScreenViews.contactListView);

  void goToCreateContactView() => _viewsBloc.goToView.add(ScreenViews.createContactView);

  void goToRegisterView() => _viewsBloc.goToView.add(ScreenViews.registerView);
  
  void goToLoginView() => _viewsBloc.goToView.add(ScreenViews.loginView);

  Stream<Iterable<Contact>> get contacts => _contactBloc.listOfContacts;
}
