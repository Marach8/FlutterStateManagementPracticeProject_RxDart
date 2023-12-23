import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart_practice_course/rx_example11/extensions/typedefs.dart';

class PopUpMenuView extends StatelessWidget {
  final LogoutCallback logout; 
  final DeleteAccountCallback deleteAccount;
  const PopUpMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: itemBuilder)
  }
}