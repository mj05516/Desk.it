import 'package:flutter/material.dart';
import 'package:taskit/screens/todo_list_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskit/components/input_field.dart';
import 'package:taskit/components/rounded_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';



class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  late String email, pass;
  final _auth = FirebaseAuth.instance;
  bool _loading = false;
  late AnimationController controller;
  late Animation animation;

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
    animation = ColorTween(begin: Colors.white, end: Colors.blueGrey)
        .animate(controller);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: "logo",
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              InputField(
                icon: Icon(Icons.email),
                keyboard: TextInputType.emailAddress,
                msg: "Enter you email",
                func: (value) {
                  email = value;
                }, pass: false,
              ),
              SizedBox(
                height: 8.0,
              ),
              InputField(
                icon: Icon(Icons.password),
                pass: true,
                msg: "Enter your password",
                func: (value) {
                  pass = value;
                }, keyboard: TextInputType.visiblePassword,
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                msg: "Register",
                color: Colors.blueAccent,
                func: () async {
                  setState(() {
                    _loading = true;
                  });
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: pass);

                    if (newUser != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoListScreen(),
                        ),
                      );
                    }
                    setState(() {
                      _loading = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
