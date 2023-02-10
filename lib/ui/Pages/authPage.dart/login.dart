import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mychat_app/data/models/database_service.dart';
import 'package:mychat_app/data/service.dart/Auth/AuthService.dart';
import 'package:mychat_app/ui/Pages/authPage.dart/registerPage.dart';
import 'package:mychat_app/ui/Pages/home/homePage.dart';

import '../../../functions/MyFunction.dart';
import '../../../helper.dart/function.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  late String password;
  bool _isLoading = false;
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : Center(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            'Partager Vos expériences ',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            'Connexion ',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a Email';
                              }
                              return null;
                            },
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

                                    // Perform login with _username and _password
                                    var success = await authService
                                        .loginEmailAndPassword(email, password);
                                    if (success) {
                                      // Access Firestore
                                      QuerySnapshot snapshot =
                                          await DatabaseService(
                                                  uid: FirebaseAuth.instance
                                                      .currentUser!.uid)
                                              .gettingUserData(email);
                                      await HelperFunFunction
                                          .saveUserLoggedInStatus(true);
                                      await HelperFunFunction.saveUserEmailSF(
                                          email);
                                      await HelperFunFunction.saveUserNameSF(
                                          snapshot.docs[0]["name"]);

                                      navigate(context, const HomePage());
                                    } else {
                                      setState(() {
                                        showSnackbar(
                                            context, Colors.red, success);
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                },
                                child: const Text("Connexion")),
                          ),
                          Center(
                            child: Row(
                              children: [
                                const Text("Si vous n'avez pas de compte"),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPage()));
                                    },
                                    child: const Text("S'inscrire ")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
