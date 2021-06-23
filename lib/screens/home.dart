import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/models/resultHttp.dart';
import 'package:myapp/screens/second_page.dart';
import 'package:http/http.dart' as http;

int _index = 0;
User usercito = User("", 2, 3);

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  /* var nameTextController = TextEditingController();
  var lastNameTextController = TextEditingController(); */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HOME"), actions: [
        IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Show Snackbar',
            onPressed: () async {
              // LOGIC FOR BUTTON ADD
            }),
        IconButton(
            icon: const Icon(Icons.whatshot),
            tooltip: 'API',
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return otherPage();
              }));
              // LOGIC HTTP
              var url = Uri.parse('https://api.agify.io/?name=alfredo');
              var response = await http.get(url);
              print(response.body);

              Map<String, dynamic> map = jsonDecode(response.body);
              usercito = User.fromJson(map);

              print(usercito.name.toString());
            })
      ]),
      drawer: Drawer(),
    );
  }
}

/* second page */

class otherPage extends StatefulWidget {
  otherPage({Key? key}) : super(key: key);

  @override
  _otherPageState createState() => _otherPageState();
}

class _otherPageState extends State<otherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PRACTICA CON JSON's"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(1),
          children: <Widget>[
            ListTile(
              title: Text("" + usercito.name),
              leading: Icon(Icons.account_circle_rounded),
            )
          ],
        ));
  }
}
