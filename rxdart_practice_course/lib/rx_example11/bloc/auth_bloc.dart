import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_practice_course/rx_example11/bloc/auth_error.dart';
import 'package:rxdart_practice_course/rx_example11/extensions/extensions.dart';

//For the commands
@immutable 
abstract class AuthCommand{
  final String email, password;
  const AuthCommand({required this.email, required this.password});
}

@immutable 
class LoginCommand extends AuthCommand{
  const LoginCommand({required super.email, required super.password});
}


@immutable 
class RegisterCommand extends AuthCommand{
  const RegisterCommand({required super.email, required super.password});
}


//For the status
@immutable 
abstract class AuthStatus{const AuthStatus();}

@immutable
class AuthStatusLoggedIn implements AuthStatus{
 const AuthStatusLoggedIn();
}


@immutable
class AuthStatusLoggedOut implements AuthStatus{
  const AuthStatusLoggedOut();
}



@immutable 
class AuthBloc{
  //Read Only properties
  final Stream<AuthStatus> authStatus; final Stream<AuthError?> authError;
  final Stream<String?> userId; final Stream<bool> isLoading;
  //Write Only properties
  final Sink<LoginCommand> loginCommand;
  final Sink<RegisterCommand> registerCommand;
  final Sink<void> logoutCommand;

  void dispose(){loginCommand.close(); registerCommand.close(); logoutCommand.close();}

  const AuthBloc._({
    required this.authStatus, required this.authError, required this.userId,
    required this.isLoading, required this.loginCommand, 
    required this.registerCommand, required this.logoutCommand
  });

  factory AuthBloc(){
    final isLoading = BehaviorSubject<bool>();

    final Stream<AuthStatus> authStatus = FirebaseAuth.instance
      .authStateChanges().map((user) => user == null ? const AuthStatusLoggedOut() : const AuthStatusLoggedIn());

    final Stream<String?> userId = FirebaseAuth.instance.authStateChanges().map((user) => user?.uid).
      startWith(FirebaseAuth.instance.currentUser?.uid);
    //Login and error handling
    final login = BehaviorSubject<LoginCommand>();

    final Stream<AuthError?> loginError = login.setLoading(true, isLoading.sink).asyncMap<AuthError?>((command) async{
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: command.email, password: command.password);
        return null;
      } on FirebaseAuthException catch(e){return AuthError.from(e);}
      catch (_){return const UnknownAuthError();}
    }).setLoading(false, isLoading.sink);

    //Register and error handling
    final register = BehaviorSubject<RegisterCommand>();

    final Stream<AuthError?> registerError = register.setLoading(true, isLoading.sink).asyncMap<AuthError?>((command) async{
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: command.email, password: command.password);
        return null;
      } on FirebaseAuthException catch(e){return AuthError.from(e);}
      catch (_){return const UnknownAuthError();}
    }).setLoading(false, isLoading.sink);

    //LogOut and error handling
    final logOut = BehaviorSubject<void>();

    final Stream<AuthError?> logoutError = logOut.setLoading(true, isLoading.sink).asyncMap<AuthError?>((_) async{
      try{
        await FirebaseAuth.instance.signOut();
        return null;
      } on FirebaseAuthException catch(e){return AuthError.from(e);}
      catch (_){return const UnknownAuthError();}
    }).setLoading(false, isLoading.sink);

    final Stream<AuthError?> authError = Rx.merge([loginError, registerError, logoutError]);

    return AuthBloc._(
      authError: authError, authStatus: authStatus, isLoading: isLoading,
      loginCommand: login, registerCommand: register, logoutCommand: logOut, userId: userId
    );
  }
}