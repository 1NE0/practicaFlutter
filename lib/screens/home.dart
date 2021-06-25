import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/resultHttp.dart';
import 'package:myapp/screens/second_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}

/* ADS */

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
                    onTap: () {
                      // LOGIC TO EDIT
                      // CREATE THE USER
                      Userb usercito =
                          new Userb(doc.id, doc.get('name'), doc.get('job'));
                      print("/////////////////////////////////////////");
                      print(usercito.name);
                      print(usercito.id);
                      print(usercito.job);
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return _editUser(user4: usercito);
                      }));
                    },
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // OPEN THE FORM
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return form();
          }));
        },
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
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
  }
}

class form extends StatefulWidget {
  form({Key? key}) : super(key: key);

  @override
  _formState createState() => _formState();
}

class _formState extends State<form> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameT = new TextEditingController();
  TextEditingController jobT = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cree un nuevo user"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            // Add TextFormFields and ElevatedButton here.
            TextFormField(
              decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Ingrese el nombre',
                  labelText: 'Name:'),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: nameT,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Ingrese el trabajo',
                  labelText: 'Job:'),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: jobT,
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Enviando datos")));

                  // SEND DATA
                  _create(nameT.text, jobT.text);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

void _create(var name, var job) async {
  final uid = FirebaseFirestore.instance.collection("users").doc().id;
  try {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'job': job,
    });
  } catch (e) {
    print(e);
  }
}

void _edit(var id, var name, var job) async {
  try {
    await FirebaseFirestore.instance.collection('users').doc(id).set({
      'name': name,
      'job': job,
    });
  } catch (e) {
    print(e);
  }
}

class Userb {
  final String id;
  final String name;
  final String job;

  Userb(this.id, this.name, this.job);
}

/* EDIT USER */

class _editUser extends StatefulWidget {
  final Userb? user4;
  _editUser({Key? key, @required Userb? this.user4}) : super(key: key);

  @override
  __editUserState createState() => __editUserState();
}

class __editUserState extends State<_editUser> {
  final _formKey2 = GlobalKey<FormState>();
  TextEditingController nameT = new TextEditingController();
  TextEditingController jobT = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Informacion para editar"),
      ),
      body: Form(
        key: _formKey2,
        child: Column(
          children: <Widget>[
            // Add TextFormFields and ElevatedButton here.
            TextFormField(
              decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Ingrese el nombre',
                  labelText: 'Name:'),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: nameT,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  hintText: 'Ingrese el trabajo',
                  labelText: 'Job:'),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: jobT,
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey2.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Enviando datos")));

                  // SEND DATA
                  _edit(widget.user4!.id, nameT.text, jobT.text);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    nameT.text = widget.user4!.name;
    jobT.text = widget.user4!.job;
    super.initState();
  }
}
