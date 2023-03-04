import 'package:chat_app/Screens/chat_screen.dart';
import 'package:chat_app/Screens/login_screen.dart';
import 'package:chat_app/Screens/registration_screen.dart';
import 'package:chat_app/Screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


late bool islogin ;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
  if (user == null){
    islogin = false ;
  }
  else{
    islogin = true;
  }
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        debugShowCheckedModeBanner: false,
        home :  islogin  == false ? WelcomeScreen() : ChatScreen(),
      routes : {
        WelcomeScreen.id : (context) => WelcomeScreen (),
        ChatScreen.id : (context) => ChatScreen(),
        LoginScreen.id : (context) => LoginScreen(),
         RegistrationScreen.id : (context) => RegistrationScreen(),
      }
      );



  }
}
