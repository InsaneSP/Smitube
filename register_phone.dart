import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'opening.dart';
import 'register_email.dart';


class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
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
                              'Enter Phone or Email',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Lato',
                              )),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: const Color(0xffE5E4E2),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                      return RegisterPage();
                                    }));
                                  },
                                  child: const Text(
                                      'Phone',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Lato',
                                      ))),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Align(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: const Color(0xffE5E4E2),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                      return RegisterPage2();
                                    }));
                                  },
                                  child: const Text(
                                      'Email',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Lato',
                                      ))),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                              'Phone Number',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Lato',
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid Username';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid phone number';
                            }
                            if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                              return 'Phone number must be 10 digits';
                            }
                            return null;
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
                          padding: EdgeInsets.all(10.0),
                          child: Text('View Our Privacy Policy',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 17,
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
                            _registerUser(context);
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
                  )
              )
          ),
        )
    );
  }

  void _registerUser(BuildContext context) async {
    if (formKey.currentState?.validate() ?? false) {
      String username = usernameController.text;
      String identifier = phoneController.text;
      String password = passwordController.text;
      User? user = await AuthService().registerWithPhoneNumberAndPassword(identifier, password, username);
      if (user != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
          return const OpeningPage();
        }),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed. Please try again.'))
        );
      }
    }
  }
}