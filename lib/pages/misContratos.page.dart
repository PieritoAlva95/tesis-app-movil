import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobsapp/pages/login.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/utils.dart';
import 'package:jobsapp/widgets/menu_widget.dart';

class MisContratosPage extends StatefulWidget {
  const MisContratosPage({Key? key}) : super(key: key);

  @override
  _MisContratosPageState createState() => _MisContratosPageState();
}

class _MisContratosPageState extends State<MisContratosPage> {
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

  List<dynamic> listadoDeContratos = [];
  int _total = 0;

  final usuariosProvider = UsuariosProvider();

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
    super.dispose();
    _scrollController.dispose();
    listadoDeContratos.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Contratos'),
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
                  }),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        children: [
          _crearTitulo(
            context,
            listadoDeContratos,
            index,
          ),
        ],
      ),
    );
  }

  _crearTitulo(
    BuildContext context,
    List<dynamic> listadoDeContratos,
    int index,
  ) {
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
                  Text(
                    'Título',
                    style: estiloTitulo,
                  ),
                  Text(
                    listadoDeContratos[index][index]['titulo'].toString(),
                    style: estiloSubTitulo,
                  ),
                  const Divider(),
                  Text(
                    'Descripción',
                    style: estiloTitulo,
                  ),
                  Text(listadoDeContratos[index][index]['cuerpo'].toString(),
                      textAlign: TextAlign.justify, style: estiloSubTitulo),
                  const SizedBox(height: 20.0),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Precio: ',
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
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Text(
                        'Empleador: ',
                        style: estiloTitulo,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'verperfil',
                            arguments: {
                              listadoDeContratos[index][index]['usuario']
                            },
                          );
                        },
                        child: Text(
                          listadoDeContratos[index][index]['nombreUsuario'],
                          // listadoDeContratos[index][index]['interesados'][0]
                          //         ['nombres']
                          //     .toString(),
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 13.0,
                            color: Color.fromRGBO(53, 80, 112, 1.0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
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
      Uri.parse('$URLBASE/api/oferta/busqueda/contratos/usuario/${uid}'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      if (mounted) {
        setState(
          () {
            if (listadoDeContratos.length < json.decode(response.body).length) {
              listadoDeContratos.add(json.decode(response.body));
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
