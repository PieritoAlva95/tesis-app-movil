import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/oferta.bloc.dart';
import 'package:jobsapp/bloc/perfil_bloc.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/ofert.model.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class PostularOferta extends StatefulWidget {
  const PostularOferta({Key? key}) : super(key: key);

  @override
  _PostularOfertaState createState() => _PostularOfertaState();
}

class _PostularOfertaState extends State<PostularOferta> {
  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool circularProgress = false;
  OfertaBloc ofertaBloc = OfertaBloc();
  PerfilBloc usuarioBloc = PerfilBloc();
  final preferencias = PreferenciasUsuario();

  String id = '';
  String result = '';
  var uuid = const Uuid();
  Map<String, dynamic> dataUsuarioPostulante = {};

  //DropDown
  final List<String> _tipoPago = [
    'Mensual',
    'Quincenal',
    'Semanal',
    'Por Hora',
    'Contrato'
  ];
  String opcionDePagoSeleccionada = "Contrato";
  String opcionDeCategoriaSeleccionada = "Otros";
  Oferta oferta = Oferta(fechaCreacion: DateTime.now(), interesados: []);

  @override
  void initState() {
    super.initState();
    oferta.usuario = preferencias.idUsuario;
    oferta.nombreUsuario = preferencias.nombres;
  }

  @override
  Widget build(BuildContext context) {
    ofertaBloc = Provider.ofertaBloc(context)!;

    final contratoObtenido = ModalRoute.of(context)!.settings.arguments;
    final primero = contratoObtenido.toString().replaceFirst('{', '');
    final pos = primero.length - 1;
    result = primero.substring(0, pos);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Postulación'),
      ),
      key: scaffoldKey,
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          children: [
            FutureBuilder(
              future: ofertaBloc.cargarOfertaEspecifica(result),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasError) {
                  print("eroro: " + snapshot.hasError.toString());
                }
                if (snapshot.hasData && snapshot.data!['oferta'] != null) {
                  oferta.titulo = snapshot.data!['oferta']['titulo'];
                  oferta.cuerpo = snapshot.data!['oferta']['cuerpo'];
                  oferta.precio = snapshot.data!['oferta']['precio'].toString();
                  oferta.tipoPago = snapshot.data!['oferta']['tipoPago'];
                  oferta.categoria = snapshot.data!['oferta']['categoria'];
                  oferta.usuario = snapshot.data!['oferta']['usuario'];
                  oferta.nombreUsuario =
                      snapshot.data!['oferta']['nombreUsuario'];
                  oferta.fechaCreacion =
                      DateTime.parse(snapshot.data!['oferta']['fechaCreacion']);

                  opcionDeCategoriaSeleccionada =
                      snapshot.data!['oferta']['categoria'];
                  opcionDePagoSeleccionada =
                      snapshot.data!['oferta']['tipoPago'];
                  oferta.interesados = snapshot.data!['oferta']['interesados'];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _usuarioObtenidoArrendador(),
                      _title(),
                      const SizedBox(height: 15.0),
                      _autorDeLaPublicacion(),
                      const SizedBox(height: 15.0),
                      const Text(
                        'Descripción: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Color.fromRGBO(53, 80, 112, 2.0),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        oferta.cuerpo,
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 15.0),
                      _fechaDeCreacionDeOferta(),
                      const SizedBox(height: 15.0),
                      _categoria(),
                      const SizedBox(height: 15.0),
                      _salario(),
                      const SizedBox(height: 15.0),
                      _tipoDePago(),
                      const SizedBox(height: 20),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              // color: Color.fromRGBO(53, 80, 112, 1.0),
                              backgroundColor: const MaterialStatePropertyAll(
                                Color.fromRGBO(53, 80, 112, 1.0),
                              ),
                            ),
                            onPressed: () async {
                              Alert(
                                  context: context,
                                  title: 'Título de la oferta laboral:',
                                  content: Column(
                                    children: <Widget>[
                                      Column(
                                        children: [
                                          Text(oferta.titulo),
                                          const SizedBox(height: 15.0),
                                          const Text(
                                            '¿Desea postularse a esta oferta?',
                                            style: TextStyle(fontSize: 16.0),
                                          ),
                                          const SizedBox(height: 15.0),
                                        ],
                                      )
                                    ],
                                  ),
                                  buttons: [
                                    DialogButton(
                                      onPressed: () async {
                                        if (preferencias.token
                                            .toString()
                                            .isEmpty) {
                                          mostrarSnackBar(
                                              'No puede postularse, debe iniciar seisión.');
                                          return;
                                        }

                                        final map = {
                                          'nombres': dataUsuarioPostulante[
                                                  'usuario']['nombres'] +
                                              dataUsuarioPostulante['usuario']
                                                  ['apellidos'],
                                          'aceptado': false,
                                          '_id': uuid
                                              .v1()
                                              .toString()
                                              .replaceAll('-', '')
                                              .substring(0, 24),
                                          'fechaPostulacion':
                                              DateTime.now().toString(),
                                          'postulante':
                                              dataUsuarioPostulante['usuario']
                                                  ['uid'],
                                          'foto':
                                              dataUsuarioPostulante['usuario']
                                                  ['foto'],
                                        };
                                        if (!oferta.interesados
                                            .toString()
                                            .contains(
                                              map['postulante'].toString(),
                                            )) {
                                          oferta.interesados.add(map);
                                          Navigator.pop(context);
                                          mostrarSnackBar(
                                              'Su postulación se ha realizado correctamente');

                                          final respuesta = await ofertaBloc
                                              .editarPostulanteOferta(
                                            oferta,
                                            result,
                                          );
                                          Navigator.pushReplacementNamed(
                                            context,
                                            'home',
                                          );
                                        } else {
                                          mostrarAlerta(context,
                                              'Sr. usuario ya se ha postulado a esta oferta');
                                        }
                                      },
                                      child: const Text(
                                        "Postular",
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
                                  ]).show();
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Postular',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              backgroundColor: const MaterialStatePropertyAll(
                                Color.fromRGBO(53, 80, 112, 1.0),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                ),
                                Text(
                                  ' Cancelar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
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
                              "No hay información de la oferta laboral",
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(53, 80, 112, 1.0),
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

  Widget fadeAlertAnimation(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Align(
      child: FadeTransition(
        opacity: animation,
        child: child,
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

  _usuarioObtenidoArrendador() {
    return FutureBuilder(
        future: usuarioBloc.cargarUsuarioEspecifico(preferencias.idUsuario),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            dataUsuarioPostulante = snapshot.data!;
            return Container();
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  _title() {
    return Row(
      children: [
        const Text(
          'Titulo: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            color: Color.fromRGBO(53, 80, 112, 2.0),
          ),
        ),
        Text(
          oferta.titulo,
          style: const TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(53, 80, 112, 2.0),
          ),
        )
      ],
    );
  }

  _autorDeLaPublicacion() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'verperfil', arguments: {oferta.usuario});
      },
      child: Row(
        children: [
          const Text(
            'Pulicado por: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Color.fromRGBO(53, 80, 112, 2.0),
            ),
          ),
          Text(oferta.nombreUsuario),
        ],
      ),
    );
  }

  _cuerpo() {
    return Row(
      children: [
        const Text(
          'Descripción: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            color: Color.fromRGBO(53, 80, 112, 2.0),
          ),
        ),
        SizedBox(
          width: 280,
          child: Text(
            oferta.cuerpo,
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  _fechaDeCreacionDeOferta() {
    return Row(
      children: [
        const Text(
          'Creado: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            color: Color.fromRGBO(53, 80, 112, 2.0),
          ),
        ),
        Text(
          timeago.format(oferta.fechaCreacion, locale: 'es'),
        ),
      ],
    );
  }

  _tipoDePago() {
    return Row(
      children: [
        const Text(
          'Tipo de pago: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            color: Color.fromRGBO(53, 80, 112, 2.0),
          ),
        ),
        Text(oferta.tipoPago.toString()),
      ],
    );
  }

  _categoria() {
    return Row(
      children: [
        const Text(
          'Categoría: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            color: Color.fromRGBO(53, 80, 112, 2.0),
          ),
          textAlign: TextAlign.justify,
        ),
        Text(oferta.categoria.toString()),
      ],
    );
  }

  _salario() {
    return Row(
      children: [
        const Text(
          'Salario (USD): ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            color: Color.fromRGBO(53, 80, 112, 2.0),
          ),
        ),
        Text(oferta.precio.toString()),
      ],
    );
  }
}
