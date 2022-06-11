import 'package:flutter/material.dart';
import 'pages/login.dart';
import 'pages/main.dart';
import 'pages/register.dart';
import 'pages/animal_view.dart';
import 'pages/animal_submit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Cat Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/",
      routes: {
        "/": (context)=>const LoginPage(),
        "/main": (context)=> const MainPage(),
        "/register": (context)=> const RegisterPage(),
        "/animal_view": (context)=> const AnimalViewPage(),
        "/animal_submit": (context)=> const AnimalSubmitPage()
      },
    );
  }
}

