import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:taxirider/screens/forgot_pass_screen.dart';
import 'package:taxirider/screens/login_screen.dart';
import 'package:taxirider/screens/main_screen.dart';
import 'package:taxirider/screens/signup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

DatabaseReference usersRef =
    FirebaseDatabase.instance.reference().child('users');

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Rider App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
      initialRoute: MainScreen.routeName,
      routes: {
        LoginScreen.routeName: (context) => LoginScreen(),
        SignupScreen.routeName: (context) => SignupScreen(),
        ForgotPassScreen.routeName: (context) => ForgotPassScreen(),
        MainScreen.routeName: (context) => MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
