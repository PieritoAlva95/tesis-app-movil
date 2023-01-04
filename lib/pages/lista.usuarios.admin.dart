import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobsapp/pages/login.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/utils.dart';
import 'package:jobsapp/widgets/menu_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UsuariosAdministrador extends StatefulWidget {
  const UsuariosAdministrador({Key? key}) : super(key: key);

  @override
  _UsuariosAdministradorState createState() => _UsuariosAdministradorState();
}

class _UsuariosAdministradorState extends State<UsuariosAdministrador> {
  final estiloTitulo = const TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
  );
  final estiloSubTitulo = const TextStyle(
    fontSize: 13.0,
    color: Colors.black,
  );
  late ScrollController _scrollController;
  final preferenciaToken = PreferenciasUsuario();
  bool estadoDelUsuario = false;
  bool esAdministrador = false;
  List<dynamic> listadoDeUsuarios = [];
  int _total = 0;
  final String _url = URLFOTO;
  final usuariosProvider = UsuariosProvider();
  bool estaLogueado = false;
  Future<void> verificarToken() async {
    bool verify = await usuariosProvider.verificarToken();
    if (verify) {
      estaLogueado = false;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage(),
          ),
          (Route<dynamic> route) => false);
    } else {
      estaLogueado = true;
      print('Token válido ${preferenciaToken.token}');
    }
  }

  @override
  void initState() {
    super.initState();
    verificarToken();
    _scrollController = ScrollController();
    obtener6();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          obtener6();
          print('AdminUsers: ${listadoDeUsuarios.length}');
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    listadoDeUsuarios.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Usuarios'),
      ),
      //drawer: MenuWidget(),
      body: (listadoDeUsuarios.isNotEmpty)
          ? RefreshIndicator(
              onRefresh: obtenerPrimerosRegistros,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: listadoDeUsuarios.length,
                itemBuilder: (context, index) {
                  return _crearItemContrato(
                    context,
                    listadoDeUsuarios,
                    index,
                  );
                },
              ),
            )
          : Center(
              child: Container(
                color: Colors.transparent,
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      SizedBox(height: 45.0),
                      Text(
                        "No hay información. Por favor espera...",
                        style: TextStyle(
                          fontSize: 19.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(53, 80, 112, 1.0),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      FadeInImage(
                        placeholder: AssetImage('assets/img/buscando.png'),
                        image: AssetImage('assets/img/buscando.png'),
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ),
            ),
      drawer: preferenciaToken.token.toString().isNotEmpty
          ? const MenuWidget()
          : null,
    );
  }

  _crearBotonAgregarOferta(BuildContext context) {
    return TextButton(
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 40.0,
      ),
      onPressed: () => Navigator.pushNamed(
        context,
        'crearoferta',
      ),
    );
  }

  _crearItemContrato(
      BuildContext context, List<dynamic> listadoDeUsuarios, int index) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          _crearTitulo(context, listadoDeUsuarios, index),
        ],
      ),
    );
  }

  _crearTitulo(
      BuildContext context, List<dynamic> listadoDeUsuarios, int index) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10.0,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      listadoDeUsuarios[index][index]['img']
                              .toString()
                              .isNotEmpty
                          ? Image.network(
                              _url + listadoDeUsuarios[index][index]['img'],
                              width: 120.0,
                              height: 120.0,
                            )
                          : Image.network(
                              urlPhotoUserNotFound,
                              width: 120.0,
                              height: 120.0,
                            ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Nombres: ',
                            style: estiloTitulo,
                          ),
                          Text(
                            listadoDeUsuarios[index][index]['nombres']
                                .toString(),
                            textAlign: TextAlign.justify,
                            style: estiloSubTitulo,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Apellidos: ',
                            style: estiloTitulo,
                          ),
                          Text(
                            listadoDeUsuarios[index][index]['apellidos']
                                .toString(),
                            style: estiloSubTitulo,
                          ),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Email: ',
                        style: estiloTitulo,
                      ),
                      Text(
                        listadoDeUsuarios[index][index]['email'].toString(),
                        style: estiloSubTitulo,
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          /*Text(
                            'Estado: ',
                            style: estiloTitulo,
                          ),*/
                          ElevatedButton(
                            child: Container(
                              child: listadoDeUsuarios[index][index]['activo']
                                  ? const Text('Desactivar')
                                  : const Text('Activar'),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              elevation: const MaterialStatePropertyAll(10.0),
                              backgroundColor: MaterialStatePropertyAll(
                                listadoDeUsuarios[index][index]['activo']
                                    ? Colors.red
                                    : const Color.fromRGBO(53, 80, 112, 2.0),
                              ),
                              foregroundColor: const MaterialStatePropertyAll(
                                Colors.white,
                              ),
                            ),
                            onPressed: () {
                              estadoDelUsuario =
                                  listadoDeUsuarios[index][index]['activo'];
                              esAdministrador =
                                  listadoDeUsuarios[index][index]['esAdmin'];
                              if (estadoDelUsuario) {
                                estadoDelUsuario = false;
                                usuariosProvider.editarEstadoDelUsuario(
                                  estadoDelUsuario,
                                  esAdministrador,
                                  listadoDeUsuarios[index][index]['uid'],
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  'usuariosadmin',
                                );
                              }
                              if (estadoDelUsuario == false) {
                                estadoDelUsuario = true;
                                usuariosProvider.editarEstadoDelUsuario(
                                  estadoDelUsuario,
                                  esAdministrador,
                                  listadoDeUsuarios[index][index]['uid'],
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  'usuariosadmin',
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          /*Text(
                            'Tipo Usuario: ',
                            style: estiloTitulo,
                          ),*/
                          ElevatedButton(
                            child: Container(
                              child: listadoDeUsuarios[index][index]['esAdmin']
                                  ? Text(
                                      'Administrador',
                                      style: TextStyle(
                                          color: listadoDeUsuarios[index][index]
                                                  ['esAdmin']
                                              ? Colors.white
                                              : Colors.black),
                                    )
                                  : Text(
                                      'Usuario',
                                      style: TextStyle(
                                          color: listadoDeUsuarios[index][index]
                                                  ['esAdmin']
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              elevation: const MaterialStatePropertyAll(10.0),
                              backgroundColor: MaterialStatePropertyAll(
                                !listadoDeUsuarios[index][index]['esAdmin']
                                    ? Colors.yellow
                                    : const Color.fromRGBO(53, 80, 112, 2.0),
                              ),
                              // textColor: Colors.white,
                              foregroundColor: const MaterialStatePropertyAll(
                                Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Alert(
                                context: context,
                                title: listadoDeUsuarios[index][index]
                                        ['esAdmin']
                                    ? "¿Desea quitarle el permiso de ADMINISTRADOR a este usuario?"
                                    : '¿Está seguro de convertir en ADMINISTRADOR a este usuario?',
                                content: Column(
                                  children: const <Widget>[],
                                ),
                                buttons: [
                                  DialogButton(
                                    onPressed: () async {
                                      estadoDelUsuario =
                                          listadoDeUsuarios[index][index]
                                              ['activo'];
                                      esAdministrador = listadoDeUsuarios[index]
                                          [index]['esAdmin'];
                                      if (esAdministrador) {
                                        esAdministrador = false;
                                        usuariosProvider.editarEstadoDelUsuario(
                                          estadoDelUsuario,
                                          esAdministrador,
                                          listadoDeUsuarios[index][index]
                                              ['uid'],
                                        );
                                        Navigator.pushReplacementNamed(
                                          context,
                                          'usuariosadmin',
                                        );
                                      }
                                      if (esAdministrador == false) {
                                        esAdministrador = true;
                                        usuariosProvider.editarEstadoDelUsuario(
                                          estadoDelUsuario,
                                          esAdministrador,
                                          listadoDeUsuarios[index][index]
                                              ['uid'],
                                        );
                                        Navigator.pushReplacementNamed(
                                          context,
                                          'usuariosadmin',
                                        );
                                      }
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
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text(
                                      "Cancelar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ).show();
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  fetchData() async {
    final uid = preferenciaToken.idUsuario;
    print(uid);
    final response = await http.get(
      Uri.parse('$URLBASE/api/usuarios/obtener/usuarios/${uid}'),
      headers: {"Content-Type": "application/json"},
    );
    print('Datods: ${json.decode(response.body).length}');

    if (response.statusCode == 200) {
      if (mounted) {
        setState(
          () {
            _total = json.decode(response.body).length;
            if (listadoDeUsuarios.length < _total) {
              listadoDeUsuarios.add(json.decode(response.body));
            } else {
              return;
            }
          },
        );
      }
    } else {
      return false;
    }
  }

  obtener6() {
    for (var i = 0; i < 6; i++) {
      if (listadoDeUsuarios.length <= _total) {
        fetchData();
        print(i);
      } else {
        return;
      }
    }
    print('AdminUsers: ${listadoDeUsuarios.length}');
  }

  Future<void> obtenerPrimerosRegistros() async {
    const duration = Duration(seconds: 2);
    Timer(
      duration,
      () {
        listadoDeUsuarios.clear();
        _total = 0;
        obtener6();
      },
    );
    return Future.delayed(duration);
  }
}
