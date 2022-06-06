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

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final estiloTitulo = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);

  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.black);

  late ScrollController _scrollController;
  final preferenciaToken = PreferenciasUsuario();

  List<dynamic> listadoDeOfertas = [];
  int _total = 0;

  final usuariosProvider = UsuariosProvider();
  bool estaLogueado = false;

  Future<void> verificarToken() async {
    bool verify = await usuariosProvider.verificarToken();
    if (verify) {
      estaLogueado = false;
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      estaLogueado = true;
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
    listadoDeOfertas.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, 'home');
          },
          child: Text('Tus Ofertas'),
        ),
        actions: [_crearBotonAgregarOferta(context)],
      ),
      body: (listadoDeOfertas.length > 0)
          ? RefreshIndicator(
              onRefresh: obtenerPrimerosRegistros,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: listadoDeOfertas.length,
                  itemBuilder: (context, index) {
                    return _crearItemContrato(context, listadoDeOfertas, index);
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
                        Text("No has registrado Ofertas",
                            style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(53, 80, 112, 1.0))),
                        FadeInImage(
                          placeholder: AssetImage('assets/img/buscando.png'),
                          image: AssetImage('assets/img/buscando.png'),
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                      ],
                    ),
                  )),
            ),
      drawer:
          preferenciaToken.token.toString().length > 0 ? MenuWidget() : null,
    );
  }

  _crearBotonAgregarOferta(BuildContext context) {
    return FlatButton(
      child: Icon(Icons.add, color: Colors.white, size: 40.0),
      onPressed: () => Navigator.pushNamed(context, 'crearoferta'),
    );
  }

  _crearItemContrato(
      BuildContext context, List<dynamic> listadoDeOfertas, int index) {
    return Container(
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            _crearTitulo(context, listadoDeOfertas, index),
            //DOWNLOAD
          ],
        ),
      ),
    );
  }

  _crearTitulo(
      BuildContext context, List<dynamic> listadoDeOfertas, int index) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                    listadoDeOfertas[index][index]['titulo'].toString(),
                    style: estiloSubTitulo,
                  ),
                  Divider(),
                  Text(
                    'Descripción',
                    style: estiloTitulo,
                  ),
                  Text(listadoDeOfertas[index][index]['cuerpo'].toString(),
                      textAlign: TextAlign.justify, style: estiloSubTitulo),
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
                            'Precio: ',
                            style: estiloTitulo,
                          ),
                          Text(
                              listadoDeOfertas[index][index]['precio']
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
                              listadoDeOfertas[index][index]['tipoPago']
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
                          Text(
                            'Acción',
                            style: estiloTitulo,
                            textAlign: TextAlign.start,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _crearBotonVisualizar(
                                  context, listadoDeOfertas, index),
                              _crearBotonEditar(
                                  context, listadoDeOfertas, index),
                              _crearBotonEliminar(
                                  context, listadoDeOfertas, index),
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

  _crearBotonVisualizar(
      BuildContext context, List<dynamic> listadoDeOfertas, int index) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          Icons.remove_red_eye,
          color: Color.fromRGBO(53, 80, 112, 1.0),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, 'vereditaroferta',
            arguments: {listadoDeOfertas[index][index]['_id']});
      },
      splashColor: Colors.blueGrey,
    );
  }

  _crearBotonEditar(
      BuildContext context, List<dynamic> listadoDeOfertas, int index) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          Icons.edit_note_rounded,
          color: Color.fromRGBO(53, 80, 112, 1.0),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, 'editaroferta',
            arguments: {listadoDeOfertas[index][index]['_id']});
      },
      splashColor: Colors.blueGrey,
    );
  }

  _crearBotonEliminar(
      BuildContext context, List<dynamic> listadoDeOfertas, int index) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.red,
        ),
      ),
      onTap: () {

        Alert(
            context: context,
            title: "¿Desea eliminar esta oferta?",
            content: Column(
              children: <Widget>[
                    SizedBox(height: 15.0,),
                Text(listadoDeOfertas[index][index]['titulo'], style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 15.0,),
              ],
            ),
            buttons: [
              
              DialogButton(
                color: Color.fromRGBO(29, 53, 87, 1.0),
                onPressed: () async {


                    eliminarVisitaEstado(context, listadoDeOfertas, index);
                    Navigator.pushNamed(context, 'dashboard',
            arguments: {listadoDeOfertas[index][0]});
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
      splashColor: Colors.blueGrey,
    );
  }

  eliminarVisitaEstado(
      BuildContext context, List<dynamic> listadoDeOfertas, int index) async {
    String uidOferta = listadoDeOfertas[index][index]['_id'];
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
    final uid = preferenciaToken.idUsuario;
    final response = await http.get(
      Uri.parse('$URLBASE/api/oferta/usuario/${uid}'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          if (listadoDeOfertas.length < json.decode(response.body).length) {
            listadoDeOfertas.add(json.decode(response.body));
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
      if (listadoDeOfertas.length <= _total) {
        fetchData();
      } else {
        return;
      }
    }
  }

  Future<Null> obtenerPrimerosRegistros() async {
    final duration = new Duration(seconds: 2);
    new Timer(duration, () {
      listadoDeOfertas.clear();
      _total = 0;
      obtener6();
    });

    return Future.delayed(duration);
  }
}
