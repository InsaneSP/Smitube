import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'opening.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffEBF2FA),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const OpeningPage();
              }));
            },
            child: Image.asset('image/LogoBG.png'),
          ),
          leadingWidth: 150,
        ),
        body: Center(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xffEBF2FA),
              child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                              )
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              'We’re so excited to see you again!',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Quicksand',
                              )
                          ),
                        ),
                      ),
                      const Align(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                                'Account Information',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Lato',
                                )
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: identifierController,
                          decoration: InputDecoration(
                            labelText: 'Email or Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email or phone number';
                            }
                            if (RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                              return null; // Valid email address
                            }
                            if (RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                              return null; // Valid phone number
                            }
                            return 'Please enter a valid email or phone number';
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters long';
                            }
                            return null;
                          },
                        ),
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Forgot Password?',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                                fontFamily: 'Lato',
                                color: Colors.blue,
                              )
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Use a Password Manager?',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                                fontFamily: 'Lato',
                                color: Colors.blue,
                              )
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xff000000),
                          ),
                          onPressed: () async {
                            _loginUser(context);
                          },
                          child: const Text(
                              'NEXT',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'JacquesFrancois',
                              )
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                              'Copyright © 2024 - Smitube. All Rights Reserved',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Inika',
                              )),
                        ),
                      ),
                    ],
                  ))),
        )
    );
  }

  void _loginUser(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      String identifier = identifierController.text;
      String password = passwordController.text;
      User? user = await AuthService().login(identifier, password);
      if (user != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return const MainPage();
        },
        ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login failed. Please try again.'))
        );
      }
    }
  }
}