import 'package:flutter/material.dart';

String urlPhotoUserNotFound =
    'https://us.123rf.com/450wm/apoev/apoev1902/apoev190200141/125038134-persona-hombre-de-marcador-de-posici%C3%B3n-de-foto-gris-en-un-traje-sobre-fondo-gris.jpg?ver=6';
String URLFOTOPERFIL =
    'https://us.123rf.com/450wm/apoev/apoev1902/apoev190200141/125038134-persona-hombre-de-marcador-de-posici%C3%B3n-de-foto-gris-en-un-traje-sobre-fondo-gris.jpg?ver=6';
String URLFOTO = 'https://backend-tesis-node.herokuapp.com/uploads/';
String URLBASE = 'https://backend-tesis-node.herokuapp.com';

String SEARCHNOTFOUND =
    'https://img.freepik.com/premium-vector/file-found-illustration-with-confused-people-holding-big-magnifier-search-no-result_258153-336.jpg?w=900';
void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¡Lo sentimos!'),
          content: Text(mensaje),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}
