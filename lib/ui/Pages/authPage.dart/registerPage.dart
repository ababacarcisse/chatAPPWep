import 'package:flutter/material.dart';
import 'package:mychat_app/data/service.dart/Auth/AuthService.dart';
import 'package:mychat_app/helper.dart/function.dart';
import 'package:mychat_app/ui/Pages/authPage.dart/login.dart';

import '../../../functions/MyFunction.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String name = '';
  late String email = '';
  String password = '';
  final String _confirmPassword = '';
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
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Inscription',
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
                                hintText: 'Votre Nom Complet',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a Votre Nom Complet';
                                }
                                return null;
                              },
                              onSaved: (value) => name = value!,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'email',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a email';
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
                                    await authService
                                        .registerEmailAndPasword(
                                            name, email, password)
                                        .then((value) async => {
                                              if (value == true)
                                                {
                                                  // gerer l'eta preference
                                                  await HelperFunFunction
                                                      .saveUserLoggedInStatus(
                                                          true),
                                                  await HelperFunFunction
                                                      .saveUserEmailSF(email),
                                                  await HelperFunFunction
                                                      .saveUserNameSF(name),
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const LoginPage())),
                                                }
                                              else
                                                {
                                                  setState(
                                                    () {
                                                      showSnackbar(context,
                                                          Colors.red, value);
                                                      _isLoading = false;
                                                    },
                                                  )
                                                }
                                            });
                                  }
                                },
                                child: const Text('Inscription'),
                              ),
                            ),
                            Row(
                              children: [
                                const Text("Vous avez un compte"),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    },
                                    child: const Text("Se connecter")),
                              ],
                            ),
                          ])),
                ),
              ),
            ),
    );
  }
}
