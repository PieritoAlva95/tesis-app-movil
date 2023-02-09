// ignore_for_file: deprecated_member_use

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/email.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  UsuariosProvider userProvider = UsuariosProvider();

  bool visible = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String firebaseToken = '';

  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  @override
  initState() {
    super.initState();

    _firebaseMessaging.getToken().then((value) {
      print('mi token $value');
      firebaseToken = value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: Stack(
        children: [
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(53, 80, 112, 1.0),
                  Color.fromRGBO(29, 53, 87, 1.0),
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: size.width * 0.85,
                  margin: const EdgeInsets.symmetric(vertical: 30.0),
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    children: [
                      const Text(
                        'Iniciar Sesión',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      _crearEmail(bloc!),
                      const SizedBox(height: 30.0),
                      _crearPassword(bloc),
                      const SizedBox(height: 30.0),
                      _crearBoton(bloc),
                      const SizedBox(height: 30.0),
                      InkWell(
                        onTap: () {
                          Alert(
                            context: context,
                            title: "Resetear Contraseña",
                            content: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 25.0),
                                  const Text(
                                    'Por favor, introduzca la dirección de correo electrónico que utilizó para registrarse y se le enviará un correo con la nueva contraseña.',
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  const SizedBox(height: 25.0),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                      ),
                                      errorStyle: TextStyle(height: 0),
                                      icon: Icon(Icons.email),
                                      labelText: 'Email',
                                    ),
                                    validator: (value) {
                                      RegExp regExp = RegExp(pattern);

                                      if (!regExp.hasMatch(value.toString())) {
                                        return 'No es un email valido!';
                                      }
                                      return null;
                                    },
                                    onChanged: (data) {
                                      setState(() {
                                        _formKey.currentState!.validate()
                                            ? ''
                                            : '';
                                        print(data);
                                      });
                                    },
                                  ),

                                  /*TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.book),
                                      labelText: 'Email',
                                      errorText: _errorTextEmail,
                                    ),
                                    
                                  ),*/
                                ],
                              ),
                            ),
                            buttons: [
                              DialogButton(
                                color: const Color.fromRGBO(29, 53, 87, 1.0),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Email email = Email(
                                      email: _emailController.text.toString(),
                                    );
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
                                  } else {
                                    mostrarSnackBar('ingrese el email');
                                  }
                                },
                                child: const Text(
                                  "Enviar",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          ).show();
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            '¿Has olvidado tu contraseña?',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, 'registro');
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Registrarse',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
      duration: const Duration(milliseconds: 1800),
      backgroundColor: const Color.fromRGBO(29, 53, 87, 1.0),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  Widget _crearPassword(LoginBloc bloc) {
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
            obscureText: visible,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.lock_outline,
                color: Color.fromRGBO(53, 80, 112, 1.0),
              ),
              suffixIcon: IconButton(
                icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      visible = !visible;
                    });
                  }
                },
              ),
              hintText: 'Ingresar contraseña',
              labelText: 'Contraseña',
              errorText: snapshot.error?.toString(),
            ),
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
        return ElevatedButton(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text('Ingresar'.toUpperCase()),
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
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
          ),
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    String correo = bloc.email.toString();
    String password = bloc.password.toString();

    var respuesta = await bloc.login(correo, password);

    if (respuesta['ok']) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => DashboardPage(),
          ),
          (Route<dynamic> route) => false);
      await bloc.editarTokenFCMDelUsuario(firebaseToken);
      print(firebaseToken);
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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/img/worker.jpg'),
        ),
      ),
    );
  }

  Widget _crearFondoFormulario(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.65,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(53, 80, 112, 1.0),
            Color.fromRGBO(29, 53, 87, 1.0),
          ],
        ),
      ),
    );
  }
}
