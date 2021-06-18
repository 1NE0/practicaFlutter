import 'package:flutter/material.dart';
import 'package:myapp/screens/second_page.dart';

class home extends StatelessWidget {
  const home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME"),
      ),
      body: FloatingActionButton(
        onPressed: () {
          _showSecondPage(context);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

void _showSecondPage(BuildContext context) {
  /* final route = MaterialPageRoute(builder: (BuildContext context) {
    return SecondPage(name: "MI DIANITA");
  });
  Navigator.of(context).push(route);
 */
  Navigator.of(context).pushNamed(
    "/second",
    arguments: SecondPageArguments("DIANA", "OVIEDO"),
  );
}
