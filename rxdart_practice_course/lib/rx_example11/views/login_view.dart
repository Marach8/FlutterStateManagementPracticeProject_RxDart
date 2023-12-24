import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart_practice_course/rx_example11/extensions/extensions.dart';
import 'package:rxdart_practice_course/rx_example11/extensions/typedefs.dart';

class LoginView extends HookWidget {
  final LoginFunction login; final VoidCallback gotoRegisterView;
  const LoginView({required this.login, required this.gotoRegisterView, super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController(text: 'emma@gmail.com'.isInDebugMode);
    final passwordController = useTextEditingController(text: 'emmanuel'.isInDebugMode);
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
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
              onPressed: () => login(emailController.text, passwordController.text,),
              child: const Text('LogIn')
            ),
            TextButton(
              onPressed: gotoRegisterView,
              child: const Text('Not registered? Register here')
            )
          ]
        ),
      )
    );
  }
}