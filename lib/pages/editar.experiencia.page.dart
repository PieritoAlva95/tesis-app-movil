import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/perfil_bloc.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/experiencia.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/switch.list.tile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class EditExpPage extends StatefulWidget {
  const EditExpPage({Key? key}) : super(key: key);

  @override
  _EditExpPageState createState() => _EditExpPageState();
}

class _EditExpPageState extends State<EditExpPage> {
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

  List<Experiencia> experienciaParaWidget = [];
  List experienciaList = [];
  var uuid = const Uuid();
  String _fecha = '';
  DateTime tiempo = DateTime.now();

  Experiencia expInicial = Experiencia(fechaInicio: DateTime.now());
  Experiencia exp = Experiencia(fechaInicio: DateTime.now());
  Experiencia expEliminada = Experiencia(fechaInicio: DateTime.now());
  Experiencia expEliminadaNuevamenteAgregada =
      Experiencia(fechaInicio: DateTime.now());

  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _blouearCheck = false;
  final String _callBackParams = '';

  bool circularProgress = false;
  PerfilBloc perfilBloc = PerfilBloc();
  final usuarioProvider = UsuariosProvider();
  final preferencias = PreferenciasUsuario();
  UsuarioClass user = UsuarioClass(experiencia: []);

  Map<String, dynamic> dataUsuarioPostulante = {};

  @override
  void dispose() {
    super.dispose();
    _tituloExperienciaController.dispose();
    _empresaExperienciaController.dispose();
    _inicioExperienciaController.dispose();
    _finExperienciaController.dispose();
    _descripcionExperienciaController.dispose();
  }

  String id = '';
  String fotoUser = '';
  String result = '';

  @override
  Widget build(BuildContext context) {
    perfilBloc = Provider.perfilBloc(context)!;

    final _categoriaElegida = ModalRoute.of(context)!.settings.arguments;
    print(_categoriaElegida);
    final primero = _categoriaElegida.toString().replaceFirst('{', '');
    final pos = primero.length - 1;
    result = primero.substring(0, pos);
    print('Final Elegida ${result}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiencia'),
      ),
      body: SingleChildScrollView(
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          children: [
            FutureBuilder(
              future:
                  perfilBloc.cargarUsuarioEspecifico(preferencias.idUsuario),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                experienciaParaWidget = [];

                if (snapshot.hasError) {
                  print("eroro: " + snapshot.hasError.toString());
                }
                if (snapshot.hasData) {
                  experienciaList = snapshot.data!['usuario']['experiencia'];

                  for (var i = 0; i < experienciaList.length; i++) {
                    expInicial = Experiencia(
                        id: experienciaList[i]['_id'],
                        titulo: experienciaList[i]['titulo'],
                        empresa: experienciaList[i]['empresa'],
                        fechaInicio:
                            DateTime.parse(experienciaList[i]['fechaInicio']),
                        fechaFin: experienciaList[i]['fechaFin'],
                        descripcion: experienciaList[i]['descripcion']);

                    experienciaParaWidget.add(expInicial);
                  }

                  for (var item in experienciaParaWidget) {
                    if (item.id == result &&
                        _tituloExperienciaController.text.toString().isEmpty) {
                      _tituloExperienciaController.text = item.titulo;
                      _inicioExperienciaController.text =
                          DateFormat('yyyy-MM-dd').format(item.fechaInicio);
                      _empresaExperienciaController.text = item.empresa;
                      _finExperienciaController.text = item.fechaFin;
                      _descripcionExperienciaController.text = item.descripcion;
                    }
                  }

                  return Column(
                    children: [_formEditExperiencia()],
                  );
                } else {
                  print("no hay datos ");
                  return Center(
                    child: Container(
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Column(
                          children: const [
                            SizedBox(height: 45.0),
                            Text(
                              "Sin experiencias laborales",
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(53, 80, 112, 2.0),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            FadeInImage(
                              placeholder:
                                  AssetImage('assets/img/buscando.png'),
                              image: AssetImage('assets/img/buscando.png'),
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 15.0),
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

  _formEditExperiencia() {
    return Column(
      children: [
        Column(
          children: <Widget>[
            TextField(
              controller: _tituloExperienciaController,
              decoration: const InputDecoration(
                icon: Icon(Icons.title),
                labelText: 'Titulo',
              ),
            ),
            _crearFecha(context),
            TextField(
              controller: _empresaExperienciaController,
              decoration: const InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Empresa',
              ),
            ),
            _switchListTrabajoActual(),
            (_blouearCheck == false) ? _crearFechaFin(context) : Container(),
            TextField(
              controller: _descripcionExperienciaController,
              decoration: const InputDecoration(
                icon: Icon(Icons.description),
                labelText: 'Descripción',
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Color.fromRGBO(29, 53, 87, 1.0),
            ),
          ),
          onPressed: () async {
            for (var i = 0; i < experienciaList.length; i++) {
              if (experienciaList[i].toString().contains(result)) {
                experienciaList.remove(experienciaList[i]);
              }
            }

            experienciaParaWidget = [];

            for (var i = 0; i < experienciaList.length; i++) {}

            for (var i = 0; i < experienciaList.length; i++) {
              expEliminada = Experiencia(
                  id: experienciaList[i]['_id'],
                  titulo: experienciaList[i]['titulo'],
                  empresa: experienciaList[i]['empresa'],
                  fechaInicio: DateTime.parse(
                      experienciaList[i]['fechaInicio'].toString()),
                  fechaFin: experienciaList[i]['fechaFin'],
                  descripcion: experienciaList[i]['descripcion']);

              experienciaParaWidget.add(expEliminada);
            }

            expEliminadaNuevamenteAgregada = Experiencia(
                id: result,
                titulo: _tituloExperienciaController.text.toString(),
                empresa: _empresaExperienciaController.text.toString(),
                fechaInicio: DateTime.parse(
                    _inicioExperienciaController.text.toString()),
                fechaFin: _finExperienciaController.text.toString(),
                descripcion: _descripcionExperienciaController.text.toString());

            experienciaParaWidget.add(expEliminadaNuevamenteAgregada);

            user.experiencia = experienciaParaWidget;

            final respuesta =
                await perfilBloc.editarExperienciaDelUsuario(user);

            setState(() {
              _tituloExperienciaController.clear();
              _empresaExperienciaController.clear();
              _inicioExperienciaController.clear();
              _finExperienciaController.clear();
              _descripcionExperienciaController.clear();
            });
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, 'listarexperiencia');
          },
          child: const Text(
            "Añadir Experiencia",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  _switchListTrabajoActual() {
    return SwitchListTile(
        value: _blouearCheck,
        title: const Text('Trabajo Actual'),
        onChanged: (value) => {
              setState(() {
                _finExperienciaController.text = '';
                _blouearCheck = value;
                if (_blouearCheck) {
                  _finExperienciaController.text = 'Trabajo Actual';
                } else {
                  _finExperienciaController.text = '';
                }
              })
            });
  }

  _crearFecha(BuildContext context) {
    return TextFormField(
      controller: _inicioExperienciaController,
      enableInteractiveSelection: false,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_month),
        labelText: 'Fecha Inicio',
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selectDate(context);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Ingrese la fecha de inicio';
        } else {
          return null;
        }
      },
    );
  }

  _crearFechaFin(BuildContext context) {
    return TextFormField(
      controller: _finExperienciaController,
      enableInteractiveSelection: false,
      decoration: const InputDecoration(
        icon: Icon(Icons.calendar_month),
        labelText: 'Fecha Final',
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selectDateFinal(context);
      },
      validator: (value) {
        if (value!.isEmpty) {
          return 'Ingrese la fecha final';
        } else {
          return null;
        }
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        locale: const Locale('es', 'ES'));

    if (picked != null) {
      String fechaFormateada = DateFormat('yyyy-MM-dd').format(picked);
      if (mounted) {
        setState(() {
          _fecha = fechaFormateada;
          _inicioExperienciaController.text = _fecha;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _inicioExperienciaController.text = _fechaActual(tiempo);
        });
      }
    }
  }

  _selectDateFinal(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        locale: const Locale('es', 'ES'));

    if (picked != null) {
      String fechaFormateada = DateFormat('yyyy-MM-dd').format(picked);
      if (mounted) {
        setState(() {
          _fecha = fechaFormateada;
          _finExperienciaController.text = _fecha;
          //visitaModel.fecha = picked;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _finExperienciaController.text = _fechaActual(tiempo);
        });
      }
    }
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

  String _fechaActual(DateTime fecha) {
    String fechaFormateada = DateFormat('yyyy-MM-dd').format(fecha);
    return fechaFormateada;
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
