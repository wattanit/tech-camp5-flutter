import 'package:flutter/material.dart';

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
                onPressed: (){},
                child: const Text("Create Account")
            )
          ],
        )
    );
  }
}
