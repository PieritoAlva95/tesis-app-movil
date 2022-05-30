import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {

  final String textoRecibido;
  TextEditingController _textController = TextEditingController();

  SecondPage({Key ?key, required this.textoRecibido}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pantalla 2"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(24.0),
              child: TextField(
                controller: _textController,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: "Ingrese palabra",
                  hintText: "Palabra",
                ),
              ),
            ),
            MaterialButton(
              child: Text("Back"),
              onPressed: () {
                // regresamos datos en el pop
                Navigator.of(context).pop(textoRecibido + " " + _textController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}