import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:untitled/chatscreen.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  late String email,password;
  final _auth=FirebaseAuth.instance;
  bool showSpinner=false;

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: MaterialApp(
       debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: const Color(0x322B49FF),
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Image(
                    image: AssetImage('images/logo.png',), width: 35, height: 35,),
                  SizedBox(width: 10),
                  Text('FlashChat', style: TextStyle(color: Colors.amberAccent)),
                  SizedBox(width: 10),
                  Image(
                    image: AssetImage('images/logo.png',), width: 35, height: 35,),
                ],
              ),
              backgroundColor: const Color(0x322B49FF),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Hero(
                      tag: 'logo',
                      child: Container(
                        height: 150,
                        margin: const EdgeInsets.all(20),
                        child: const Image(image: AssetImage('images/logo.png')),
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  onChanged: (value){
                    email=value;
                  },
                  textAlign: TextAlign.center,
                  style:const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Colors.green),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Colors.green),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    constraints: const BoxConstraints(maxWidth: 350),
                    hintText: 'Enter your Email',
                    hintStyle: const TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (value){
                    password=value;
                  },
                  obscureText: true,
                  style:const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Colors.green),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Colors.green),
                        borderRadius: BorderRadius.circular(30)
                    ),
                    constraints: const BoxConstraints(maxWidth: 350),
                    hintText: 'Enter your Password',
                    hintStyle: const TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () async{
                      setState(() {
                        showSpinner=true;
                      });
                      try{
                        final newUser=await _auth.signInWithEmailAndPassword(email: email, password: password);
                        if(newUser!=null){
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>const ChatScreen()));
                        }
                        setState(() {
                          showSpinner=false;
                        });
                      }
                      catch(e){
                        print(e);
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all(Colors.green),
                      fixedSize: MaterialStateProperty.all(const Size(200, 60)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
                    ),
                    child: const Text('Login',style: TextStyle(color: Colors.white,fontSize: 30)
                    )
                ),
                const Expanded(
                  child: SizedBox(
                    height: 120,
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
}