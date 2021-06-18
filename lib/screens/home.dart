import 'package:flutter/material.dart';
import 'package:myapp/screens/second_page.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  var nameTextController = TextEditingController();
  var lastNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Nombre:"),
              controller: nameTextController,
            ),
            TextField(
              decoration: InputDecoration(labelText: "Apellido:"),
              controller: lastNameTextController,
            ),
            Align(
              alignment: Alignment.center,
              child: FloatingActionButton(
                onPressed: () {
                  _showSecondPage(context);
                },
                child: Icon(Icons.save),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showSecondPage(BuildContext context) {
    /* final route = MaterialPageRoute(builder: (BuildContext context) {
    return SecondPage(name: "MI DIANITA");
  });
  Navigator.of(context).push(route);
 */
    Navigator.of(context).pushNamed(
      "/second",
      arguments: SecondPageArguments(
          nameTextController.text, lastNameTextController.text),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameTextController = TextEditingController();
    lastNameTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameTextController.dispose();
    lastNameTextController.dispose();
  }
}
