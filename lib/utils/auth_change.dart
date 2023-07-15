import 'package:expense_tracker/screen/sign_in_screen.dart';
import 'package:expense_tracker/screen/sign_up_screen.dart';
import 'package:flutter/material.dart';

class AuthChange extends StatefulWidget {
  const AuthChange({super.key});

  @override
  State<AuthChange> createState() => _AuthChangeState();
}

class _AuthChangeState extends State<AuthChange> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return isLogin
        ? SignInScreen(onClickedSignUp: toggle)
        : SignUpScreen(onClickedSignUp: toggle);
  }

  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }
}
