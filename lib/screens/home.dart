import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/resultHttp.dart';
import 'package:myapp/screens/second_page.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return _persistencePage();
              }));
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
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return ListTile();
        },
      ),
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

/* persistence page */

class _persistencePage extends StatefulWidget {
  _persistencePage({Key? key}) : super(key: key);

  @override
  __persistencePageState createState() => __persistencePageState();
}

class __persistencePageState extends State<_persistencePage> {
  final users = FirebaseFirestore.instance.collection('users').get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Persistence"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(doc.get('name').substring(0, 1)),
                    ),
                    title: Text(doc.get('name')),
                    subtitle: Text(doc.get('job')),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  void getUsers() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    for (var message in users.docs) {}
  }
}
