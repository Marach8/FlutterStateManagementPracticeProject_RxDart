import 'dart:ui';
import 'package:rxdart_practice_course/rx_example11/models/contact_models.dart';

typedef LogoutCallback = VoidCallback;
typedef GoBackCallback = VoidCallback;
typedef DeleteAccountCallback = VoidCallback;
typedef LoginFunction = void Function(String email, String password);
typedef RegisterFunction = void Function(String email, String password);
typedef CreateContactCallback = void Function(String firstName, String lastName, String phone);
typedef DeleteContactCallback = void Function(Contact contact);