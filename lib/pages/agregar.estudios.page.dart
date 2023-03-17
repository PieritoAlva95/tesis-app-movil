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

class AgregarEstudiosPage extends StatefulWidget {
  const AgregarEstudiosPage({Key? key}) : super(key: key);

  @override
  _AgregarEstudiosPageState createState() => _AgregarEstudiosPageState();
}

class _AgregarEstudiosPageState extends State<AgregarEstudiosPage> {
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

  @override
  Widget build(BuildContext context) {
    perfilBloc = Provider.perfilBloc(context)!;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Añadir Estudio'),
        ),
        //drawer: MenuWidget(),
        body: SingleChildScrollView(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
                  if (snapshot.hasData && snapshot.data!['usuario'] != null) {
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
                          descripcion: experienciaList[i]['descripcion']);

                      experienciaParaWidget.add(expInicial);
                    }

                    for (var item in experienciaParaWidget) {
                      print(item.titulo);
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
                                SizedBox(
                                  height: 45.0,
                                ),
                                Text("Sin experiencias laborales",
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromRGBO(53, 80, 112, 2.0))),
                                SizedBox(
                                  height: 30.0,
                                ),
                                FadeInImage(
                                  placeholder:
                                      AssetImage('assets/img/buscando.png'),
                                  image: AssetImage('assets/img/buscando.png'),
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                              ],
                            ),
                          )),
                    );
                  }
                },
              ),
            ],
          ),
        ));
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
              controller: _empresaExperienciaController,
              decoration: InputDecoration(
                  icon: Icon(Icons.account_circle),
                  labelText: 'Institución',
                  errorText: _errorTextEmpresaExperiencia),
              onChanged: (text) {
                setState(() => text);
                //print('First text field: $text');
              },
            ),
            TextField(
              controller: _tituloExperienciaController,
              decoration: InputDecoration(
                  icon: Icon(Icons.title),
                  labelText: 'Titulo',
                  errorText: _errorTextTituloExperiencia),
              onChanged: (text) {
                setState(() => text);
                //print('First text field: $text');
              },
            ),

            //PASAR A UN NUEVO ARCHIVO PARA EDITAR Y AGREGAR DATOS
            _crearFecha(context),

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
        const SizedBox(
          height: 20.0,
        ),
        ElevatedButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(
              Color.fromRGBO(29, 53, 87, 1.0),
            ),
          ),
          onPressed: () async {
            if (_tituloExperienciaController.text.isEmpty ||
                _empresaExperienciaController.text.isEmpty ||
                _inicioExperienciaController.text.isEmpty ||
                _finExperienciaController.text.isEmpty ||
                _descripcionExperienciaController.text.isEmpty) {
              mostrarSnackBar('Debe completar todos los campos');
              return;
            }

            exp = Estudio(
                id: uuid.v1().toString().replaceAll('-', '').substring(0, 24),
                titulo: _tituloExperienciaController.text.toString(),
                nombreInstitucion:
                    _empresaExperienciaController.text.toString(),
                fechaInicio: DateTime.parse(
                    _inicioExperienciaController.text.toString()),
                fechaFin: _finExperienciaController.text.toString(),
                descripcion: _descripcionExperienciaController.text.toString());

            experienciaParaWidget.add(exp);

            user.estudios = experienciaParaWidget;
            for (var item in user.estudios) {
              print('CAMPOS: ${item}');
            }

            final respuesta = await perfilBloc.editarEstudioDelUsuario(user);
            print('Respuesta: ${respuesta}');
            experienciaParaWidget = [];
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
            "Añadir Estudio",
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
              setState(() {
                _finExperienciaController.text = '';
                _blouearCheck = value;
                if (_blouearCheck) {
                  _finExperienciaController.text = 'Estudio Actual';
                } else {
                  _finExperienciaController.text = '';
                }

                print('Selected ${_finExperienciaController.text}');
              })
            });
  }

  _crearCheckBox() {
    return Row(
      children: [
        Checkbox(
            value: _blouearCheck,
            onChanged: (value) {
              if (mounted) {
                setState(() {
                  _blouearCheck = value!;
                  _fecha = DateTime.now().toString();
                  _inicioExperienciaController.text = DateTime.now().toString();
                });
              }
            }),
        const Text('Estudio Actual')
      ],
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
        locale: Locale('es', 'ES'));

    if (picked != null) {
      String fechaFormateada = DateFormat('yyyy-MM-dd').format(picked);
      if (mounted) {
        setState(() {
          _fecha = fechaFormateada;
          _inicioExperienciaController.text = _fecha;
          //visitaModel.fecha = picked;
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
        locale: Locale('es', 'ES'));

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

Widget _buildSwitchListTile(String title, String description, bool currentValue,
    Function(bool) updateValue) {
  return SwitchListTile(
    title: Text(title),
    value: currentValue,
    subtitle: Text(
      description,
    ),
    onChanged: updateValue, // changed from (value) => updateValue
  );
}
