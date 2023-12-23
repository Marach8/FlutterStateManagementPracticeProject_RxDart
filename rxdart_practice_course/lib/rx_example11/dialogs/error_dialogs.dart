import 'package:flutter/material.dart';
import 'package:rxdart_practice_course/rx_example11/bloc/auth_error.dart';
import 'package:rxdart_practice_course/rx_example11/dialogs/generic_dialog.dart';


Future<void> showAuthErrorDialog({required AuthError error, required BuildContext context})
  => showGenericDialog(
    context: context, title: error.title, content: error.content, options: ()=>{'Ok': false}
  );

Future<bool> showDeleteAccountDialog({required BuildContext context})
  => showGenericDialog<bool?>(
    context: context, title: 'Delete Account?', 
    content: 'Are you sure you want to delete your account?', 
    options: () => {'Cancel':false, 'Delete': true}
  ).then((value) => value ?? false);


Future<bool> showDeleteContactDialog(BuildContext context)
  => showGenericDialog<bool?>(
    context: context, title: 'Delete Contact?', 
    content: 'Are you sure you want to delete this contact?', 
    options: () => {'Cancel':false, 'Delete': true}
  ).then((value) => value ?? false);


Future<bool> showLogOutDialog({required BuildContext context})
  => showGenericDialog<bool?>(
    context: context, title: 'LogOut?', 
    content: 'Are you sure you want to Log Out?', 
    options: () => {'Cancel':false, 'Delete': true}
  ).then((value) => value ?? false);
