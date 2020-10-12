import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _auth = FirebaseAuth.instance;  //_as private property
  bool showSpinner = false;
  String emailL;
  String passwordL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  emailL = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  passwordL = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton (
                title: 'Log In',
                colour: Colors.lightBlueAccent,
                onPressed: () async { //async and await used to ensure new user are successfully created before executing next task
                  try {
                    setState(() {
                      showSpinner = true;
                    });
                    final authenticateUser = await _auth.signInWithEmailAndPassword(email: emailL, password: passwordL);
                    if(authenticateUser != null) {
                      setState(() {
                        showSpinner = false;
                      });
                      showCupertinoModalPopup(
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              title: new Text("Welcome to Flash Chat!"),
                              content: new Text("You will be directed to chat screen"),
                              actions: <Widget> [
                                new FlatButton(onPressed: () {Navigator.pushNamed(context, ChatScreen.id);}, child: new Text("Let's Go!")),
                              ],
                            );
                          },
                       );
                    }
                  } catch (e) {
                    print (e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
