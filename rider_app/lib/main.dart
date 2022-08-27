import 'package:flutter/material.dart';
import 'package:rider_app/screens/forgot_pass.dart';
import 'package:rider_app/screens/login_screen.dart';
import 'package:rider_app/screens/main_screen.dart';
import 'package:rider_app/screens/signup_screen.dart';

void main() {
  runApp(const MyApp());
}

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
      home: const LoginScreen(),
      routes: {
        SignupScreen.routeName: (context) => const SignupScreen(),
        ForgotPassScreen.routeName: (context) => const ForgotPassScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
