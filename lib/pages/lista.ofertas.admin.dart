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

class OfertasAdministrador extends StatefulWidget {
  const OfertasAdministrador({Key? key}) : super(key: key);

  @override
  _OfertasAdministradorState createState() => _OfertasAdministradorState();
}

class _OfertasAdministradorState extends State<OfertasAdministrador> {
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
  Oferta oferta = Oferta(
    fechaCreacion: DateTime.now(),
    interesados: [],
  );

  List<dynamic> listadoDeContratos = [];
  int _total = 0;

  final usuariosProvider = UsuariosProvider();
  final ofertaProvider = OfertaProvider();

  Future<void> verificarToken() async {
    bool verify = await usuariosProvider.verificarToken();
    if (verify) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => const LoginPage(),
          ),
          (Route<dynamic> route) => false);
    } else {
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
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    listadoDeContratos.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrar Ofertas'),
      ),
      body: (listadoDeContratos.isNotEmpty)
          ? RefreshIndicator(
              onRefresh: obtenerPrimerosRegistros,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: listadoDeContratos.length,
                itemBuilder: (context, index) {
                  return _crearItemContrato(
                    context,
                    listadoDeContratos,
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
                        "No tienes Ofertas",
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
      onPressed: () => Navigator.pushNamed(context, 'crearoferta'),
    );
  }

  _crearItemContrato(
      BuildContext context, List<dynamic> listadoDeContratos, int index) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          _crearTitulo(context, listadoDeContratos, index),
        ],
      ),
    );
  }

  _crearTitulo(
      BuildContext context, List<dynamic> listadoDeContratos, int index) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 10,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Título: ',
                        style: estiloTitulo,
                      ),
                      Text(
                        listadoDeContratos[index][index]['titulo'].toString(),
                        textAlign: TextAlign.justify,
                        style: estiloSubTitulo,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Descripción: ',
                    style: estiloTitulo,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    listadoDeContratos[index][index]['cuerpo'].toString(),
                    style: estiloSubTitulo,
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Precio (USD): ',
                        style: estiloTitulo,
                      ),
                      Text(
                        listadoDeContratos[index][index]['precio'].toString(),
                        style: estiloSubTitulo,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Tipo de Pago: ',
                        style: estiloTitulo,
                      ),
                      Text(
                        listadoDeContratos[index][index]['tipoPago'].toString(),
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
                          listadoDeContratos[index][index]['status'] &&
                                  listadoDeContratos[index][index]
                                          ['disponible'] ==
                                      'contrato finalizado'
                              ? const Text(
                                  'contrato finalizado',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(53, 80, 112, 1.0),
                                    fontSize: 18.0,
                                  ),
                                )
                              : listadoDeContratos[index][index]['status'] &&
                                      listadoDeContratos[index][index]
                                              ['disponible'] ==
                                          'con contrato'
                                  ? const Text(
                                      'Oferta con contrato',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromRGBO(53, 80, 112, 1.0),
                                          fontSize: 18.0),
                                    )
                                  : ElevatedButton(
                                      child: Column(
                                        children: [
                                          listadoDeContratos[index][index]
                                                      ['status'] &&
                                                  listadoDeContratos[index]
                                                              [index]
                                                          ['disponible'] ==
                                                      'sin contrato'
                                              ? Text('Desactivar')
                                              : Text('Activar'),
                                        ],
                                      ),
                                      style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                        ),
                                        elevation:
                                            const MaterialStatePropertyAll(
                                          10.0,
                                        ),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                          Colors.red,
                                        ),
                                        foregroundColor:
                                            const MaterialStatePropertyAll(
                                          Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        oferta.titulo =
                                            listadoDeContratos[index][index]
                                                ['titulo'];
                                        oferta.cuerpo =
                                            listadoDeContratos[index][index]
                                                ['cuerpo'];
                                        oferta.precio =
                                            listadoDeContratos[index][index]
                                                    ['precio']
                                                .toString();
                                        oferta.tipoPago =
                                            listadoDeContratos[index][index]
                                                ['tipoPago'];
                                        oferta.categoria =
                                            listadoDeContratos[index][index]
                                                ['categoria'];
                                        oferta.fechaCreacion = DateTime.parse(
                                            listadoDeContratos[index][index]
                                                ['fechaCreacion']);
                                        oferta.interesados =
                                            listadoDeContratos[index][index]
                                                ['interesados'];
                                        oferta.status =
                                            listadoDeContratos[index][index]
                                                ['status'];
                                        oferta.usuario =
                                            listadoDeContratos[index][index]
                                                ['usuario'];
                                        oferta.nombreUsuario =
                                            listadoDeContratos[index][index]
                                                ['nombreUsuario'];

                                        if (oferta.status == true) {
                                          oferta.status = false;
                                          ofertaProvider.editarOferta(
                                              oferta,
                                              listadoDeContratos[index][index]
                                                  ['_id']);
                                          oferta = Oferta(
                                            fechaCreacion: DateTime.now(),
                                            interesados: [],
                                          );
                                          Navigator.pushReplacementNamed(
                                            context,
                                            'ofertasadmin',
                                          );
                                        }
                                        if (oferta.status == false) {
                                          oferta.status = true;
                                          ofertaProvider.editarOferta(
                                            oferta,
                                            listadoDeContratos[index][index]
                                                ['_id'],
                                          );
                                          oferta = Oferta(
                                            fechaCreacion: DateTime.now(),
                                            interesados: [],
                                          );
                                          Navigator.pushReplacementNamed(
                                            context,
                                            'ofertasadmin',
                                          );
                                        }
                                        print(
                                            'Oferta A modificar: ${listadoDeContratos[index][index]['_id']}');
                                      },
                                    )
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
    final response = await http.get(
      Uri.parse('$URLBASE/api/oferta/admin/ofertas'),
      headers: {"Content-Type": "application/json"},
    );
    print('datos: ${response.body}');
    print('datosOFERTA: ${json.decode(response.body)['ofertas'].length}');
    if (response.statusCode == 200) {
      if (mounted) {
        setState(
          () {
            _total = json.decode(response.body)['ofertas'].length;
            if (listadoDeContratos.length < _total) {
              listadoDeContratos.add(
                json.decode(response.body)['ofertas'],
              );
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
      if (listadoDeContratos.length <= _total) {
        fetchData();
      } else {
        return;
      }
    }
  }

  Future<void> obtenerPrimerosRegistros() async {
    const duration = Duration(seconds: 2);
    Timer(
      duration,
      () {
        listadoDeContratos.clear();
        _total = 0;
        obtener6();
      },
    );
    return Future.delayed(duration);
  }
}
