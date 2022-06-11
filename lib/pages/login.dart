import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _formEmail = "";
  String _formPassword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Image(
            image: AssetImage('welcome.jpg'),
          ),
          const Text(
            "Dog Cat Matcher Mobile",
            style: TextStyle(
              fontSize: 26,
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: TextField(
              onChanged: (value){
                setState(() {
                  _formEmail = value;
                });
              },
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email address"
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: TextField(
              onChanged: (value){
                _formPassword = value;
              },
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password"
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: (){
                Navigator.pushNamed(context, "/main");
              },
              style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  padding: const EdgeInsets.all(16.0)
              ),
              child: const Text("Login")
          ),
          const SizedBox(height: 15),
          TextButton(
              onPressed: (){
                Navigator.pushNamed(context, "/register");
              },
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                  padding: const EdgeInsets.all(16.0)
              ),
              child: const Text("Create new account"))
        ],
      ),
    );
  }
}
