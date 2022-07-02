import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logger = Logger();
final ImagePicker _picker = ImagePicker();

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
  XFile? _formImage;

  final newTagField = TextEditingController();

  void handleSubmit() async{
    logger.d("Sending request to POST /api/animal");

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.post(
      Uri.parse("http://127.0.0.1:4000/api/animal"),
      headers: {
        "Content-type": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "name": _formName,
        "description": _formDescription,
        "tags": _formTags
      })
    );

    if (response.statusCode == 200){
      logger.d("Received success response from POST /api/animal");

      final res = json.decode(response.body);
      final animalId = res["id"];

      if (_formImage!=null){
        var photoBytes = await _formImage?.readAsBytes();

        var uploadRequest = http.MultipartRequest("POST",
            Uri.parse("http://127.0.0.1:4000/api/uploadPhoto")
        );
        uploadRequest.headers["Authorization"] = 'Bearer $token';
        uploadRequest.fields["id"] = animalId;

        uploadRequest.files.add(
            http.MultipartFile.fromBytes("photo", photoBytes!)
        );
        logger.d("Sending upload photo request to POST /api/uploadPhoto");
        var uploadResponse = await uploadRequest.send();

        if (uploadResponse.statusCode==201){
          logger.d("Received success response from POST /api/uploadPhoto");
          Navigator.pop(context);
        }else{
          logger.d("Error response: "+ uploadResponse.statusCode.toString());
          Navigator.pop(context);
        }
      }else{
        Navigator.pop(context);
      }
    }else{
      logger.d("Error response: "+ response.statusCode.toString());
    }
  }

  void handleSelectPhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _formImage = image;
    });
    logger.d("Select an image");
  }

  void handleTakePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _formImage = image;
    });
    logger.d("Take an image");
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
                onPressed: handleSubmit,
                child: const Text("Submit")
            )
          ]
      ),
    );
  }
}
