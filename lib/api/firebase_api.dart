import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/main.dart';
import 'package:expense_tracker/model/chat_user.dart';
import 'package:expense_tracker/utils/styles.dart';
import 'package:expense_tracker/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseApi {
  static ChatUser? user;

  static Future signInWithEmail(
      BuildContext context, String email, String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (_) {
      Utils.showSnackBar(
        'Please enter the correct email and password.',
        Styles.snackBarColor,
      );
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  static Future signInWithGoogle(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      final user = await GoogleSignIn().signIn();
      final auth = await user!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        await createUser(user.displayName!, user.photoUrl!);
      });
    } on FirebaseAuthException catch (_) {
      Utils.showSnackBar(
        'Please enter the correct email and password.',
        Styles.snackBarColor,
      );
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  static Future signUp(
    GlobalKey<FormState> formKey,
    BuildContext context,
    String email,
    String password,
  ) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        Reference refRoot = FirebaseStorage.instance.ref().child('profiles');
        final imageUrl = await refRoot.child('profile.png').getDownloadURL();
        await createUser('Me', imageUrl);
      });
    } on FirebaseAuthException catch (e) {
      Utils.showSnackBar(
        e.message,
        Styles.snackBarColor,
      );
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  static Future signOut() async {
    FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
  }

  static Future createUser(String email, String avatar) async {
    final id = FirebaseAuth.instance.currentUser!.uid;

    final chatUser = ChatUser(
      id: id,
      name: email,
      avatar: avatar,
      pushToken: '',
    );

    final refUser = FirebaseFirestore.instance.collection('Users').doc(id);
    await refUser.set(chatUser.toJson());
  }
}
