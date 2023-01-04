import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/perfil_bloc.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/user.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/utils.dart';

class EditarRedesPage extends StatefulWidget {
  const EditarRedesPage({Key? key}) : super(key: key);

  @override
  _EditarRedesPageState createState() => _EditarRedesPageState();
}

class _EditarRedesPageState extends State<EditarRedesPage> {
  final TextEditingController _fbController = TextEditingController();
  final TextEditingController _twController = TextEditingController();
  final TextEditingController _lnController = TextEditingController();
  final TextEditingController _igController = TextEditingController();

  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  PerfilBloc perfilBloc = PerfilBloc();
  final usuarioProvider = UsuariosProvider();
  final preferencias = PreferenciasUsuario();
  Usuario user = Usuario(
    skills: [],
    fechaCreacion: DateTime.now(),
    experiencia: [],
    estudios: [],
    redesSociales: RedesSociales(),
  );
  RedesSociales redesSociales = RedesSociales();

  final String _url = URLFOTO;

  Future<void> verificarToken() async {
    bool verify = await usuarioProvider.verificarToken();
    if (verify) {
      preferencias.clear();
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => DashboardPage(),
          ),
          (Route<dynamic> route) => false);
    } else {
      print('Token válido ${preferencias.token}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _fbController.dispose();
    _twController.dispose();
    _igController.dispose();
    _lnController.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(
      () {
        verificarToken();
      },
    );
  }

  String id = '';
  String fotoUser = '';

  @override
  Widget build(BuildContext context) {
    perfilBloc = Provider.perfilBloc(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Redes Sociales'),
      ),
      key: scaffoldKey,
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          children: [
            FutureBuilder(
              future: perfilBloc.cargarUsuario(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasError) {
                  print("eroro: " + snapshot.hasError.toString());
                }
                if (snapshot.hasData && snapshot.data!['usuario'] != null) {
                  _fbController.text =
                      snapshot.data!['usuario']['redesSociales']['facebook'];
                  _twController.text =
                      snapshot.data!['usuario']['redesSociales']['twitter'];
                  _lnController.text =
                      snapshot.data!['usuario']['redesSociales']['linkedin'];
                  _igController.text =
                      snapshot.data!['usuario']['redesSociales']['instagram'];
                  return Column(
                    children: [
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text('Recuerde ingresar el link de su perfil!'),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      _formularioRedesSociales(),
                      const SizedBox(height: 20.0),
                      _botonAgregarRedesSociales(context)
                    ],
                  );
                } else {
                  print("no hay datos ");
                  return Center(
                    child: Container(
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 45.0),
                            const Text(
                              "No hay redes sociales registradas",
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(53, 80, 112, 1.0),
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            const FadeInImage(
                              placeholder:
                                  AssetImage('assets/img/buscando.png'),
                              image: AssetImage('assets/img/buscando.png'),
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 15.0),
                            _crearBotonRegresar(context),
                            const SizedBox(height: 30.0),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _botonAgregarRedesSociales(BuildContext context) {
    return ElevatedButton(
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
      ),
      child: const ListTile(
        leading: Icon(
          Icons.save,
          color: Colors.white,
        ),
        title: Text(
          'Guardar Redes Sociales',
          style: TextStyle(color: Colors.white),
        ),
      ),
      onPressed: () async {
        user.redesSociales.twitter = _twController.text.toString();
        user.redesSociales.facebook = _fbController.text.toString();
        user.redesSociales.linkedin = _lnController.text.toString();
        user.redesSociales.instagram = _igController.text.toString();

        final respuesta = await perfilBloc.editarDatosDelPerfilUsuario(user);
        mostrarSnackBar('Datos actualizados exitosamente');
        _twController.text = '';
        _fbController.text = '';
        _lnController.text = '';
        _igController.text = '';
        Navigator.pop(context);
        Navigator.pushNamed(context, 'editarredes');
      },
    );
  }

  _formularioRedesSociales() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: const FadeInImage(
            placeholder: AssetImage('assets/icons/fb.png'),
            image: AssetImage('assets/icons/fb.png'),
            height: 35.0,
          ),
          title: TextField(
            controller: _fbController,
            decoration: const InputDecoration(
              labelText: 'Facebook',
            ),
          ),
        ),
        ListTile(
          leading: const FadeInImage(
            placeholder: AssetImage('assets/icons/twt.png'),
            image: AssetImage('assets/icons/twt.png'),
            height: 35.0,
          ),
          title: TextField(
            controller: _twController,
            decoration: const InputDecoration(
              labelText: 'Twitter',
            ),
          ),
        ),
        ListTile(
          leading: const FadeInImage(
            placeholder: AssetImage('assets/icons/ig.png'),
            image: AssetImage('assets/icons/ig.png'),
            height: 35.0,
          ),
          title: TextField(
            controller: _igController,
            decoration: const InputDecoration(
              labelText: 'Instagram',
            ),
          ),
        ),
        ListTile(
          leading: const FadeInImage(
            placeholder: AssetImage('assets/icons/ln.png'),
            image: AssetImage('assets/icons/ln.png'),
            height: 35.0,
          ),
          title: TextField(
            controller: _lnController,
            decoration: const InputDecoration(
              labelText: 'LinkedIn',
            ),
          ),
        ),
      ],
    );
  }

  _crearBotonRegresar(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.blueAccent),
        elevation: MaterialStatePropertyAll(4.0),
      ),
      onPressed: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, 'home');
      },
      child: Text(
        'Regresar'.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
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
}
