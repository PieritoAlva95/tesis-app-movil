import 'package:flutter/material.dart';
import 'package:jobsapp/models/password.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';

class CambiarPasswordPage extends StatefulWidget {
  const CambiarPasswordPage({Key? key}) : super(key: key);

  @override
  _CambiarPasswordPage createState() => _CambiarPasswordPage();
}

class _CambiarPasswordPage extends State<CambiarPasswordPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool visiblePasswordActual = true;
  bool visible = true;
  bool visibleConfirmarPassword = true;

  final TextEditingController _passActualController = TextEditingController();
  final TextEditingController _passNuevaController = TextEditingController();
  final TextEditingController _confirmarPassNuevaController =
      TextEditingController();

  final usuarioProvider = UsuariosProvider();
  final preferenciaToken = PreferenciasUsuario();
  bool estaLogueado = false;

  Future<void> verificarToken() async {
    bool verify = await usuarioProvider.verificarToken();
    if (verify) {
      estaLogueado = false;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => DashboardPage()),
          (Route<dynamic> route) => false);
    } else {
      estaLogueado = true;
      print('Token: ${preferenciaToken.token}');
    }
  }

  @override
  void initState() {
    super.initState();
    verificarToken();
  }

  @override
  Widget build(BuildContext context) {
    _passActualController.text = preferenciaToken.passwordActual.toString();
    print(_passActualController.text.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cambia tu contraseña'),
      ),
      key: scaffoldKey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _loginForm(context),
          ],
        ),
      ),
    );
  }

  _loginForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 80.0,
            ),
          ),
          Container(
            width: double.infinity,
            margin:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                // _crearPasswordActual(),
                // const SizedBox(
                //   height: 30.0,
                // ),
                _crearPassword(),
                const SizedBox(
                  height: 30.0,
                ),
                _crearConfirmarPassword(),
                const SizedBox(
                  height: 60.0,
                ),
                _crearBoton(),
                const SizedBox(
                  height: 60.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _crearPassword() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: _passNuevaController,
        obscureText: visible,
        decoration: InputDecoration(
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
          labelText: 'Nueva Contraseña',
          hintText: "Ingrese al menos 6 caracteres!",
          //counterText: snapshot.data,
        ),
      ),
    );
  }

  _crearConfirmarPassword() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: TextField(
        controller: _confirmarPassNuevaController,
        obscureText: visibleConfirmarPassword,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(visibleConfirmarPassword
                ? Icons.visibility_off
                : Icons.visibility),
            onPressed: () {
              if (mounted) {
                setState(() {
                  visibleConfirmarPassword = !visibleConfirmarPassword;
                });
              }
            },
          ),
          labelText: 'Repita la Contraseña',
          hintText: "Ingrese al menos 6 caracteres!",
          //counterText: snapshot.data,
        ),
      ),
    );
  }

  _crearBoton() {
    return ElevatedButton(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
        child: const Text('Cambiar contraseña'),
      ),
      style: ButtonStyle(
        shape: MaterialStatePropertyAll<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        elevation: const MaterialStatePropertyAll<double>(10.0),
        backgroundColor: const MaterialStatePropertyAll(
          Color.fromRGBO(53, 80, 112, 1.0),
        ),
        textStyle: const MaterialStatePropertyAll<TextStyle>(
          TextStyle(color: Colors.white),
        ),
      ),
      onPressed: () {
        _cambiarPassword(context);
      },
    );
  }

  _cambiarPassword(BuildContext context) async {
    if (_passNuevaController.text.toString() ==
        _confirmarPassNuevaController.text.toString()) {
      Password pass = Password();

      pass.passwordActual = _passActualController.text.toString();
      pass.password = _passNuevaController.text.toString();

      final respuesta = await usuarioProvider.editarPasswordDelUsuario(pass);
      print('Respuesta: ${respuesta}');
      _passActualController.text = '';
      _passNuevaController.text = '';
      preferenciaToken.clear();
      print('ELIMINANDO TOKEN ${preferenciaToken.token}');
      Navigator.pop(context);
      Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
    } else {
      mostrarSnackBar('Las contraseñas no son iguales');
    }
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: const Duration(milliseconds: 1800),
      backgroundColor: const Color.fromRGBO(29, 53, 87, 1.0),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
