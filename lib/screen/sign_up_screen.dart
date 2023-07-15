import 'package:email_validator/email_validator.dart';
import 'package:expense_tracker/api/firebase_api.dart';
import 'package:expense_tracker/utils/styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const SignUpScreen({super.key, required this.onClickedSignUp});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final textFieldFocusNode = FocusNode();
  final confPassFocusNode = FocusNode();
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
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(mq.width * 0.042),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                cursorColor: Styles.textColor,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) {
                  return email != null && !EmailValidator.validate(email)
                      ? 'Enter a valid email'
                      : null;
                },
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
              TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscured,
                focusNode: textFieldFocusNode,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(confPassFocusNode);
                },
                cursorColor: Styles.textColor,
                textInputAction: TextInputAction.next,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) {
                  return password != null && password.length < 6
                      ? 'Enter min. 6 characters'
                      : null;
                },
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
              SizedBox(height: mq.width * 0.042),
              TextFormField(
                controller: confirmPassController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscured,
                cursorColor: Styles.textColor,
                textInputAction: TextInputAction.done,
                focusNode: confPassFocusNode,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (confirmPass) {
                  return confirmPass != passwordController.text
                      ? 'Wrong password'
                      : null;
                },
                style: TextStyle(color: Styles.textColor),
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  hintStyle: TextStyle(color: Styles.hintColor),
                  filled: true,
                  fillColor: Styles.fillColor,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(mq.width * 0.042),
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
                  await FirebaseApi.signUp(
                    formKey,
                    context,
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                },
                child: Text(
                  'Sign Up',
                  style: TextStyle(fontSize: mq.width * 0.055),
                ),
              ),
              SizedBox(height: mq.width * 0.055),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: Styles.textColor,
                    fontSize: mq.width * 0.045,
                  ),
                  text: 'Already have an account?  ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: 'Sign In',
                      style: TextStyle(color: Styles.richTextColor),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
