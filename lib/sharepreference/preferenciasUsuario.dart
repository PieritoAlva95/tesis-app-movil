

import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences? _prefs;

  initPreferencias() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get token {
    return _prefs?.getString('token') ?? '';
  }

  set token(String value) {
    _prefs?.setString('token', value);
  }

  String get idUsuario {
    return _prefs?.getString('idUsuario') ?? '';
  }

  set idUsuario(String value) {
    _prefs?.setString('idUsuario', value);
  }

  String get tokenFCM {
    return _prefs?.getString('tokenFCM') ?? '';
  }

  set tokenFCM(String value) {
    _prefs?.setString('tokenFCM', value);
  }

    String get nombres {
    return _prefs?.getString('nombres') ?? '';
  }

  set nombres(String value) {
    _prefs?.setString('nombres', value);
  }
  

      String get passwordActual {
    return _prefs?.getString('passwordActual') ?? '';
  }

  set passwordActual(String value) {
    _prefs?.setString('passwordActual', value);
  }

  Future clear() async {
    await _prefs?.clear();
  }
}
