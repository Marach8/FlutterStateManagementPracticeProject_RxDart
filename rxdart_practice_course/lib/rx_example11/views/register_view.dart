import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart_practice_course/rx_example11/extensions/extensions.dart';
import 'package:rxdart_practice_course/rx_example11/extensions/typedefs.dart';

class RegisterView extends HookWidget {
  final RegisterFunction register; final VoidCallback gotoLoginView;
  const RegisterView({required this.register, required this.gotoLoginView, super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: 'emma@gmail.com'.isInDebugMode);
    final passwordController = useTextEditingController(text: 'emmanuel'.isInDebugMode);
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller : emailController,
              decoration: const InputDecoration(hintText: 'Enter your email...'),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller : passwordController,
              decoration: const InputDecoration(hintText: 'Enter your password...'),
              keyboardType: TextInputType.visiblePassword, obscureText: true,
              obscuringCharacter: '*', keyboardAppearance: Brightness.dark,
            ),
            TextButton(
              onPressed: () => register(emailController.text, passwordController.text,),
              child: const Text('Register')
            ),
            TextButton(
              onPressed: gotoLoginView,
              child: const Text('Already registered? Login here')
            )
          ]
        ),
      )
    );
  }
}