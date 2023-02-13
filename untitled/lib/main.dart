import 'package:flutter/material.dart';
import 'package:untitled/registration.dart';
import 'package:untitled/login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
    home:Home()
  )
  );
}


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{

  late AnimationController _controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    _controller=AnimationController(
        duration:const Duration(seconds: 1),
        vsync: this,
    );
    animation=ColorTween(begin: Colors.redAccent,end: Colors.amberAccent).animate(_controller);
    _controller.forward();
    _controller.addListener(() {
      //print(_controller.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: 'logo',
                child: Container(
                  //height: 50,
                  margin: const EdgeInsets.all(20),
                  child: Image(image: const AssetImage('images/logo.png'),opacity: _controller,),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30,0,0,0),
                child: AnimatedTextKit(
                    animatedTexts:[
                  TypewriterAnimatedText("FlashChat",textStyle:const TextStyle(fontSize: 40,color: Colors.amberAccent),speed: const Duration(milliseconds: 300))
                    ],
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 300,
              height: 50,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white30,
                  borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const Login()));
                  },
                  child: const Center(
                      child: Text('Log-in', style: TextStyle(
                          fontSize: 25, color: Colors.amberAccent)))),
            ),
            Container(
              width: 300,
              height: 50,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white30,
                  borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => const Registration()));
                  },
                  child: const Center(
                      child: Text('Register', style: TextStyle(
                          fontSize: 25, color: Colors.amberAccent)))),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

