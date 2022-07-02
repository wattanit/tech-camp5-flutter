import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

final logger = Logger();

class AnimalSubmitPage extends StatefulWidget {
  const AnimalSubmitPage({Key? key}) : super(key: key);

  @override
  State<AnimalSubmitPage> createState() => _AnimalSubmitPageState();
}

class _AnimalSubmitPageState extends State<AnimalSubmitPage> {
  String _formName = "";
  String _formDescription = "";
  String _formNewTag = "";
  List<String> _formTags = [];

  final newTagField = TextEditingController();

  void handleSubmit() async{
    logger.d("Sending request to POST /api/animal");
    final response = await http.post(
      Uri.parse("http://127.0.0.1:4000/api/animal"),
      headers: {
        "Content-type": "application/json"
      },
      body: json.encode({
        "name": _formName,
        "description": _formDescription,
        "tags": _formTags
      })
    );

    if (response.statusCode == 200){
      logger.d("Received success response from POST /api/animal");
      Navigator.pop(context);
    }
  }

  void handleSelectPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    logger.d(image);
  }

  void handleTakePhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    logger.d(image);
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> tags = _formTags.map((tag)=>
      TextButton(
        onPressed: (){
          var oldTags = _formTags;
          oldTags.remove(tag);
          setState(() {
            _formTags = oldTags;
          });
        },
        child: Text(tag),
      )
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit an animal"),
      ),
      body: Column(
          children: <Widget>[
            const SizedBox(height: 20),
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
                    _formDescription = value;
                  });
                },
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Description",
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                      onPressed: handleSelectPhoto,
                      child: const Text("Upload photo")
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                      onPressed: handleTakePhoto,
                      child: const Text("Take photo")
                      )
                )
              ],
            ),
            const SizedBox(height: 5),
            const Text("Tags"),
            Center(
              child: TextField(
                controller: newTagField,
                onChanged: (value){
                  if (value.isEmpty){
                    setState(() {
                      _formNewTag = value;
                    });
                    return;
                  }

                  final lastChar = value.substring(value.length - 1);
                  if (lastChar==" "){
                    final tag = value.substring(0, value.length-1);
                    var oldTags = _formTags;
                    oldTags.add(tag);
                    setState(() {
                      _formNewTag = "";
                      _formTags = oldTags;
                    });
                    newTagField.text = "";
                  }else{
                    setState(() {
                      _formNewTag = value;
                    });
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Add new tag",
                  hintText: "type space to add new tag"
                ),
              ),
            ),
            Wrap(
              children: tags,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: (){},
                child: const Text("Submit")
            )
          ]
      ),
    );
  }
}
