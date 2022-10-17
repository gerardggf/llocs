import 'package:flutter/material.dart';
import 'package:llocz/screens/signin.dart';
import 'package:llocz/screens/signup.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(onClickedSignUp: toggle)
      : RegisterWidget(onClickedSignUp: toggle);

  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
