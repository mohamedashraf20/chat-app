import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chat_app/Screens/chat_screen.dart';
import 'package:chat_app/Screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "Registration_Screen";

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  late bool ShowSniper;

  late final String username;
  late final String email;
  late final String password;

  signup() async {
    var formdata = formState.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
                  context: context,
                  title: "error",
                  body: Text("password is to weak"))
              .show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
                  context: context,
                  title: "error",
                  body: Text("The account already exists for that email"))
              .show();
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('can not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2a9d8f),
      body: ListView(
        children: [
          SizedBox(
            height: 100,
          ),
          Padding(
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
                    Form(
                      key: formState,
                      //child: Container(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextFormField(
                              onSaved: (val) {
                                username = val!;
                              },
                              validator: (val) {
                                if (val!.length > 100) {
                                  return "username can't to be larger than 100 letter";
                                }
                                if (val.length < 2) {
                                  return "username can't to be less than 2 letter";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  prefixIcon:
                                      Icon(Icons.person, color: Colors.black),
                                  hintText: "username",
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
                                email = val!;
                              },
                              validator: (val) {
                                if (val!.length > 100) {
                                  return "Email can't to be larger than 100 letter";
                                }
                                if (val.length < 2) {
                                  return "Email can't to be less than 2 letter";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon:
                                      Icon(Icons.email, color: Colors.black),
                                  hintText: "email",
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
                                password = val!;
                              },
                              validator: (val) {
                                if (val!.length > 100) {
                                  return "Password can't to be larger than 100 letter";
                                }
                                if (val.length < 4) {
                                  return "Password can't to be less than 4 letter";
                                }
                                return null;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                      Icons.remove_red_eye_outlined,
                                      color: Colors.black),
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
                                  Text("if you have Account "),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, LoginScreen.id);
                                    },
                                    child: Text(
                                      "Click Here",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  )
                                ],
                              )),
                          Container(
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30.0),
                                    elevation: 5.0,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        UserCredential response =
                                            await signup();
                                        if (response != null) {
                                          await FirebaseFirestore.instance
                                              .collection("users")
                                              .add({
                                            "username": username,
                                            "email": email
                                          });
                                          Navigator.pushNamed(
                                              context, ChatScreen.id);
                                        } else {
                                          print("Sign Up Faild");
                                        }
                                      },
                                      minWidth: 200.0,
                                      height: 42.0,
                                      child: Text("Sign Up",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                    ))),
                          ),
                        ],
                      ),
                    )
                  ]))
        ],
      ),
    );
  }
}
