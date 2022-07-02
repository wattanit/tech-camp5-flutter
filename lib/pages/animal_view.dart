import 'package:flutter/material.dart';
import 'main.dart';

class AnimalViewPage extends StatelessWidget {
  const AnimalViewPage({
    Key? key,
    required this.animal
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

    List<TextButton> tags = animal.tags.map((tag)=>
        TextButton(
          onPressed: (){},
          child: Text(tag),
        )
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(animal.name),
      ),
      body: Column(
        children: <Widget>[
          photo,
          const SizedBox(height: 10),
          const Text("Description"),
          Text(
            animal.description,
            style: const TextStyle(
              fontSize: 20
            ),
          ),
          const SizedBox(height: 20),
          const Text("Tags"),
          Row(
            children: tags,
          )
        ],
      ),
    );
  }
}
