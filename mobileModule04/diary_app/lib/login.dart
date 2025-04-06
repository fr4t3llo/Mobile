import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(
            blue: 0.9,
          ), // mazal khasni n9ad opacity
          image: DecorationImage(
            image: AssetImage('assets/images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [
              Text(
                'Welcome to your diary',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'my_2',
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 40 / 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'login',
                        style: TextStyle(
                          color: Colors.orange,
                          fontFamily: 'my',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Icon(Icons.login, size: 26, color: Colors.orange),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
