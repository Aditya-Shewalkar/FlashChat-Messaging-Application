import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final messageTextController=TextEditingController();
  final _auth=FirebaseAuth.instance;
  final _firestore=FirebaseFirestore.instance;
  User? loggedInUser;
  String? email,password;
  String? msgText;


  @override
  void initState() {
    super.initState();
    getCurrentUser();
    setState(() {
      email;
    });
  }

  User? user;
  void getCurrentUser()async {
    try {
      user = _auth.currentUser;
      if (user != null) {
        await user?.reload();
        loggedInUser = user;
        setState(() {
          email=loggedInUser?.email;
        });
        print(email);
      }
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0x322B49FF),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              const Image(
                image: AssetImage(
                  'images/logo.png',
                ),
                width: 35,
                height: 35,
              ),
              const SizedBox(width: 10),
              const Text('FlashChat', style: TextStyle(color: Colors.amberAccent)),
              const SizedBox(width: 10),
              const Image(
                image: AssetImage(
                  'images/logo.png',
                ),
                width: 35,
                height: 35,
              ),
              const SizedBox(
                width: 30,
              ),
              IconButton(
                  onPressed: (){
                    _auth.signOut();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.logout),
              ),
            ],
          ),
          backgroundColor: const Color(0x322B49FF),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('$email',style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.amberAccent),),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').orderBy("time",descending: false).snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasData==false){
                    return const CircularProgressIndicator(
                      backgroundColor: Colors.blueAccent,
                    );
                  }
                    final messages = snapshot.data!.docs.reversed;
                    List<Padding> messageWidgets=[];
                    for (var message in messages) {
                      final messageText = message.data() as Map<String, dynamic>;
                      bool isMe=false;
                      //print("email:$email");
                      //print("text:$messageText['sender']");
                      if(messageText['sender']==email){
                        print("here");
                        isMe=true;
                      }
                      messageWidgets.add(
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
                            children:<Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 2),
                                child: Text(messageText['sender'],style: const TextStyle(color: Colors.white70),),
                              ),
                            Material(
                              elevation: 5.0,
                              borderRadius: isMe ?const BorderRadius.only(
                                topLeft:Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              )
                                  :const BorderRadius.only(
                                topRight:Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              color: isMe?Colors.orangeAccent:Colors.greenAccent ,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                child: Text(
                                  " ${messageText['text']}",style:const TextStyle(color:Colors.black),),
                              ),
                            ),
                        ]
                      ),
                          ));
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messageWidgets,
                    ),
                  );
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: messageTextController,
                      onChanged: (value){
                        msgText=value;
                      },
                      style:const TextStyle(color: Colors.white),
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2, color: Colors.blue),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        constraints: const BoxConstraints(maxWidth: 350),
                        hintText: 'Type Message',
                        hintStyle: const TextStyle(color: Colors.white54,),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _firestore.collection('messages').add({
                          'sender':email,
                          'text':msgText,
                          'time':DateTime.now(),
                        });
                        messageTextController.clear();
                      },
                      icon: const Icon(Icons.send,color: Colors.green,size: 30,),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}
