import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mychat_app/ui/Pages/authPage.dart/registerPage.dart';

import '../../../data/models/database_service.dart';
import '../../../data/service.dart/Auth/AuthService.dart';
import '../../../helper.dart/function.dart';
import '../home/bottomnavigationPageHompage.dart';
import '../home/groupsHomePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool _isLoading = false;

  void navigate(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => page),
        (Route<dynamic> route) => false);
  }

  void showSnackbar(BuildContext context, Color color, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(message),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => email = value!,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    onSaved: (value) => password = value!,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            // Perform login with email and password
                            await AuthService()
                                .loginEmailAndPassword(email, password);
                            // Access Firestore
                            QuerySnapshot snapshot = await DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .gettingUserData(email);
                            if (snapshot.docs.isNotEmpty) {
                              await HelperFunFunction.saveUserLoggedInStatus(
                                  true);
                              await HelperFunFunction.saveUserEmailSF(email);
                              await HelperFunFunction.saveUserNameSF(
                                  snapshot.docs[0]["name"]);

                              navigate(context, BottomnavigationHomePage(userId: FirebaseAuth.instance.currentUser!.uid,));
                            } else {
                              setState(() {
                                showSnackbar(
                                    context,
                                    Color.fromARGB(255, 180, 134, 131),
                                    "User data not found");
                                _isLoading = false;
                              });
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              showSnackbar(context, Colors.red, e.message!);
                              _isLoading = false;
                            });
                          } catch (e) {
                            setState(() {
                              showSnackbar(context, Colors.red, e.toString());
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      child: Text("connexion"),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text("Inscription"),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
