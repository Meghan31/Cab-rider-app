import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taxirider/main.dart';
import 'package:taxirider/screens/login_screen.dart';
import 'package:taxirider/screens/main_screen.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);
  static const routeName = '/signup';
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController numberTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

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
              // const Center(
              //   child: Image(
              //     image: AssetImage('assets/images/mylogo.jpeg'),
              //     width: 300,
              //     height: 200,
              //     alignment: Alignment.center,
              //   ),
              // ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Sign-Up  as  a  Rider',
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
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Name',
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
                    TextField(
                      controller: numberTextEditingController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Mobile-number',
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
                        if (nameTextEditingController.text.length < 3) {
                          displayToastMessage(
                              'Name must be atleast 3 characters.', context);
                        } else if (!emailTextEditingController.text
                            .contains('@')) {
                          displayToastMessage(
                              'Email address not Valid.', context);
                        } else if (numberTextEditingController.text.length !=
                            10) {
                          displayToastMessage(
                              'Enter a valid Mobile number', context);
                        } else if (passwordTextEditingController.text.length <
                            6) {
                          displayToastMessage(
                              'Password must be atleast 6 characters and should contain @',
                              context);
                        } else {
                          registerNewUser(context);
                        }
                      },
                      color: Colors.indigo[300],
                      textColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          24,
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: 100,
                        child: Center(
                          widthFactor: 50,
                          child: Text(
                            'Create one :)',
                            style: TextStyle(
                              fontFamily: 'Brand-Bold',
                              fontSize: 15,
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
                    child: Text(
                      'Already have an Account? Log-in here!!',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    textColor: Colors.grey,
                    onPressed: () {
                      // print('signup');
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName, (routeName) => false);
                    },
                  ),
                  // SizedBox(
                  //   width: 35,
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// Starting from Version firebase_auth 0.18.0:
// In the newest version of firebase_auth,
//the class "FirebaseUser" was changed to "User",
//the class "AuthResult" was changed to "UserCredential"

  Future<void> registerNewUser(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    )
            .catchError((errMsg) {
      displayToastMessage("Error: $errMsg", context);
    }))
        .user;
    if (firebaseUser != null) //user created
    {
      Map userDataMap = {
        'name': nameTextEditingController.text.trim(),
        'email': emailTextEditingController.text.trim(),
        'number': numberTextEditingController.text.trim(),
        // 'password': passwordTextEditingController,
      };
      userRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage('Congo!!!, your account has been created', context);

      Navigator.of(context)
          .pushNamedAndRemoveUntil(MainScreen.routeName, (route) => false);
    } else {
      //error occured-display error msg
      displayToastMessage('New user account has not been created', context);
    }
  }
}

displayToastMessage(String message, BuildContext context) {
  Fluttertoast.showToast(msg: message);
}
