import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:taskit/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.network(
          'https://cdn4.iconfinder.com/data/icons/logos-brands-5/24/flutter-512.png'),
      title: Text(
        "Task.It :\n Not Just another TodoApp",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          color: Colors.white,
          
        ),
      ),
      backgroundColor: Colors.deepPurple,
      showLoader: true,
      loadingText: Text("Loading...", style: TextStyle(color: Colors.white),),
      navigator: RegistrationScreen(),
      durationInSeconds: 5,
    );
  }
}