import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

final logger = Logger();

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _formName = "";
  String _formEmail = "";
  String _formPassword = "";
  String _formContact = "";

  void handleSubmit() async{
    logger.d("Sending request to POST /api/user");
    final response = await http.post(
      Uri.parse("http://127.0.0.1:4000/api/user"),
      headers: {
        "Content-type": "application/json"
      },
      body: json.encode({
        "name": _formName,
        "email": _formEmail,
        "password": _formPassword,
        "contact": _formContact
      })
    );

    if (response.statusCode == 200) {
      logger.d("Received success response from POST /api/user");
      Navigator.pushNamed(context, "/");
    }else{
      throw Exception('Error response: '+ response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Register new account"),
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Center(
              child: TextField(
                onChanged: (value){
                  setState(() {
                    _formName = value;
                  });
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name"
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                  setState(() {
                    _formPassword = value;
                  });
                },
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password"
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextField(
                onChanged: (value){
                  setState(() {
                    _formContact = value;
                  });
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Contact info"
                ),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: handleSubmit,
                child: const Text("Create Account")
            )
          ],
        )
    );
  }
}
