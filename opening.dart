import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register_phone.dart';

void main() async {
  try{
    WidgetsFlutterBinding.ensureInitialized();
    if(kIsWeb){
      await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: "AIzaSyCHxCG338aF6G9zmiNok6xjuPjPYd27CmI",
              authDomain: "smitube.firebaseapp.com",
              projectId: "smitube",
              storageBucket: "smitube.appspot.com",
              messagingSenderId: "225067493304",
              appId: "1:225067493304:web:56b3ca519424282542514d",
              measurementId: "G-3VM25PRYKP")
      );
    }
    else{
      await Firebase.initializeApp();
    }
  }
  finally {
    runApp(const MyApp2());
  }
}

class MyApp2 extends StatefulWidget {
  const MyApp2({super.key});

  @override
  State<MyApp2> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OpeningPage(),
    );
  }
}

class OpeningPage extends StatelessWidget {
  const OpeningPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xffEBF2FA),
        title: Image.asset('image/LogoBG.png'),
        centerTitle: true,
        toolbarHeight: 100,
      ),
      body: Center(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xffEBF2FA),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset('image/VideoGuyBG.png'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Image.asset('image/MobileGuyBG.png'),
                      ),
                    ),
                  ),
                  const Text(
                      'WELCOME TO SMITUBE',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                      )
                  ),
                  const SizedBox(height: 15),
                  const Text(
                      'YOUR ONE STOP DESTINATION TO WATCH QUALITY VIDEOS',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Quicksand',
                      )
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff4D5359),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                            return RegisterPage();
                          }));
                        },
                        child: const Text(
                            "REGISTER",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'JacquesFrancois',
                        )
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xff4D5359),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) {
                            return LoginPage();
                          }));
                        },
                        child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'JacquesFrancois',
                        )
                        )
                    ),
                  ),
                ],
              )
          )
      ),
    );
  }
}