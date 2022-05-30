import 'dart:async';

import 'package:jobsapp/bloc/validators.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _preferenciasDelUsuario =  PreferenciasUsuario();

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //RECUPERAR LOS DATOS DEL STREAM
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream;

  Stream<bool> get formValidLogin =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  //INSERTAR VALORES AL STREAM
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //OBTENER EL ÚLTIMO VALOR INGRESADO A LOS STREAMS
  String? get email => _emailController.valueOrNull;
  String? get password => _passwordController.valueOrNull;

  final _loginUsuarioProvider = UsuariosProvider();

  Future<Map<String, dynamic>> login(
    String correo, String password) async {
    var data = await _loginUsuarioProvider.login(correo, password);

print(data);

    if (data.toString().contains('token')) {
      _preferenciasDelUsuario.token = data['token'];
      return data;
    } else {
      return data;
    }
  }

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
