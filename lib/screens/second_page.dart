import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final persona =
        ModalRoute.of(context)!.settings.arguments as SecondPageArguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Second screen"),
      ),
      body: Center(
        child: Text(persona.nombre + " " + persona.lastName),
      ),
    );
  }
}

class SecondPageArguments {
  final String nombre;
  final String lastName;

  SecondPageArguments(this.nombre, this.lastName);
}
