import 'package:flutter/material.dart';

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

    // Stub loads from dummy
    DummyData dummy = DummyData();
    setState(() {
      animals = dummy.animals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dog Cat Matcher"),
      ),
      body: AnimalGrid(animals: animals),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
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
        name: animal.name,
        description: animal.description,
        photoUrl: animal.photoUrl,
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
    required this.name,
    this.description = "",
    this.photoUrl,
  }) : super(key: key);

  final String name;
  final String description;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {

    Widget photo = (photoUrl != null)? Image(
      image: AssetImage(photoUrl!),
    ): const Text("No Photo");

    return Card(
      color: Colors.teal[100],
      child: Column(
        children: <Widget>[
          photo,
          Text(
            name,
            style: const TextStyle(
              fontSize: 20
            ),
          ),
          Text(
            description
          )
        ],
      )
    );
    // return Container(
    //   padding: const EdgeInsets.all(16.0),
    //   color: Colors.teal[100],
    //   child: const Text("Lorem Ipsum")
    // );
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