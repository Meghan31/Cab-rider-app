import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ForgotPassScreen extends StatefulWidget {
  ForgotPassScreen({Key? key}) : super(key: key);
  static const routeName = '/forgot';

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  String? _email;

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Card(
                        color: Colors.grey[200],
                        shadowColor: Colors.black,
                        elevation: 10,
                        margin: const EdgeInsets.only(bottom: 25),
                        child: const SizedBox(
                          height: 50,
                          width: 202,
                          child: Center(
                            child: Text(
                              'Forgot password?????',
                              style: TextStyle(
                                fontSize: 30,
                                fontFamily: 'Signatra',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                          'Enter your email to receive a link to reset your password'),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        child: const Text('Reset Password'),
                        onPressed: () {
                          auth.sendPasswordResetEmail(email: _email!);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
