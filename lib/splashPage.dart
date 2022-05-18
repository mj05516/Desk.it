import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:taskit/screens/registration_screen.dart';
import 'package:taskit/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:taskit/components/rounded_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController con;
  late Animation animation, animation2;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.deepPurple)
        .animate(controller);

    animation2 = CurvedAnimation(parent: controller, curve: Curves.easeInQuad);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "logo",
                child: Container(
                  child: Image.network(
                      'https://cdn4.iconfinder.com/data/icons/logos-brands-5/24/flutter-512.png'),
                  height: 80.0 * animation2.value,
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Desk.It : Another TodoApp',
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w900,
                    ),
                    speed: Duration(milliseconds: 100),
                  ),
                ],
              ),
              SizedBox(
                height: 48.0,
              ),
              RoundedButton(
                msg: 'Log In',
                color: Colors.lightBlueAccent,
                func: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
              RoundedButton(
                msg: 'Register',
                color: Colors.blueAccent,
                func: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegistrationScreen();
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    // return EasySplashScreen(
    // logo: Image.network(
    //     'https://cdn4.iconfinder.com/data/icons/logos-brands-5/24/flutter-512.png'),
    //   title: Text(
    //     "Task.It :\n Not Just another TodoApp",
    //     textAlign: TextAlign.center,
    //     style: TextStyle(
    //       fontSize: 24,
    //       fontWeight: FontWeight.bold,
    //       fontFamily: 'Poppins',
    //       color: Colors.white,

    //     ),
    //   ),
    //   backgroundColor: Colors.deepPurple,
    //   showLoader: true,
    //   loadingText: Text("Loading...", style: TextStyle(color: Colors.white),),
    //   navigator: LoginScreen(),
    //   durationInSeconds: 5,
    // );
  }
}
