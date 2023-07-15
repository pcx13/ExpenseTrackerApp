import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/api/firebase_api.dart';
import 'package:expense_tracker/model/chat_user.dart';
import 'package:expense_tracker/utils/styles.dart';
import 'package:expense_tracker/widgets/navigation_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final id = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getMyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bodyColor,
      appBar: AppBar(
        backgroundColor: Styles.appBarColor,
        title: const Text('Home'),
      ),
      drawer: const NavigationDrawerWidget(),
      body: const SafeArea(
        child: Center(
          child: Text(''),
        ),
      ),
    );
  }

  Future getMyInfo() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(id)
        .get()
        .then((value) {
      setState(() {
        FirebaseApi.user = ChatUser.fromJson(value.data() as Map<String, dynamic>);
      });
    });
  }
}
