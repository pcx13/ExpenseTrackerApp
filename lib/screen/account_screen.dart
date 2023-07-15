import 'package:expense_tracker/utils/styles.dart';
import 'package:expense_tracker/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bodyColor,
      appBar: AppBar(
        backgroundColor: Styles.appBarColor,
        title: const Text('Accounts'),
      ),
      drawer: const NavigationDrawerWidget(),
    );
  }
}
