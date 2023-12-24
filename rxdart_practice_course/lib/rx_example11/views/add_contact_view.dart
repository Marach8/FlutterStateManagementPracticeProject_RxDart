import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart_practice_course/rx_example11/extensions/extensions.dart';
import 'package:rxdart_practice_course/rx_example11/extensions/typedefs.dart';

class NewContactView extends HookWidget {
  final CreateContactCallback createContactCallback;
  final GoBackCallback goBackCallback;
  const NewContactView({required this.createContactCallback, required this.goBackCallback, super.key});

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController(text: 'Emmanuel'.isInDebugMode);
    final lastNameController = useTextEditingController(text: 'Nnanna'.isInDebugMode);
    final phoneController = useTextEditingController(text: '08022935013'.isInDebugMode, );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add your contact'), centerTitle: true, 
        leading: IconButton(onPressed: goBackCallback, icon: const Icon(Icons.close))
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller : firstNameController,
              decoration: const InputDecoration(hintText: 'FirstName...'),
              keyboardType: TextInputType.name,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller : lastNameController,
              decoration: const InputDecoration(hintText: 'LastName...'),
              keyboardType: TextInputType.name,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller : phoneController,
              decoration: const InputDecoration(hintText: 'Phone...'),
              keyboardType: TextInputType.phone,
              keyboardAppearance: Brightness.dark,
            ),
            TextButton(
              onPressed: () {
                createContactCallback(
                  firstNameController.text, lastNameController.text, phoneController.text
                );
                goBackCallback();
              },
              child: const Text('Save Contact')
            )
          ]
        ),
      )
    );
  }
}
