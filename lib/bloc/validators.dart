import 'dart:async';

import 'package:jobsapp/utils/utils.dart';

class Validators {
  final validarEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);

    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('No es un email valido!');
    }
  });

  final validarCampoDeTextoVacio =
      StreamTransformer<String, String>.fromHandlers(handleData: (valor, sink) {
    if (valor.isEmpty) {
      return sink.addError("Este campo es requerido!");
    }
    sink.add(valor);
  });

  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length < 6) {
      return sink.addError("Ingresa al menos 6 caracteres!");
    }
    sink.add(password);
  });

  final validarCelular = StreamTransformer<String, String>.fromHandlers(
      handleData: (celular, sink) {
    if (celular.length < 10) {
      return sink.addError("No es un numero de celular valido!");
    }
    sink.add(celular);
  });

  final validarCedula = StreamTransformer<String, String>.fromHandlers(
      handleData: (cedula, sink) {
    if (!validarCedulaEcuador(cedula)) {
      return sink.addError("No es un numero de cedula valido!");
    }

    sink.add(cedula);
  });
}
