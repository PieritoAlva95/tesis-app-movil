import 'dart:async';

import 'package:jobsapp/bloc/validators.dart';
import 'package:jobsapp/models/user.model.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:rxdart/rxdart.dart';

class RegistroBloc with Validators {


    final _nombreController = BehaviorSubject<String>();
    final _apellidoController = BehaviorSubject<String>();
    final _cedulaController = BehaviorSubject<String>();
    final _celularController = BehaviorSubject<String>();
    final _emailController = BehaviorSubject<String>();
    final _passwordController = BehaviorSubject<String>();
    final _confirmarPasswordController = BehaviorSubject<String>();



  //RECUPERAR LOS DATOS DEL STREAM
  Stream<String> get nombreStream => _nombreController.stream;
  Stream<String> get apellidoStream => _apellidoController.stream;
  Stream<String> get cedulaStream => _cedulaController.stream;
  Stream<String> get celularStream => _celularController.stream;
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream;
  Stream<String> get confirmarPasswordStream => _confirmarPasswordController.stream;


  Stream<bool> get formValidPasswordStream => Rx.combineLatest2(passwordStream, confirmarPasswordStream, (e, p) => true);
  Stream<bool> get formValidStream => Rx.combineLatest7(nombreStream, apellidoStream, cedulaStream, celularStream, emailStream, passwordStream, confirmarPasswordStream, (n, a, c, t, e, p, q) => true);

  //INSERTAR VALORES AL STREAM
  Function(String) get changeNombre => _nombreController.sink.add;
  Function(String) get changeApellido => _apellidoController.sink.add;
  Function(String) get changeCedula => _cedulaController.sink.add;
  Function(String) get changeCelular => _celularController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeConfirmPassword => _confirmarPasswordController.sink.add;


  //OBTENER LOS ULTIMOS VALORES INGRESADOS A LOS STREAMS
  String get nombre => _nombreController.value;
  String get apellido => _apellidoController.value;
  String get cedula => _cedulaController.value;
  String get celular => _celularController.value;
  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get confirmarPassword => _confirmarPasswordController.value;


  final UsuariosProvider _registroUsuarioProvider =  UsuariosProvider();


 Future<Map<String, dynamic>?> registrarNuevoUsuario(Usuario usuario) async{
    Map<String, dynamic>? data = await _registroUsuarioProvider.crearUsuario(usuario);

    if(data.toString().contains('token')){
      return data;
    }else{
      return data;
    }

  }

  dispose(){
    print('dispose');
    _nombreController.close();
    _apellidoController.close();
    _celularController.close();
    _emailController.close();
  }
}
