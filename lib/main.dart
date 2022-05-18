import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:taskit/screens/todo_list_screen.dart';
import 'package:taskit/splashPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desk.It : Not Just another TodoApp',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
      ),
      // theme: ThemeData(
      //   primarySwatch: Colors.deepPurple,
      // ),
      // home: TodoListScreen(),
      home: SplashPage(),
    );
  }
}
