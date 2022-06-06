import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/oferta.bloc.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/ofert.model.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:timeago/timeago.dart' as timeago;

class VerEditarOerta extends StatefulWidget {
  @override
  _VerEditarOertaState createState() => _VerEditarOertaState();
}

class _VerEditarOertaState extends State<VerEditarOerta> {
  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool circularProgress = false;
  OfertaBloc ofertaBloc = OfertaBloc();
  final preferencias = PreferenciasUsuario();

  String id = '';
  String result = '';

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
    // TODO: implement initState
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
        title: Text('Oferta'),
      ),
      key: scaffoldKey,
      //drawer: MenuWidget(),
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
                  oferta.fechaCreacion =
                      DateTime.parse(snapshot.data!['oferta']['fechaCreacion']);

                  opcionDeCategoriaSeleccionada =
                      snapshot.data!['oferta']['categoria'];
                  opcionDePagoSeleccionada =
                      snapshot.data!['oferta']['tipoPago'];
                  oferta.interesados = snapshot.data!['oferta']['interesados'];

                  return Column(
                    children: [
                      _title(),
                      SizedBox(
                        height: 15.0,
                      ),
                      _autorDeLaPublicacion(),
                      SizedBox(
                        height: 15.0,
                      ),
                      _cuerpo(),
                      SizedBox(
                        height: 15.0,
                      ),
                      _fechaDeCreacionDeOferta(),
                      SizedBox(
                        height: 15.0,
                      ),
                      _categoria(),
                      SizedBox(
                        height: 15.0,
                      ),
                      _salario(),
                      SizedBox(
                        height: 15.0,
                      ),
                      _tipoDePago(),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      Text(
                        'Personas que estan postulando',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0,
                            color: Color.fromRGBO(53, 80, 112, 2.0)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _recorrerPostulaciones(oferta)
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
                              SizedBox(
                                height: 45.0,
                              ),
                              Text("No hay información la oferta laboral",
                                  style: TextStyle(
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(29, 53, 87, 1.0))),
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
      ),
    );
  }

  _recorrerPostulaciones(Oferta oferta) {
    return Column(
        children: oferta.interesados
            .map<Widget>((interesado) => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.person),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                print(interesado['postulante']);
                                Navigator.pushNamed(context, 'verperfil',
                                    arguments: {interesado['postulante']});
                              },
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    interesado['nombres'],
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                  width: 100.0),
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Información de contacto',
                                  style: TextStyle(
                                      color: Color.fromRGBO(29, 53, 87, 1.0),
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: RaisedButton(
                            color: Color.fromRGBO(53, 80, 112, 1.0),
                            onPressed: () async {



            Alert(
            context: context,
            title: "Esta seguro de convertir en ADMINISTRADOR a este usuario?",
            content: Column(
              children: <Widget>[
                SizedBox(height: 15.0,),
                    Text(interesado['nombres'],style: TextStyle(fontSize: 16.0),),
                    SizedBox(height: 15.0,),
              ],
            ),
            buttons: [
              DialogButton(
                onPressed: () async {
                  
                  
                  
                              oferta.interesados = [];

                              interesado['aceptado'] = true;
                              oferta.disponible = 'con contrato';

                              final map = [
                                {
                                  'nombres': interesado['nombres'],
                                  'aceptado': interesado['aceptado'],
                                  '_id': interesado['_id'],
                                  'fechaPostulacion':
                                      interesado['fechaPostulacion'].toString(),
                                  'postulante': interesado['postulante'],
                                  'foto': interesado['foto'],
                                }
                              ];
                              oferta.interesados = map;
                              final respuesta =
                                  await ofertaBloc.editarOferta(oferta, result);
                              Navigator.pushReplacementNamed(
                                  context, 'dashboard');

                },
                child: Text(
                  "Aceptar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              DialogButton(
                color: Colors.grey,
                    onPressed: () => Navigator.of(context).pop(),
                     child: Text(
                     "Cancelar",
                      style: TextStyle(
                      color: Colors.white, fontSize: 20),
                       ),
                       ),
            ]).show();





                            },
                            child: Text(
                              'Contratar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ))
            .toList());
  }

  _title() {
    return Row(
      children: [
        Text(
          'Titulo: ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              color: Color.fromRGBO(53, 80, 112, 2.0)),
        ),
        Text(
          oferta.titulo,
          style: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(53, 80, 112, 2.0)),
        )
      ],
    );
  }

  _autorDeLaPublicacion() {
    return Row(
      children: [
        Text(
          'Pulicado por: ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Color.fromRGBO(53, 80, 112, 2.0)),
        ),
        Text(oferta.nombreUsuario),
      ],
    );
  }

  _cuerpo() {
    return Row(
      children: [
        Text(
          'Descripción: ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Color.fromRGBO(53, 80, 112, 2.0)),
        ),
        Container(
            width: 220,
            child: Text(
              oferta.cuerpo,
              textAlign: TextAlign.justify,
            )),
      ],
    );
  }

  _fechaDeCreacionDeOferta() {
    return Row(
      children: [
        Text(
          'Creado: ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Color.fromRGBO(53, 80, 112, 2.0)),
        ),
        Text(timeago.format(oferta.fechaCreacion, locale: 'es')),
      ],
    );
  }

  _tipoDePago() {
    return Row(
      children: [
        Text(
          'Tipo de pago: ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Color.fromRGBO(53, 80, 112, 2.0)),
        ),
        Text(oferta.tipoPago.toString()),
      ],
    );
  }

  _categoria() {
    return Row(
      children: [
        Text(
          'Categoría: ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17.0,
            color: Color.fromRGBO(
              53,
              80,
              112,
              2.0,
            ),
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
        Text(
          'Salario (USD): ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
              color: Color.fromRGBO(53, 80, 112, 2.0)),
        ),
        Text(oferta.precio.toString()),
      ],
    );
  }
}
