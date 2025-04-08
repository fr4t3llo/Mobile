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
          actions: [CircleAvatar(backgroundColor: Colors.white)],
          backgroundColor: Colors.transparent,
          title: Text(
            'your last diary entries',
            style: TextStyle(color: Colors.white, fontFamily: 'my_2'),
          ),
        ),
        body: Container(
          constraints: BoxConstraints.expand(), // Make it fill the screen
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView.builder(itemBuilder: itemBuilder)
        ),
      ),
    );
  }
}
