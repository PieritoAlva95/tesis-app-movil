import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jobsapp/bloc/perfil_bloc.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/estudios.model.dart';
import 'package:jobsapp/models/experiencia.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

class ListarEstudioPage extends StatefulWidget {
  const ListarEstudioPage({Key? key}) : super(key: key);

  @override
  _ListarEstudioPageState createState() => _ListarEstudioPageState();
}

class _ListarEstudioPageState extends State<ListarEstudioPage> {
  final TextEditingController _tituloExperienciaController =
      TextEditingController();
  final TextEditingController _empresaExperienciaController =
      TextEditingController();
  final TextEditingController _inicioExperienciaController =
      TextEditingController();
  final TextEditingController _finExperienciaController =
      TextEditingController();
  final TextEditingController _descripcionExperienciaController =
      TextEditingController();

  List<Estudio> experienciaParaWidget = [];
  List experienciaList = [];
  var uuid = const Uuid();
  Estudio expInicial = Estudio(fechaInicio: DateTime.now());
  Estudio exp = Estudio(fechaInicio: DateTime.now());
  Estudio expEliminada = Estudio(fechaInicio: DateTime.now());
  Estudio expEliminadaNuevamenteAgregada = Estudio(fechaInicio: DateTime.now());

  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool circularProgress = false;
  PerfilBloc perfilBloc = PerfilBloc();
  final usuarioProvider = UsuariosProvider();
  final preferencias = PreferenciasUsuario();
  EstudioClass user = EstudioClass(estudios: []);

  bool estaLogueado = false;

  Future<void> verificarToken() async {
    bool verify = await usuarioProvider.verificarToken();
    if (verify) {
      estaLogueado = false;
      preferencias.clear();
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => DashboardPage()),
          (Route<dynamic> route) => false);
    } else {
      estaLogueado = true;
      print('Token válido ${preferencias.token}');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tituloExperienciaController.dispose();
    _empresaExperienciaController.dispose();
    _inicioExperienciaController.dispose();
    _finExperienciaController.dispose();
    _descripcionExperienciaController.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      verificarToken();
    });
  }

  String id = '';
  String fotoUser = '';

  @override
  Widget build(BuildContext context) {
    perfilBloc = Provider.perfilBloc(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estudios'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'agregarestudio');
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 40.0,
            ),
          )
        ],
      ),
      key: scaffoldKey,
      //drawer: MenuWidget(),
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
                experienciaParaWidget = [];
                if (snapshot.hasError) {
                  print("eroro: " + snapshot.hasError.toString());
                }
                if (snapshot.hasData &&
                    snapshot.data!['usuario']['estudios'].length > 0) {
                  experienciaList = snapshot.data!['usuario']['estudios'];
                  for (var i = 0; i < experienciaList.length; i++) {
                    expInicial = Estudio(
                      id: experienciaList[i]['_id'],
                      titulo: experienciaList[i]['titulo'],
                      nombreInstitucion: experienciaList[i]
                          ['nombreInstitucion'],
                      fechaInicio: DateTime.parse(
                          experienciaList[i]['fechaInicio'].toString()),
                      fechaFin: experienciaList[i]['fechaFin'],
                      descripcion: experienciaList[i]['descripcion'],
                    );
                    experienciaParaWidget.add(expInicial);
                  }
                  for (var item in experienciaParaWidget) {
                    print(item.titulo);
                  }
                  return Column(
                    children: [
                      _recorrerExperiencia(),
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
                              "No hay información de tus estudios",
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(53, 80, 112, 1.0),
                              ),
                            ),
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

  _recorrerExperiencia() {
    return Column(
      children: experienciaParaWidget
          .map<Widget>(
            (experiencia) => Column(
              children: [
                const SizedBox(height: 5.0),
                Text(
                  experiencia.titulo,
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  experiencia.descripcion,
                  style: const TextStyle(
                    fontSize: 11.0,
                    color: Color.fromRGBO(53, 80, 112, 2.0),
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    const Text(
                      'Fecha de inicio: ',
                      style: TextStyle(
                        color: Color.fromRGBO(53, 80, 112, 2.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(experiencia.fechaInicio),
                      style: const TextStyle(
                        color: Color.fromRGBO(53, 80, 112, 2.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    const Text(
                      'Fecha fin: ',
                      style: TextStyle(
                        color: Color.fromRGBO(53, 80, 112, 2.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      experiencia.fechaFin,
                      style: const TextStyle(
                        color: Color.fromRGBO(53, 80, 112, 2.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        print(experiencia.id);
                        Navigator.pushNamed(
                          context,
                          'editarestudio',
                          arguments: {experiencia.id},
                        );
                      },
                      child: const Icon(Icons.edit),
                    ),
                    TextButton(
                      onPressed: () async {
                        Alert(
                          context: context,
                          content: Column(
                            children: <Widget>[
                              Column(
                                children: [
                                  const Text(
                                    '¿Desea eliminar el siguiente estudio?',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Text(experiencia.titulo),
                                  const SizedBox(height: 15.0),
                                ],
                              )
                            ],
                          ),
                          buttons: [
                            DialogButton(
                              onPressed: () async {
                                for (var i = 0;
                                    i < experienciaList.length;
                                    i++) {
                                  if (experienciaList[i]
                                      .toString()
                                      .contains(experiencia.id)) {
                                    experienciaList.remove(experienciaList[i]);
                                  }
                                }
                                experienciaParaWidget = [];
                                for (var i = 0;
                                    i < experienciaList.length;
                                    i++) {}
                                for (var i = 0;
                                    i < experienciaList.length;
                                    i++) {
                                  expEliminada = Estudio(
                                    id: experienciaList[i]['_id'],
                                    titulo: experienciaList[i]['titulo'],
                                    nombreInstitucion: experienciaList[i]
                                        ['nombreInstitucion'],
                                    fechaInicio: DateTime.parse(
                                        experienciaList[i]['fechaInicio']
                                            .toString()),
                                    fechaFin: experienciaList[i]['fechaFin'],
                                    descripcion: experienciaList[i]
                                        ['descripcion'],
                                  );
                                  experienciaParaWidget.add(expEliminada);
                                }
                                user.estudios = experienciaParaWidget;
                                final respuesta = await perfilBloc
                                    .editarEstudioDelUsuario(user);
                                print('Respuesta: ${respuesta}');
                                mostrarSnackBar(
                                    'Datos actualizados exitosamente');
                                setState(
                                  () {
                                    _tituloExperienciaController.clear();
                                    _empresaExperienciaController.clear();
                                    _inicioExperienciaController.clear();
                                    _finExperienciaController.clear();
                                    _descripcionExperienciaController.clear();
                                  },
                                );
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Aceptar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            DialogButton(
                              color: Colors.grey,
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text(
                                "Cancelar",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ],
                        ).show();
                      },
                      child: Image.asset(
                        'assets/img/delete.png',
                        height: 25.0,
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          )
          .toList(),
    );
  }

  List<Experiencia> agregarExperiencia(
      List<Experiencia> list, Experiencia subject) {
    if (list.contains(subject)) {
      list.remove(subject);
      return list;
    } else {
      list.add(subject);
      return list;
    }
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
          fontSize: 16.0,
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
