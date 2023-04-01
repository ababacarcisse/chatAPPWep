import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/service.dart/Auth/AuthService.dart';
import '../../../helper.dart/function.dart';
import '../../../message/DiscussionPage.dart';
import '../authPage.dart/login.dart';
import '../profil/Profile.dart';
import 'groupsHomePage.dart';

class BottomnavigationHomePage extends StatefulWidget {
  final String userId;

  const BottomnavigationHomePage({super.key, required this.userId});

  @override
  _BottomnavigationHomePageState createState() =>
      _BottomnavigationHomePageState();
}

class _BottomnavigationHomePageState extends State<BottomnavigationHomePage> {
  // Nous définissons l'index actuel de la page à 0 (la première page)
  int _currentIndex = 0;
  AuthService authService = AuthService();
  // Nous créons une liste des pages que nous souhaitons afficher dans notre BottomNavigationBar

  @override
  Widget build(BuildContext context) {
    String name = '';
    String email = '';
    gettingUserData() async {
      await HelperFunFunction.getUserEmailFromSF().then((value) {
        setState(() {
          email = value!;
        });
      });
      await HelperFunFunction.getUserNameFromSF().then((val) {
        setState(() {
          name = val!;
        });
      });
    }

    final List<Widget> _pages = [
      groupsHomePage(),
      DIscussionPage(
        userId: FirebaseAuth.instance.currentUser!.uid,
      ),
      ProfilePage(
        email: email,
        name: name,
      ),
    ];
    @override
    void initState() {
      super.initState();
      gettingUserData();
    }

    // string manipulation

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.logOutFunction();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.groups),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            label: 'Chats ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_3_outlined),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
