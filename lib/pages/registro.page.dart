// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/registro.bloc.dart';
import 'package:jobsapp/models/user.model.dart';
import 'package:jobsapp/pages/login.page.dart';
import 'package:jobsapp/utils/utils.dart';

class RegistroUsuarios extends StatefulWidget {
  const RegistroUsuarios({Key? key}) : super(key: key);

  @override
  State<RegistroUsuarios> createState() => _RegistroUsuariosState();
}

class _RegistroUsuariosState extends State<RegistroUsuarios> {
  bool visiblePassword = true;
  bool visibleConfirmPassword = true;

  final Usuario usuario = Usuario(
      skills: [],
      experiencia: [],
      estudios: [],
      fechaCreacion: DateTime.now(),
      redesSociales: RedesSociales());

  late RegistroBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = RegistroBloc();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Regístrate'),
        ),
        body: Stack(
          children: [
            _crearFondo(context),
            _loginForm(context),
          ],
        ));
  }

  Widget _loginForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(53, 80, 112, 1.0),
                Color.fromRGBO(29, 53, 87, 1.0),
              ],
            )),
            child: Expanded(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: [
                        const Text(
                          'Regístrate!',
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        _crearNombres(bloc),
                        const SizedBox(
                          height: 20.0,
                        ),
                        _crearApellidos(bloc),
                        const SizedBox(
                          height: 20.0,
                        ),
                        _crearCedula(bloc),
                        const SizedBox(
                          height: 20.0,
                        ),
                        _crearTelefono(bloc),
                        const SizedBox(
                          height: 20.0,
                        ),
                        _crearEmail(bloc),
                        const SizedBox(
                          height: 20.0,
                        ),
                        _crearPassword(bloc),
                        const SizedBox(
                          height: 20.0,
                        ),
                        _crearConfirmarPassword(bloc),
                        const SizedBox(
                          height: 14.0,
                        ),
                        _crearBoton(bloc),
                        TextButton(
                          child: const Text('¿Ya tienes una cuenta?',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, 'login'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearNombres(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.nombreStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                  color: Colors.white24,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 3.0),
                  spreadRadius: 2.0)
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 80.0,
          child: TextField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
                icon: const Icon(
                  Icons.person,
                  color: Color.fromRGBO(53, 80, 112, 1.0),
                ),
                hintText: 'Ingresa tus nombres',
                labelText: 'Nombres',
                //counterText: snapshot.data,
                errorText: snapshot.error?.toString()),
            onChanged: bloc.changeNombre,
          ),
        );
      },
    );
  }

  Widget _crearApellidos(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.apellidoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                  color: Colors.white24,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 3.0),
                  spreadRadius: 2.0)
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 80.0,
          child: TextField(
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.person,
                color: Color.fromRGBO(53, 80, 112, 1.0),
              ),
              hintText: 'Ingresa tus apellidos',
              labelText: 'Apellidos',
              //counterText: snapshot.data,
              errorText: snapshot.error?.toString(),
            ),
            onChanged: bloc.changeApellido,
          ),
        );
      },
    );
  }

  Widget _crearCedula(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.cedulaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                  color: Colors.white24,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 3.0),
                  spreadRadius: 2.0)
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 80.0,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                icon: const Icon(
                  Icons.perm_identity,
                  color: Color.fromRGBO(53, 80, 112, 1.0),
                ),
                hintText: 'Ingresa tu cédula de identidad',
                labelText: 'Cédula',
                //counterText: snapshot.data,
                errorText: snapshot.error?.toString()),
            onChanged: bloc.changeCedula,
          ),
        );
      },
    );
  }

  Widget _crearTelefono(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.celularStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                  color: Colors.white24,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 3.0),
                  spreadRadius: 2.0)
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 80.0,
          child: TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                icon: const Icon(
                  Icons.phone_android,
                  color: Color.fromRGBO(53, 80, 112, 1.0),
                ),
                hintText: 'Ingresa tu numero de celular',
                labelText: 'Celular',
                //counterText: snapshot.data,
                errorText: snapshot.error?.toString()),
            onChanged: bloc.changeCelular,
          ),
        );
      },
    );
  }

  Widget _crearEmail(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.white24,
                blurRadius: 3.0,
                offset: Offset(0.0, 3.0),
                spreadRadius: 2.0,
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 80.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.alternate_email,
                color: Color.fromRGBO(53, 80, 112, 1.0),
              ),
              hintText: 'Ingresa un correo',
              labelText: 'Correo electrónico',
              //counterText: snapshot.data,
              errorText: snapshot.error?.toString(),
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearPassword(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.white24,
                blurRadius: 3.0,
                offset: Offset(0.0, 3.0),
                spreadRadius: 2.0,
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 80.0,
          child: TextField(
            obscureText: visiblePassword,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.lock_outline,
                color: Color.fromRGBO(53, 80, 112, 1.0),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                    visiblePassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      visiblePassword = !visiblePassword;
                    });
                  }
                },
              ),
              hintText: 'Ingresar contraseña',
              labelText: 'Contraseña',
              //counterText: snapshot.data,
              errorText: snapshot.error?.toString(),
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  Widget _crearConfirmarPassword(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.confirmarPasswordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.white24,
                blurRadius: 3.0,
                offset: Offset(0.0, 3.0),
                spreadRadius: 2.0,
              )
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 80.0,
          child: TextField(
            obscureText: visibleConfirmPassword,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.lock_outline,
                color: Color.fromRGBO(53, 80, 112, 1.0),
              ),
              suffixIcon: IconButton(
                icon: Icon(visibleConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      visibleConfirmPassword = !visibleConfirmPassword;
                    });
                  }
                },
              ),
              hintText: 'Ingresar nuevamente tu contraseña',
              labelText: 'Confirmar contraseña',
              //counterText: snapshot.data,
              errorText: snapshot.error?.toString(),
            ),
            onChanged: bloc.changeConfirmPassword,
          ),
        );
      },
    );
  }

  _crearBoton(RegistroBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text('Registrar'.toUpperCase()),
            ),
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              elevation: const MaterialStatePropertyAll(10.0),
              backgroundColor: const MaterialStatePropertyAll(
                Color.fromRGBO(53, 80, 112, 2.0),
              ),
              textStyle: const MaterialStatePropertyAll(
                TextStyle(color: Colors.white),
              ),
            ),
            onPressed:
                snapshot.hasData ? () => _registroUsuario(bloc, context) : null,
          );
        });
  }

  _registroUsuario(RegistroBloc bloc, BuildContext context) async {
    usuario.nombres = bloc.nombre.toString();
    usuario.apellidos = bloc.apellido.toString();
    usuario.documentoDeIdentidad = bloc.cedula.toString();
    usuario.numeroDeCelular = bloc.celular.toString();
    usuario.email = bloc.email.toString();
    usuario.password = bloc.password.toString();
    usuario.passwordConfirmar = bloc.confirmarPassword.toString();

    Map<String, dynamic>? respuesta = await bloc.registrarNuevoUsuario(usuario);

    if (respuesta!['ok']) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      mostrarAlerta(context, respuesta['msg']);
    }
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.3,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/worker.jpg'),
        ),
      ),
    );
  }
}
