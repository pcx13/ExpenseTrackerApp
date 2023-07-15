import 'package:expense_tracker/api/firebase_api.dart';
import 'package:expense_tracker/screen/forgot_password_screen.dart';
import 'package:expense_tracker/utils/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const SignInScreen({super.key, required this.onClickedSignUp});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return;
      textFieldFocusNode.canRequestFocus = false;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Styles.bodyColor,
      appBar: AppBar(
        backgroundColor: Styles.appBarColor,
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(mq.width * 0.042),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Styles.textColor),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Styles.hintColor),
                filled: true,
                fillColor: Styles.fillColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(mq.width * 0.042),
                ),
              ),
            ),
            SizedBox(height: mq.width * 0.042),
            TextField(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: _obscured,
              focusNode: textFieldFocusNode,
              textInputAction: TextInputAction.done,
              style: TextStyle(color: Styles.textColor),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Styles.hintColor),
                filled: true,
                fillColor: Styles.fillColor,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(mq.width * 0.042),
                ),
                suffixIcon: IconButton(
                  onPressed: _toggleObscured,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(
                    _obscured ? Styles.eyeOnIcon : Styles.eyeOffIcon,
                    color: Styles.hintColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: mq.width * 0.055),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.maxFinite, mq.width * 0.125),
                shape: const StadiumBorder(),
              ),
              onPressed: () async {
                await FirebaseApi.signInWithEmail(
                    context,
                    emailController.text.trim(),
                    passwordController.text.trim());
              },
              child: Text(
                'Sign In',
                style: TextStyle(fontSize: mq.width * 0.055),
              ),
            ),
            SizedBox(height: mq.width * 0.055),
            GestureDetector(
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Styles.richTextColor,
                  fontSize: mq.width * 0.045,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: mq.width * 0.042),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Styles.textColor,
                  fontSize: mq.width * 0.045,
                ),
                text: 'Don\'t have an account?  ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: 'Sign up',
                    style: TextStyle(
                      color: Styles.richTextColor,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: mq.width * 0.13),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Styles.bodyColor,
                fixedSize: Size(double.maxFinite, mq.width * 0.125),
                shape: const StadiumBorder(),
              ),
              onPressed: () async {
                await FirebaseApi.signInWithGoogle(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/ic_google.png',
                    height: 30,
                    width: 30,
                  ),
                  SizedBox(width: mq.width * 0.042),
                  Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: mq.width * 0.055),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}