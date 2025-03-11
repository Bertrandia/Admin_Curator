import 'package:admin_curator/Presentation/Auth/Login/web_login.dart';
import 'package:flutter/material.dart';

class AuthSignIn extends StatefulWidget {
  const AuthSignIn({super.key});

  @override
  State<AuthSignIn> createState() => _AuthSignInState();
}

class _AuthSignInState extends State<AuthSignIn> {
  @override
  Widget build(BuildContext context) {
    return WebLoginScreen();
  }
}
