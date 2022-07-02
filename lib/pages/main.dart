import 'package:flutter/material.dart';
import 'animal_view.dart';
import 'animal_submit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<Animal> animals = [];

  @override
  void initState() {
    super.initState();

    // Fetch data from Server here
    fetchData();

    // Stub loads from dummy
    // DummyData dummy = DummyData();
    // setState(() {
    //   animals = dummy.animals;
    // });
  }
  
  void fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    logger.d("Fetching data from /api/animals");
    var response = await http.get(Uri.parse("http://127.0.0.1:4000/api/animals"),
        headers: {
          "Authorization": "Bearer $token",
        }
    );

    if (response.statusCode==200){
      List<dynamic> animalJsonList = json.decode(response.body);
      List<Animal> animalList = [];
      for (var i=0; i<animalJsonList.length; i++){
        var json = animalJsonList[i];
        List<dynamic> tagList = json['tags'];
        var tags = tagList.map((t)=>t.toString()).toList();
        var newAnimal = Animal(
          json["name"],
          json["description"], tags,
          json["photoUrls"]
        );
        animalList.add(newAnimal);
      }

      setState(() {
        animals = animalList;
      });
    }
  }

  void handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dog Cat Matcher"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: (){
                handleLogout();
              },
              child: const Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: AnimalGrid(animals: animals),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const AnimalSubmitPage()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AnimalGrid extends StatelessWidget {
  const AnimalGrid({
    Key? key,
    required this.animals
  }) : super(key: key);

  final List<Animal> animals;

  @override
  Widget build(BuildContext context) {

    List<AnimalCard> animalCards = animals.map((animal) =>
      AnimalCard(
        animal: animal,
      )
    ).toList();

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: const EdgeInsets.all(16.0),
      children: animalCards,
    );
  }
}

class AnimalCard extends StatelessWidget {
  const AnimalCard({
    Key? key,
    required this.animal,
  }) : super(key: key);

  final Animal animal;

  @override
  Widget build(BuildContext context) {

    // Widget photo = (animal.photoUrl != '')? Image(
    //   image: AssetImage(animal.photoUrl),
    // ): const Text("No Photo");
    Widget photo = (animal.photoUrl != '')? Image.network(
        "http://127.0.0.1:4000"+animal.photoUrl
    ): const Text("No Photo");

    return Card(
      color: Colors.teal[100],
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AnimalViewPage(animal: animal,)));
        },
        child: Column(
          children: <Widget>[
            photo,
            Text(
              animal.name,
              style: const TextStyle(
                fontSize: 20
              ),
            ),
            Text(
                animal.description
            )
          ],
        )
      )
    );
  }
}


class Animal {
  String name = '';
  String description = '';
  List<String> tags = [];
  String photoUrl = '';

  Animal(this.name, this.description, this.tags, this.photoUrl);
}

class DummyData {
  List<Animal> animals = [
    Animal(
      "Pudding",
      "A corgi",
      ["corgi", "small"],
      "assets/dummy1.jpg"
    ),
    Animal(
      "Brown",
      "A labrador",
      ["big"],
      "assets/dummy2.jpg"
    ),
    Animal(
      "Orengina",
      "Orange cat",
      ["cat", "orange"],
      "assets/dummy3.jpg"
    ),
    Animal(
      "Noir",
      "A black cat",
      ["cat", "black"],
      "assets/dummy4.jpg"
    )
  ];
}