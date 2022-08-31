// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:taxirider/main.dart';
import 'package:taxirider/screens/forgot_pass_screen.dart';
import 'package:taxirider/screens/signup_screen.dart';
import 'package:taxirider/widgets/progressDialog.dart';

import 'main_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login';

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // child: Padding(
        //   padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            const Center(
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                width: 390,
                height: 250,
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Login  as  a  Rider',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Signatra',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: emailTextEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Brand-Regular',
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 1,
                  ),
                  TextField(
                    controller: passwordTextEditingController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Brand-Regular',
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 10,
                      ),
                    ),
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (!emailTextEditingController.text.contains('@')) {
                        displayToastMessage(
                            'Email address not Valid.', context);
                      }
                      if (passwordTextEditingController.text.isEmpty) {
                        displayToastMessage('Password is Mandatory', context);
                      } else {
                        loginAndAuthenticateUser(context);
                      }
                    },
                    color: Colors.yellow,
                    textColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        24,
                      ),
                    ),
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Center(
                        widthFactor: 50,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Brand-Bold',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  textColor: Colors.grey,
                  onPressed: () {
                    // print('forgot');
                    Navigator.of(context).pushNamed(MainScreen.routeName);
                  },
                  child: Text(
                    'forgot password',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  ' | ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                FlatButton(
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  textColor: Colors.grey,
                  onPressed: () {
                    // print('signup');
                    Navigator.of(context).pushNamed(SignupScreen.routeName);
                  },
                ),
                SizedBox(
                  width: 35,
                ),
              ],
            ),
            // Image.asset('assets/gif/login_page.gif')
          ],
        ),
        // ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginAndAuthenticateUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog();
        });
    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    )
            .catchError((errMsg) {
      Navigator.of(context).pop;
      displayToastMessage("Error: $errMsg", context);
    }))
        .user;
    if (firebaseUser != null) //user created
    {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
      displayToastMessage('your are logged in', context);
    } else {
      Navigator.of(context).pop;
      displayToastMessage('No account exist with this credentials ', context);
    }
  }
}
