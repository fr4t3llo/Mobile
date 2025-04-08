import 'dart:ffi';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Diarypage extends StatefulWidget {
  const Diarypage({super.key});

  @override
  State<Diarypage> createState() => _DiarypageState();
}

class _DiarypageState extends State<Diarypage> {
  var parser = EmojiParser();
  // var coffee = Emoji('coffee', '☕');
  // var heart = Emoji('heart', '❤️');
  final titleContorller = TextEditingController();
  final emailController = TextEditingController();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: [
            FaIcon(
              FontAwesomeIcons.rightFromBracket,
              color: Colors.white,
              size: 20,
            ),
          ],
          backgroundColor: Colors.transparent,
          title: Text(
            'your last diary entries',
            style: TextStyle(color: Colors.white, fontFamily: 'my_2'),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top,
          ),

          // constraints: BoxConstraints.expand(), // Make it fill the screen
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(radius: 60),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Saifeddine kasmi',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'my_2',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  height: 400, // Adjust to fit your UI
                  child: ListView.builder(
                    itemCount: 6, // 5 outer ListViews (inside Cards)
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              color: Colors.amber,
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              color: Colors.green,
                            ),
                            Text("diary title"),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
