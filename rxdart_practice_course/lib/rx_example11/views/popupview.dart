import 'package:flutter/material.dart';
import 'package:rxdart_practice_course/rx_example11/dialogs/error_dialogs.dart';
import 'package:rxdart_practice_course/rx_example11/extensions/typedefs.dart';

enum MenuAction {logout, deleteAccount}

class PopUpMenuView extends StatelessWidget {
  final LogoutCallback logout; 
  final DeleteAccountCallback deleteAccount;
  const PopUpMenuView({required this.logout, required this.deleteAccount, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async{
        switch(value){          
          case MenuAction.logout:
            final shouldLogout = await showLogOutDialog(context: context);
            if (shouldLogout){logout();} break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context: context);
            if (shouldDeleteAccount){deleteAccount();} break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: MenuAction.logout, child: Text('Logout'),),
        const PopupMenuItem(value: MenuAction.deleteAccount, child: Text('Delete Account'),)
      ]
    );
  }
}