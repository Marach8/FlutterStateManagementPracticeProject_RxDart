

import 'package:flutter/material.dart';

typedef DialogOptionsBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context, required String title, 
  required String content, required DialogOptionsBuilder<T?> options
  }){
    final optionFunc = options();
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title : Text(title),
        content: Text(content),
        actions: optionFunc.keys.map((option){
          final optionValue = optionFunc[option];
          return TextButton(
            onPressed: (){
              if(optionValue == null){Navigator.pop(context);}
              else{Navigator.of(context).pop(optionValue);}
            },
            child: Text(option)
          );
        }).toList()
      )
    );
  }