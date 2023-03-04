import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_app/Screens/chat_screen.dart';
import 'package:chat_app/Screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_Screen";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  var password, email;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  signIn() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.pushNamed(context, RegistrationScreen.id);
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: Text("No user found for that email"))
              .show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
                  context: context,
                  title: "Error",
                  body: Text("Wrong password provided for that user"))
              .show();
        }
      }
    } else {
      print("Not Vaild");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2a9d8f),
      body: ListView(children: [
        SizedBox(
          height: 100,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "Logo",
              child: Container(
                  height: 200.0,
                  child: Image.asset(
                    "images/logo.png",
                  )),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Form(
                  key: formstate,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          onSaved: (val) {
                            email = val;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                              hintText: "Email",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(width: 1))),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          onSaved: (val) {
                            password = val;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.black,
                              ),
                              hintText: "password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(width: 1))),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text("if you havan't accout "),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RegistrationScreen.id);
                                },
                                child: Text(
                                  "Click Here",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.0),
                              elevation: 5.0,
                              child: MaterialButton(
                                onPressed: () async {
                                  var user = await signIn();
                                  if (user != null) {
                                    Navigator.pushNamed(context, ChatScreen.id);
                                  } else {
                                    AwesomeDialog(
                                            context: context,
                                            title: "Error",
                                            body: Text("can not Login"))
                                        .show();
                                  }
                                },
                                minWidth: 200.0,
                                height: 42.0,
                                child: Text("LOGIN",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black)),
                              )))
                    ],
                  )),
            )
          ],
        ),
      ]),
    );
  }
}
