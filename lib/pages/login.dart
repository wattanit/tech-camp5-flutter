import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _formEmail = "";
  String _formPassword = "";

  @override
  void initState() {
    super.initState();

    checkAutoLogin();
  }

  void checkAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    logger.d("Check for existing token");
    logger.d(token);
    if (token != null){
      Navigator.pushNamedAndRemoveUntil(context, "/main", (Route<dynamic> route) => false);
    }
  }
  
  void handleLogin() async {
    logger.d("Sending request to POST /api/login");

    final response = await http.post(
      Uri.parse("http://127.0.0.1:4000/api/login"),
      headers: {
        "Content-type": "application/json"
      },
      body: json.encode({
        "email": _formEmail,
        "password": _formPassword
      })
    );

    if (response.statusCode == 200){
      logger.d("Received response from POST /api/login");

      var res = json.decode(response.body);
      logger.d(res["token"]);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", res["token"]);

      Navigator.pushNamedAndRemoveUntil(context, "/main", (Route<dynamic> route) => false);
    }else{
      throw Exception("Server error: "+response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const Image(
            image: AssetImage('assets/welcome.jpg'),
          ),
          const Text(
            "Dog Cat Matcher Mobile",
            style: TextStyle(
              fontSize: 26,
            ),
          ),
          // const SizedBox(height: 50),
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
              onPressed: handleLogin,
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
