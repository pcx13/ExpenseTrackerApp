import 'package:expense_tracker/api/firebase_api.dart';
import 'package:expense_tracker/model/chat_user.dart';
import 'package:expense_tracker/screen/account_screen.dart';
import 'package:expense_tracker/screen/home_screen.dart';
import 'package:expense_tracker/utils/styles.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return NavigationDrawer(
      backgroundColor: Styles.bodyColor,
      children: [
        drawerHeader(mq, FirebaseApi.user),
        drawerItem(mq, 'assets/ic_homepage.png', 'Home', () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }),
        drawerItem(mq, 'assets/ic_graph.png', 'Statistics', () {}),
        drawerItem(mq, 'assets/ic_budget.png', 'Budgets', () {}),
        drawerItem(mq, 'assets/ic_accounts.png', 'Accounts', () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AccountsScreen()));
        }),
        drawerItem(mq, 'assets/ic_categories.png', 'Categories', () {}),
        drawerItem(mq, 'assets/ic_settings.png', 'Settings', () {}),
        drawerItem(mq, 'assets/ic_logout.png', 'Log out', () async {
          await FirebaseApi.signOut();
        }),
      ],
    );
  }

  Widget drawerItem(
    Size mq,
    String image,
    String name,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Image.asset(
        image,
        width: mq.height * 0.04,
        height: mq.height * 0.04,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: mq.width * 0.055,
          color: Styles.textColor,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget drawerHeader(Size mq, ChatUser? user) {
    return ListTile(
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            shape: const StadiumBorder(),
            clipBehavior: Clip.hardEdge,
            child: Image.network(
              user != null ? user.avatar : '',
              fit: BoxFit.cover,
              width: mq.height * 0.07,
              height: mq.height * 0.07,
              loadingBuilder: (
                BuildContext context,
                Widget child,
                ImageChunkEvent? loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }
                return SizedBox(
                  width: mq.width * 0.07,
                  height: mq.width * 0.07,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Styles.primaryColor,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              errorBuilder: (
                BuildContext context,
                Object exception,
                StackTrace? stackTrace,
              ) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      title: Text(
        user != null ? user.name : '',
        style: TextStyle(
          fontSize: mq.width * 0.06,
          color: Styles.textColor,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: mq.height * 0.04,
        horizontal: mq.height * 0.023,
      ),
      tileColor: Styles.appBarColor,
      onTap: () {},
    );
  }
}
