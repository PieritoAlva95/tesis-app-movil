import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobsapp/models/ofert.model.dart';
import 'package:jobsapp/pages/login.page.dart';
import 'package:jobsapp/provider/oferta.provider.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/utils.dart';
import 'package:jobsapp/widgets/menu_widget.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TusContratosPage extends StatefulWidget {
  @override
  _TusContratosPageState createState() => _TusContratosPageState();
}

class _TusContratosPageState extends State<TusContratosPage> {
  final estiloTitulo = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);

  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.black);

  late ScrollController _scrollController;
  final preferenciaToken = PreferenciasUsuario();

  List<dynamic> listadoDeContratos = [];
  int _total = 0;
  Oferta oferta = Oferta(fechaCreacion: DateTime.now(), interesados: []);

  final usuariosProvider = UsuariosProvider();
  OfertaProvider ofertaProvider = OfertaProvider();

  Future<void> verificarToken() async {
    bool verify = await usuariosProvider.verificarToken();
    if (verify) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      print('Token válido ${preferenciaToken.token}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificarToken();

    _scrollController = ScrollController();
    obtener6();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        obtener6();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    listadoDeContratos.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tus Ofertas'),
      ),
      body: (listadoDeContratos.length > 0)
          ? RefreshIndicator(
              onRefresh: obtenerPrimerosRegistros,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: listadoDeContratos.length,
                  itemBuilder: (context, index) {
                    return _crearItemContrato(
                        context, listadoDeContratos, index);
                  }),
            )
          : Center(
              child: Container(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 45.0,
                        ),
                        Text("No tienes Ofertas",
                            style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(29, 53, 87, 1.0))),
                        SizedBox(
                          height: 30.0,
                        ),
                        FadeInImage(
                          placeholder: AssetImage('assets/img/buscando.png'),
                          image: AssetImage('assets/img/buscando.png'),
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  )),
            ),
      drawer:
          preferenciaToken.token.toString().length > 0 ? MenuWidget() : null,
    );
  }

  _crearItemContrato(
      BuildContext context, List<dynamic> listadoDeContratos, int index) {
    return Container(
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            _crearTitulo(context, listadoDeContratos, index),
          ],
        ),
      ),
    );
  }

  _crearTitulo(
      BuildContext context, List<dynamic> listadoDeContratos, int index) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Título',
                    style: estiloTitulo,
                  ),
                  Text(
                    listadoDeContratos[index][index]['titulo'].toString(),
                    style: estiloSubTitulo,
                  ),
                  Divider(),
                  Text(
                    'Descripción',
                    style: estiloTitulo,
                  ),
                  Text(listadoDeContratos[index][index]['cuerpo'].toString(),
                      textAlign: TextAlign.justify, style: estiloSubTitulo),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Nombre: ',
                        style: estiloTitulo,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, 'verperfil',
                                arguments: {
                                  listadoDeContratos[index][index]
                                      ['interesados'][0]['postulante']
                                });
                            //Navigator.pushReplacementNamed(context, '');
                          },
                          child: Text(
                              listadoDeContratos[index][index]['interesados'][0]
                                      ['nombres']
                                  .toString(),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  color: Color.fromRGBO(53, 80, 112, 1.0),
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Precio (USD): ',
                            style: estiloTitulo,
                          ),
                          Text(
                              listadoDeContratos[index][index]['precio']
                                  .toString(),
                              style: estiloSubTitulo),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Tipo Pago: ',
                            style: estiloTitulo,
                          ),
                          Text(
                              listadoDeContratos[index][index]['tipoPago']
                                  .toString(),
                              style: estiloSubTitulo),
                        ],
                      )
                    ],
                  ),
                  Divider(),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                color: Color.fromRGBO(255, 107, 107, 1.0),
                                onPressed: () {
                                  oferta.disponible = 'contrato finalizado';
                                  oferta.status = listadoDeContratos[index]
                                      [index]['status'];
                                  oferta.statusUser = listadoDeContratos[index]
                                      [index]['statusUser'];
                                  oferta.usuario = listadoDeContratos[index]
                                      [index]['usuario'];
                                  oferta.fechaCreacion = DateTime.parse(
                                      listadoDeContratos[index][index]
                                          ['fechaCreacion']);
                                  oferta.titulo = listadoDeContratos[index]
                                      [index]['titulo'];
                                  oferta.cuerpo = listadoDeContratos[index]
                                      [index]['cuerpo'];
                                  oferta.precio = listadoDeContratos[index]
                                      [index]['precio'];
                                  oferta.tipoPago = listadoDeContratos[index]
                                      [index]['tipoPago'];
                                  oferta.categoria = listadoDeContratos[index]
                                      [index]['categoria'];
                                  oferta.nombreUsuario =
                                      listadoDeContratos[index][index]
                                          ['nombreUsuario'];
                                  final map = [
                                    {
                                      'nombres': listadoDeContratos[index]
                                          [index]['interesados'][0]['nombres'],
                                      'aceptado': listadoDeContratos[index]
                                          [index]['interesados'][0]['aceptado'],
                                      '_id': listadoDeContratos[index][index]
                                          ['interesados'][0]['_id'],
                                      'fechaPostulacion':
                                          listadoDeContratos[index][index]
                                                  ['interesados'][0]
                                              ['fechaPostulacion'],
                                      'postulante': listadoDeContratos[index]
                                              [index]['interesados'][0]
                                          ['postulante'],
                                      'foto': listadoDeContratos[index][index]
                                          ['interesados'][0]['foto'],
                                    }
                                  ];
                                  oferta.interesados = map;
                                  String idOferta =
                                      listadoDeContratos[index][index]['_id'];
                                  ofertaProvider.editarOferta(oferta, idOferta);
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                      context, 'tuscontratos');
                                },
                                child: Text(
                                  'Finalizar Contrato',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  eliminarVisitaEstado(
      BuildContext context, List<dynamic> listadoDeContratos, int index) async {
    String uidOferta = listadoDeContratos[index][index]['_id'];
    final url = Uri.parse(
        '$URLBASE/api/oferta/$uidOferta?token=${preferenciaToken.token}}');
    final request = http.Request('DELETE', url);
    request.headers.addAll(
      <String, String>{
        "Content-Type": "application/json",
        'x-token': preferenciaToken.token
      },
    );

    final response = await request.send();
    Navigator.pushReplacementNamed(context, 'dashboard');
    return response;
  }

  fetchData() async {
    var decodedToken = JwtDecoder.decode(preferenciaToken.token);
    final uid = decodedToken['uid'];
    final response = await http.get(
      Uri.parse('$URLBASE/api/oferta/usuario/contratos/${uid}'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          if (listadoDeContratos.length < json.decode(response.body).length) {
            listadoDeContratos.add(json.decode(response.body));
          } else {
            return;
          }
        });
    } else {
      return false;
    }
  }

  obtener6() {
    for (var i = 0; i < 6; i++) {
      if (listadoDeContratos.length <= _total) {
        fetchData();
      } else {
        return;
      }
    }
  }

  Future<Null> obtenerPrimerosRegistros() async {
    final duration = new Duration(seconds: 2);
    new Timer(duration, () {
      listadoDeContratos.clear();
      _total = 0;
      obtener6();
    });

    return Future.delayed(duration);
  }
}
