import 'package:email_validator/email_validator.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/utils/styles.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Styles.bodyColor,
      appBar: AppBar(
        backgroundColor: Styles.appBarColor,
        title: const Text('Reset Password'),
      ),
      body: Padding(
        padding: EdgeInsets.all(mq.width * 0.042),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Receive an email to reset your password.',
                style: TextStyle(
                  fontSize: mq.width * 0.055,
                  color: Styles.textColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: mq.height * 0.0256),
              TextFormField(
                controller: emailController,
                cursorColor: Styles.textColor,
                textInputAction: TextInputAction.done,
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
              SizedBox(height: mq.height * 0.0256),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(double.maxFinite, mq.height * 0.057),
                  shape: const StadiumBorder(),
                ),
                onPressed: resetPassword,
                child: Text(
                  'Reset Password',
                  style: TextStyle(fontSize: mq.width * 0.055),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar(
        'Password Reset Email Sent',
        Styles.snackBarColor,
      );
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (_) {
      Utils.showSnackBar(
        'Please enter the correct email.',
        Styles.snackBarColor,
      );
      navigatorKey.currentState!.pop();
    }
  }
}
