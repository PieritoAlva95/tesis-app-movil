import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/perfil_bloc.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/estudios.model.dart';
import 'package:jobsapp/models/experiencia.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/switch.list.tile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class EditEstuPage extends StatefulWidget {
  const EditEstuPage({Key? key}) : super(key: key);

  @override
  _EditEstuPageState createState() => _EditEstuPageState();
}

class _EditEstuPageState extends State<EditEstuPage> {
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
  String _fecha = '';
  DateTime tiempo = DateTime.now();

  Estudio expInicial = Estudio(fechaInicio: DateTime.now());
  Estudio exp = Estudio(fechaInicio: DateTime.now());
  Estudio expEliminada = Estudio(fechaInicio: DateTime.now());
  Estudio expEliminadaNuevamenteAgregada = Estudio(fechaInicio: DateTime.now());

  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _blouearCheck = false;
  final String _callBackParams = '';

  bool circularProgress = false;
  PerfilBloc perfilBloc = PerfilBloc();
  final usuarioProvider = UsuariosProvider();
  final preferencias = PreferenciasUsuario();
  EstudioClass user = EstudioClass(estudios: []);

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
    print('Final Elegida $result');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Estudio'),
      ),
      //drawer: MenuWidget(),
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
                  experienciaList = snapshot.data!['usuario']['estudios'];
                  print(snapshot.data!['usuario']['estudios']);
                  for (var i = 0; i < experienciaList.length; i++) {
                    expInicial = Estudio(
                      id: experienciaList[i]['_id'],
                      titulo: experienciaList[i]['titulo'],
                      nombreInstitucion: experienciaList[i]
                          ['nombreInstitucion'],
                      fechaInicio:
                          DateTime.parse(experienciaList[i]['fechaInicio']),
                      fechaFin: experienciaList[i]['fechaFin'],
                      descripcion: experienciaList[i]['descripcion'],
                    );
                    experienciaParaWidget.add(expInicial);
                  }

                  for (var item in experienciaParaWidget) {
                    if (item.id == result &&
                        _tituloExperienciaController.text.toString().isEmpty) {
                      _tituloExperienciaController.text = item.titulo;
                      _inicioExperienciaController.text =
                          DateFormat('yyyy-MM-dd').format(item.fechaInicio);
                      _empresaExperienciaController.text =
                          item.nombreInstitucion;
                      _finExperienciaController.text = item.fechaFin;
                      _descripcionExperienciaController.text = item.descripcion;
                    }
                  }

                  return Column(
                    children: [
                      _formEditExperiencia(),
                    ],
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
                              "Sin estudios",
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

  String? get _errorTextEmpresaExperiencia {
    final text = _empresaExperienciaController.text;

    if (text.isEmpty) {
      return 'Ingresa el nombre de la instituciòn!';
    }
    return null;
  }

  String? get _errorTextTituloExperiencia {
    final text = _tituloExperienciaController.text;

    if (text.isEmpty) {
      return 'Ingresa el título!';
    }
    return null;
  }

  String? get _errorTextDescripcionExperiencia {
    final text = _descripcionExperienciaController.text;

    if (text.isEmpty) {
      return 'Ingresa la descripción!';
    }
    return null;
  }

  _formEditExperiencia() {
    return Column(
      children: [
        Column(
          children: <Widget>[
            TextField(
              controller: _tituloExperienciaController,
              decoration: InputDecoration(
                  icon: Icon(Icons.title),
                  labelText: 'Titulo',
                  errorText: _errorTextTituloExperiencia),
              onChanged: (text) {
                setState(() => text);
              },
            ),
            _crearFecha(context),
            TextField(
              controller: _empresaExperienciaController,
              decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'Empresa',
                  errorText: _errorTextEmpresaExperiencia),
              onChanged: (text) {
                setState(() => text);
              },
            ),
            _switchListTrabajoActual(),
            (_blouearCheck == false) ? _crearFechaFin(context) : Container(),
            TextField(
              controller: _descripcionExperienciaController,
              decoration: InputDecoration(
                  icon: Icon(Icons.description),
                  labelText: 'Descripción',
                  errorText: _errorTextDescripcionExperiencia),
              onChanged: (text) {
                setState(() => text);
                //print('First text field: $text');
              },
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        DialogButton(
          onPressed: () async {
            if (_tituloExperienciaController.text.isEmpty ||
                _empresaExperienciaController.text.isEmpty ||
                _inicioExperienciaController.text.isEmpty ||
                _finExperienciaController.text.isEmpty ||
                _descripcionExperienciaController.text.isEmpty) {
              mostrarSnackBar('Debe completar todos los campos');
              return;
            }

            for (var i = 0; i < experienciaList.length; i++) {
              if (experienciaList[i].toString().contains(result)) {
                experienciaList.remove(experienciaList[i]);
              }
            }
            experienciaParaWidget = [];

            for (var i = 0; i < experienciaList.length; i++) {
              expEliminada = Estudio(
                id: experienciaList[i]['_id'],
                titulo: experienciaList[i]['titulo'],
                nombreInstitucion: experienciaList[i]['nombreInstitucion'],
                fechaInicio: DateTime.parse(
                    experienciaList[i]['fechaInicio'].toString()),
                fechaFin: experienciaList[i]['fechaFin'],
                descripcion: experienciaList[i]['descripcion'],
              );
              experienciaParaWidget.add(expEliminada);
            }

            expEliminadaNuevamenteAgregada = Estudio(
              id: result,
              titulo: _tituloExperienciaController.text.toString(),
              nombreInstitucion: _empresaExperienciaController.text.toString(),
              fechaInicio: DateTime.parse(
                _inicioExperienciaController.text.toString(),
              ),
              fechaFin: _finExperienciaController.text.toString(),
              descripcion: _descripcionExperienciaController.text.toString(),
            );

            experienciaParaWidget.add(expEliminadaNuevamenteAgregada);

            user.estudios = experienciaParaWidget;
            for (var item in experienciaParaWidget) {
              print('CAMPOS: ${item.id}');
            }

            final respuesta = await perfilBloc.editarEstudioDelUsuario(user);
            print('Respuesta: $respuesta');

            setState(() {
              _tituloExperienciaController.clear();
              _empresaExperienciaController.clear();
              _inicioExperienciaController.clear();
              _finExperienciaController.clear();
              _descripcionExperienciaController.clear();
            });
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, 'listarestudio');
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
      title: const Text('Estudio Actual'),
      onChanged: (value) => {
        setState(
          () {
            _finExperienciaController.text = '';
            _blouearCheck = value;
            if (_blouearCheck) {
              _finExperienciaController.text = 'Estudio Actual';
            } else {
              _finExperienciaController.text = '';
            }
            print('Selected ${_finExperienciaController.text}');
          },
        )
      },
    );
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
        setState(
          () {
            _fecha = fechaFormateada;
            _inicioExperienciaController.text = _fecha;
          },
        );
      }
    } else {
      if (mounted) {
        setState(
          () {
            _inicioExperienciaController.text = _fechaActual(tiempo);
          },
        );
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
        setState(
          () {
            _fecha = fechaFormateada;
            _finExperienciaController.text = _fecha;
          },
        );
      }
    } else {
      if (mounted) {
        setState(
          () {
            _finExperienciaController.text = _fechaActual(tiempo);
          },
        );
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
