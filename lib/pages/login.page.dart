// ignore_for_file: deprecated_member_use

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/email.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  UsuariosProvider userProvider = UsuariosProvider();

  bool visible = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String firebaseToken = 'acavaeltokendefirebasecelular';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Iniciar Sesión'),
        ),
        body: Stack(
          children: [
            _crearFondo(context),
            _loginForm(context),
          ],
        ));
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 200.0,
            ),
          ),
          Container(
            height: size.height * 0.85,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(53, 80, 112, 1.0),
                Color.fromRGBO(29, 53, 87, 1.0),
              ],
            )),
            child: Column(
              children: [
                Container(
                  width: size.width * 0.85,
                  margin: EdgeInsets.symmetric(vertical: 30.0),
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    children: [
                      Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      _crearEmail(bloc!),
                      SizedBox(
                        height: 30.0,
                      ),
                      _crearPassword(bloc),
                      SizedBox(
                        height: 30.0,
                      ),
                      _crearBoton(bloc),
                      SizedBox(
                        height: 30.0,
                      ),
                      InkWell(
                        onTap: () {
                          Alert(
                              context: context,
                              title: "Resetear Contraseña",
                              content: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  Text(
                                    'Por favor, introduzca la dirección de correo electrónico que utilizó para registrarse y se le enviará un correo con la nueva contraseña.',
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  SizedBox(
                                    height: 25.0,
                                  ),
                                  TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.book),
                                      labelText: 'Email',
                                    ),
                                  ),
                                ],
                              ),
                              buttons: [
                                DialogButton(
                                  color: Color.fromRGBO(29, 53, 87, 1.0),
                                  onPressed: () async {
                                    Email email = Email(
                                        email:
                                            _emailController.text.toString());

                                    final respuesta = await userProvider
                                        .editarEmailDelUsuario(email);

                                    if (respuesta['ok'] == false) {
                                      Navigator.pop(context);
                                      mostrarSnackBar(respuesta['msg']);
                                      _emailController.text = '';
                                      return;
                                    }

                                    _emailController.text = '';
                                    Navigator.pop(context);
                                    //Navigator.pushReplacementNamed(context, 'editarhabilidad');
                                  },
                                  child: Text(
                                    "Enviar",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ]).show();

                          //Navigator.pushNamed(context, 'reseteopassword');
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '¿Has olvidado tu contraseña?',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, 'registro');
                        },
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Registrarse',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.white24,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 3.0),
                    spreadRadius: 2.0)
              ]),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          height: 80.0,
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.alternate_email,
                  color: Color.fromRGBO(53, 80, 112, 1.0),
                ),
                hintText: 'Ingresa un correo',
                labelText: 'Correo electrónico',
                errorText: snapshot.error?.toString()),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1800),
      backgroundColor: Color.fromRGBO(29, 53, 87, 1.0),
    );
    scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.white24,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 3.0),
                    spreadRadius: 2.0)
              ]),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          height: 80.0,
          child: TextField(
            obscureText: visible,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock_outline,
                  color: Color.fromRGBO(53, 80, 112, 1.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    if (mounted)
                      setState(() {
                        visible = !visible;
                      });
                  },
                ),
                hintText: 'Ingresar contraseña',
                labelText: 'Contraseña',
                errorText: snapshot.error?.toString()),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidLogin,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text('Ingresar'.toUpperCase()),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 10.0,
            color: Color.fromRGBO(53, 80, 112, 2.0),
            textColor: Colors.white,
            onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
          );
        });
  }

  _login(LoginBloc bloc, BuildContext context) async {
    String correo = bloc.email.toString();
    String password = bloc.password.toString();

    var respuesta = await bloc.login(correo, password);

    if (respuesta['ok']) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => DashboardPage()),
          (Route<dynamic> route) => false);

      await bloc.editarTokenFCMDelUsuario(firebaseToken);
      print(firebaseToken);
      //_preferenciasDelUsuario.tokenFCM
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta(context, respuesta['msg']);
    }
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        height: size.height * 0.35,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/img/worker.jpg'),
        )));
  }

  Widget _crearFondoFormulario(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.65,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromRGBO(53, 80, 112, 1.0),
          Color.fromRGBO(29, 53, 87, 1.0),
        ],
      )),
    );
  }
}
