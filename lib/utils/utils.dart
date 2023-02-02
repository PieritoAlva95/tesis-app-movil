import 'package:flutter/material.dart';

String urlPhotoUserNotFound =
    'https://us.123rf.com/450wm/apoev/apoev1902/apoev190200141/125038134-persona-hombre-de-marcador-de-posici%C3%B3n-de-foto-gris-en-un-traje-sobre-fondo-gris.jpg?ver=6';
String URLFOTOPERFIL =
    'https://us.123rf.com/450wm/apoev/apoev1902/apoev190200141/125038134-persona-hombre-de-marcador-de-posici%C3%B3n-de-foto-gris-en-un-traje-sobre-fondo-gris.jpg?ver=6';
String URLFOTO = 'https://backend-tesis-jobs.herokuapp.com/uploads/';
String URLBASE = 'https://backend-tesis-jobs.herokuapp.com';

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

bool validarCedulaEcuador(String cedula) {
  if (cedula.length != 10) {
    return false;
  }

  int sum = 0;
  for (int i = 0; i < cedula.length - 1; i++) {
    int digit = int.parse(cedula[i]);
    if (i % 2 == 0) {
      digit *= 2;
      if (digit > 9) {
        digit -= 9;
      }
    }
    sum += digit;
  }

  int lastDigit = int.parse(cedula[9]);
  int expectedLastDigit = 10 - (sum % 10);
  if (expectedLastDigit == 10) {
    expectedLastDigit = 0;
  }

  return lastDigit == expectedLastDigit;
}
