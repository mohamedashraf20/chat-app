import 'package:chat_app/Screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
User? signedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await auth.currentUser!;
      if (user != null) {
        signedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  final messageTextcontroller = TextEditingController();
  late String messages;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        centerTitle: true,
        backgroundColor: const Color(0xff2a9d8f),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStreemBulider(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: TextFormField(
                    cursorColor: Colors.greenAccent,
                    controller: TextEditingController(),
                    onChanged: (value) {
                      messages = value;
                    },
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
                      hintText: 'Type your message here...',
                      border: InputBorder.none,
                    ),
                  )),
                  IconButton(
                    iconSize: 35,
                    color: Color(0xff2a9d8f),
                    icon: Icon(Icons.send_rounded),
                    onPressed: () {
                      messageTextcontroller.clear();
                      firestore.collection('messages').add(
                          {'Text': messages,
                            'sender': signedInUser?.email,
                            'time' : FieldValue.serverTimestamp(),
                          },

                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStreemBulider extends StatelessWidget {
  const MessageStreemBulider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('messages').orderBy('time').snapshots(),
        builder: (context, snapshot) {
          late List<MessageLine> messageWidgets = [];
          if (!snapshot.hasData) {}
          final messages = snapshot.data!.docs.reversed;
          for (var message in messages) {
            final messageText = message.get('Text');
            final messageSender = message.get('sender');
            final currentuser = signedInUser?.email;
            final messageWidget = MessageLine(
              sender: messageSender,
              text: messageText,
              isMe: currentuser == messageSender,
            );
            messageWidgets.add(messageWidget);
          }

          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              children: messageWidgets,
            ),
          );
        });
  }
}

class MessageLine extends StatelessWidget {
  const MessageLine({this.text, this.sender, required this.isMe});

  final String? text;
  final String? sender;
  final bool isMe;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                '$sender',
                style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
              Material(
                  elevation: 5,
                  borderRadius: isMe
                      ? BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))
                      : BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                  color: isMe ? Colors.greenAccent : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: (Text(
                      '$text ',
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    )),
                  )),
            ]));
  }
}
