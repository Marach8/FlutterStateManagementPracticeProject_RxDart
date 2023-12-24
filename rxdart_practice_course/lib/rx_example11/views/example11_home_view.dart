import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rxdart_practice_course/rx_example11/bloc/app_bloc.dart';
import 'package:rxdart_practice_course/rx_example11/bloc/auth_error.dart';
import 'package:rxdart_practice_course/rx_example11/bloc/views_bloc.dart';
import 'package:rxdart_practice_course/rx_example11/dialogs/error_dialogs.dart';
import 'package:rxdart_practice_course/rx_example11/loading/loading_screen.dart';
import 'package:rxdart_practice_course/rx_example11/views/contacts_listview.dart';
import 'package:rxdart_practice_course/rx_example11/views/login_view.dart';
import 'package:rxdart_practice_course/rx_example11/views/new_contact_view.dart';
import 'package:rxdart_practice_course/rx_example11/views/register_view.dart';

class Example11 extends StatefulWidget {
  const Example11({super.key});

  @override
  State<Example11> createState() => _Example11State();
}

class _Example11State extends State<Example11> {
  late final AppBloc appBloc;
  StreamSubscription<AuthError?>? _authErrorSub;
  StreamSubscription<bool>? _isLoadingSub;

  @override
  void initState(){
    super.initState(); 
    appBloc = AppBloc();
  }

  @override 
  void dispose(){
    appBloc.dispose(); _authErrorSub?.cancel(); 
    _isLoadingSub?.cancel(); super.dispose();
  }

  void handleAuthErrors(BuildContext context) async{
    await _authErrorSub?.cancel();
    _authErrorSub = appBloc.authError.listen((error) {
      if(error == null){return;}
      else{showAuthErrorDialog(error: error, context: context);}
    });
  }

  void setUpLoadingScreen(BuildContext context) async{
    final LoadingScreen loadingScreen = LoadingScreen();
    await _isLoadingSub?.cancel();
    _isLoadingSub = appBloc.isLoading.listen((isLoading){
      if(isLoading){loadingScreen.showLoadingScreen(context, 'Loading...');}
      else{loadingScreen.hideLoadingScreen();}
    });
  }


  Widget returnViews(){
    return StreamBuilder<ScreenViews> (
      stream: appBloc.currentView,
      builder: (context, snapshot){
        switch(snapshot.connectionState){          
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            final view = snapshot.requireData;
            switch(view){              
              case ScreenViews.loginView:
                return LoginView(
                  login: appBloc.login, 
                  gotoRegisterView: appBloc.goToRegisterView
                );
              case ScreenViews.registerView:
                return RegisterView(
                  register: appBloc.register, 
                  gotoLoginView: appBloc.goToLoginView
                );
              case ScreenViews.contactListView:
                return ContactListView( 
                  deleteContact: appBloc.deleteContact, 
                  logout: appBloc.logout,
                  deleteAccount: appBloc.deleteAccount, 
                  createNewContact: appBloc.goToCreateContactView, 
                  contacts: appBloc.contacts
                );
              case ScreenViews.createContactView:
                return NewContactView(
                  createContactCallback: appBloc.createContact, 
                  goBackCallback: appBloc.goToContactListView
                );
            }
        }
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    handleAuthErrors(context);
    setUpLoadingScreen(context);
    return returnViews();
  }
}