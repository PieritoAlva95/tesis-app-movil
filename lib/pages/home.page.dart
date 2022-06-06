import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobsapp/bloc/oferta.bloc.dart';
import 'package:jobsapp/bloc/perfil_bloc.dart';
import 'package:jobsapp/models/ofert.model.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/utils.dart';
import 'package:jobsapp/widgets/menu.opciones.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final estiloTitulo = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);

  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.black);

  late ScrollController _scrollController;
  final preferenciaToken = PreferenciasUsuario();

  List<dynamic> listadoDeContratos = [];
  int _total = 0;

  final usuariosProvider = UsuariosProvider();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic> dataUsuarioPostulante = {};
  PerfilBloc usuarioBloc = PerfilBloc();
  OfertaBloc ofertaBloc = OfertaBloc();
  var uuid = Uuid();

  Oferta ofertaNueva = Oferta(fechaCreacion: DateTime.now(), interesados: []);

  Future<void> verificarToken() async {
    bool verify = await usuariosProvider.verificarToken();
    if (verify) {
      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    } else {
      print('Token válido ${preferenciaToken.token}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificarToken();
    print('iD: ${preferenciaToken.idUsuario}');
    
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
      key: scaffoldKey,
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              if (preferenciaToken.token.toString().isNotEmpty) {
                Navigator.pop(context);
                Navigator.pushNamed(context, 'dashboard');
              }
            },
            child: Text('Tus Ofertas Home')),
      ),
      body: (listadoDeContratos.length > 0)
          ? RefreshIndicator(
              onRefresh: obtenerPrimerosRegistros,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: listadoDeContratos.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        _usuarioObtenidoArrendador(),
                    _crearItemContrato(
                        context, listadoDeContratos, index)
                      ],
                    );
                  }),
            )
          : Center(
              child: Container(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30.0,
                        ),
                        Text("No hay Ofertas de trabajo",
                            style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(53, 80, 112, 1.0))),
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
      drawer: MenuOpcionesPrincipalesWidget(),
    );
  }

  _crearBotonAgregarOferta(BuildContext context) {
    return FlatButton(
      child: Icon(Icons.add, color: Colors.white, size: 40.0),
      onPressed: () => Navigator.pushNamed(context, 'crearoferta'),
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
            //DOWNLOAD
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
                  InkWell(
                    onTap: () {
                      print(listadoDeContratos[index]['ofertas'][index]['_id']
                          .toString());
                      Navigator.pushNamed(context, 'postular', arguments: {
                        listadoDeContratos[index]['ofertas'][index]['_id']
                            .toString()
                      });
                    },
                    child: Text(
                      listadoDeContratos[index]['ofertas'][index]['titulo']
                          .toString(),
                      style: TextStyle(
                          fontSize: 24.0,
                          color: Color.fromRGBO(53, 80, 112, 1.0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, 'verperfil', arguments: {
                        listadoDeContratos[index]['ofertas'][index]['usuario']
                            .toString()
                      });
                    },
                    child: Text(
                      listadoDeContratos[index]['ofertas'][index]
                              ['nombreUsuario']
                          .toString(),
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Color.fromRGBO(53, 80, 112, 1.0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                      listadoDeContratos[index]['ofertas'][index]['cuerpo']
                          .toString(),
                      textAlign: TextAlign.justify,
                      style:
                          TextStyle(color: Color.fromRGBO(53, 80, 112, 1.0))),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Creado: ',
                        style: estiloTitulo,
                      ),
                      Text(timeago
                          .format(
                              DateTime.parse(listadoDeContratos[index]
                                  ['ofertas'][index]['fechaCreacion']),
                              locale: 'es')
                          .toString()),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Categoría: ',
                        style: estiloTitulo,
                      ),
                      Text(listadoDeContratos[index]['ofertas'][index]
                              ['categoria']
                          .toString()),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      Text(
                        'Interesados: ',
                        style: estiloTitulo,
                      ),
                      Text(
                          '${listadoDeContratos[index]['ofertas'][index]['interesados'].length}')
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Salario: ',
                            style: estiloTitulo,
                          ),
                          Text(
                              listadoDeContratos[index]['ofertas'][index]
                                      ['precio']
                                  .toString(),
                              style: estiloSubTitulo),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Tipo de Pago: ',
                            style: estiloTitulo,
                          ),
                          Text(
                              listadoDeContratos[index]['ofertas'][index]
                                      ['tipoPago']
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
                          _crearBotonVisualizar(
                              context, listadoDeContratos, index),
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
      BuildContext context, List<dynamic> listadoDeContratos, int index) {
    return RaisedButton(
      onPressed: () async {


            Alert(
            context: context,
            title: "Título de la oferta laboral:",
            content: Column(
              children: <Widget>[
                Column(
                  children: [
                    Text(ofertaNueva.titulo),
                    SizedBox(height: 15.0,),
                    Text('¿Desea postularse a esta oferta?',style: TextStyle(fontSize: 16.0),),
                    SizedBox(height: 15.0,),
                  ],
                ),
              ],
            ),
            buttons: [
              
              DialogButton(
                onPressed: () async {

                  
                  
        if (preferenciaToken.token.toString().isEmpty) {
          mostrarSnackBar('No puede postularse, debe iniciar seisión.');
          return;
        }

        ofertaNueva.titulo =
            listadoDeContratos[index]['ofertas'][index]['titulo'];
        ofertaNueva.cuerpo =
            listadoDeContratos[index]['ofertas'][index]['cuerpo'];
        ofertaNueva.precio =
            listadoDeContratos[index]['ofertas'][index]['precio'].toString();
        ofertaNueva.tipoPago =
            listadoDeContratos[index]['ofertas'][index]['tipoPago'];
        ofertaNueva.categoria =
            listadoDeContratos[index]['ofertas'][index]['categoria'];
        ofertaNueva.usuario =
            listadoDeContratos[index]['ofertas'][index]['usuario'];
        ofertaNueva.nombreUsuario =
            listadoDeContratos[index]['ofertas'][index]['nombreUsuario'];
        ofertaNueva.fechaCreacion = DateTime.parse(
            listadoDeContratos[index]['ofertas'][index]['fechaCreacion']);
        ofertaNueva.interesados = listadoDeContratos[index]['ofertas'][index]['interesados'];

print('hola: $dataUsuarioPostulante');
//TESTEANDO...
        final map = {
          'nombres': dataUsuarioPostulante['usuario']['nombres'] +
              dataUsuarioPostulante['usuario']['apellidos'],
          'aceptado': false,
          '_id': uuid.v1().toString().replaceAll('-', '').substring(0, 24),
          'fechaPostulacion': DateTime.now().toString(),
          'postulante': preferenciaToken.idUsuario,
          'foto': dataUsuarioPostulante['usuario']['foto'],
        };
        if (!ofertaNueva.interesados.toString().contains(map['postulante'].toString())) {
          ofertaNueva.interesados.add(map);
          mostrarSnackBar('Su postulación se ha realizado correctamente');


          final respuesta = await ofertaBloc.editarPostulanteOferta(
              ofertaNueva, listadoDeContratos[index]['ofertas'][index]['_id']);
          Navigator.pushReplacementNamed(context, 'home');
        } else {
          mostrarAlerta(
              context, 'Sr. usuario ya se ha postulado a esta oferta');
        }



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
        'Postularse',
        style: TextStyle(color: Colors.white),
      ),
      color: Color.fromRGBO(53, 80, 112, 1.0),
    );
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1800),
      backgroundColor: Color.fromRGBO(29, 53, 87, 1.0),
    );
    scaffoldKey.currentState!.showSnackBar(snackbar);
  }

  _usuarioObtenidoArrendador() {
    return FutureBuilder(
        future: usuarioBloc.cargarUsuarioEspecifico(preferenciaToken.idUsuario),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.hasData) {
            dataUsuarioPostulante = snapshot.data!;
            print('USER: ${snapshot.data}');
            return Container();
          } else {
            print('USER: ${snapshot.data}');
            return CircularProgressIndicator();
          }
        });
  }

  _crearBotonEditar(
      BuildContext context, List<dynamic> listadoDeContratos, int index) {
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
            arguments: {listadoDeContratos[index][index]['_id']});
      },
      splashColor: Colors.blueGrey,
    );
  }

  fetchData() async {
    final response = await http.get(
      Uri.parse('$URLBASE/api/oferta'),
      headers: {"Content-Type": "application/json"},
    );
    
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          _total = json.decode(response.body)['ofertas'].length;
          
          if (listadoDeContratos.length < _total) {
            listadoDeContratos.add(json.decode(response.body));
          } else {
            return;
          }
        });
    } else {
      return false;
    }
  }

  fetchDataLogueado() async {
    print('llegando al fetch');
    print('TOKEN ID: ${preferenciaToken.idUsuario}');
    final response = await http.get(
      Uri.parse(
          '$URLBASE/api/oferta/usuario/ofertas/movil/${preferenciaToken.idUsuario}/logueado'),
      headers: {"Content-Type": "application/json"},
    );
    //print(response.request);
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          _total = json.decode(response.body)['ofertas'].length;
          if (listadoDeContratos.length < _total) {
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
    if (preferenciaToken.idUsuario.toString().isEmpty) {
      for (var i = 0; i < 6; i++) {
        if (listadoDeContratos.length <= _total) {
          fetchData();
        } else {
          return;
        }
      }
    }
    if (preferenciaToken.token.toString().isNotEmpty) {
      for (var i = 0; i < 6; i++) {
        if (listadoDeContratos.length <= _total) {
          fetchDataLogueado();
        } else {
          return;
        }
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
