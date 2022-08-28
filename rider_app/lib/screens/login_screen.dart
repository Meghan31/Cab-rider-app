// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rider_app/screens/forgot_pass_screen.dart';
import 'package:rider_app/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                    const TextField(
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
                        print('logged');
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
                      Navigator.of(context)
                          .pushNamed(ForgotPassScreen.routeName);
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
