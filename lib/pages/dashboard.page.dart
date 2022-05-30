import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jobsapp/pages/home.page.dart';
import 'package:jobsapp/pages/login.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/widgets/menu_widget.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final estiloTitulo = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);

  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.black);

  late ScrollController _scrollController;
  final preferenciaToken = PreferenciasUsuario();

  List<dynamic> listadoDeContratos = [];
  int _total = 0;

  final usuariosProvider = UsuariosProvider();
  bool estaLogueado = false;

   Future<void> verificarToken() async{
    bool verify = await usuariosProvider.verificarToken();
    if(verify){
      estaLogueado = false;
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }else{
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
    //agregar6(_ultimoDato);
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
    print('Dispose...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, 'home');
            },
            child: Text('Tus Ofertas'),
            ),
          actions: [
            _crearBotonAgregarOferta(context)
          ],
        ),
        //drawer: MenuWidget(),
        body: (listadoDeContratos.length > 0)
            ? RefreshIndicator(
                onRefresh: obtenerPrimerosRegistros,
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: listadoDeContratos.length,
                    itemBuilder: (context, index) {
                      return _crearItemContrato(
                          context, listadoDeContratos, index);
                      //print(inn.servicio);
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
                    )
                    ),
              ), 
              drawer: preferenciaToken.token.toString().length>0? MenuWidget(): null,);
  }

   _crearBotonAgregarOferta (BuildContext context) {
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
                  Text(listadoDeContratos[index][index]['cuerpo'].toString(), textAlign: TextAlign.justify,
                  style: estiloSubTitulo),
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
                          Text(listadoDeContratos[index][index]['precio']
                              .toString(), style: estiloSubTitulo),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Tipo Pago: ',
                            style: estiloTitulo,
                          ),
                          Text(listadoDeContratos[index][index]['tipoPago']
                              .toString(), style: estiloSubTitulo),
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
                              _crearBotonVisualizar(context, listadoDeContratos, index),
                              _crearBotonEditar(context, listadoDeContratos, index),
                              _crearBotonEliminar(context, listadoDeContratos, index),
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

  _crearBotonVisualizar(BuildContext context, List<dynamic> listadoDeContratos, int index) {
    return InkWell(
      child: Padding(padding: const EdgeInsets.all(10.0),
        child: Icon(Icons.remove_red_eye, color: Color.fromRGBO(53, 80, 112, 1.0),),),
      onTap: () {
        //Navigator.pop(context);
        Navigator.pushNamed(context, 'vereditaroferta',
            arguments: {listadoDeContratos[index][index]['_id']});
      },
      splashColor: Colors.blueGrey,
    );
  }

    _crearBotonEditar(BuildContext context, List<dynamic> listadoDeContratos, int index) {
    return InkWell(
      child: Padding(padding: const EdgeInsets.all(10.0),
        child: Icon(Icons.edit_note_rounded, color: Color.fromRGBO(53, 80, 112, 1.0),),),
      onTap: () {
        //Navigator.pop(context);
        //print('pulso: ${listadoDeContratos[index][index]}');
        //List<Oferta> myCartItems = Oferta.fromJson(jsonDecode(listadoDeContratos[index][index])) as List<Oferta>;
        
        Navigator.pushNamed(context, 'editaroferta',
            arguments: {listadoDeContratos[index][index]['_id']});
      },
      splashColor: Colors.blueGrey,
    );
  }

    _crearBotonEliminar(BuildContext context, List<dynamic> listadoDeContratos, int index) {
    return InkWell(
      child: Padding(padding: const EdgeInsets.all(10.0),
        child: Icon(Icons.delete_outline_rounded, color: Colors.red,),),
      onTap: () {
        //Navigator.pop(context);
        eliminarVisitaEstado(context, listadoDeContratos, index);
        Navigator.pushNamed(context, 'dashboard',
            arguments: {listadoDeContratos[index][0]});
      },
      splashColor: Colors.blueGrey,
    );
  }

    eliminarVisitaEstado(BuildContext context, List<dynamic> listadoDeContratos, int index) async {
      String uidOferta = listadoDeContratos[index][index]['_id'];
      print('OFERTA A ELIMINAR: ${uidOferta}');
    final url = Uri.parse('https://jobstesis.herokuapp.com/api/oferta/$uidOferta?token=${preferenciaToken.token}}');
    final request =  http.Request('DELETE', url);
      request.headers.addAll(<String, String> {"Content-Type": "application/json", 
        'x-token': preferenciaToken.token},);

  //print(resp.request);
    //print('ESTADO: ${request}');
    //request.body = jsonEncode({"_id": uidOferta});
    final response = await request.send();
    print("STATUS: ${response.request}");
    Navigator.pushReplacementNamed(context, 'dashboard');
    return response;
  }

  fetchData() async {
    // Now you can use your decoded token
    //print('UID ${decodedToken['uid']}');
    final uid = preferenciaToken.idUsuario;
    final response = await http.get(
      Uri.parse(
          'https://jobstesis.herokuapp.com/api/oferta/usuario/${uid}'),
      headers: {"Content-Type": "application/json"},
    );
    print('datos: ${response.body}');
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          print(
              'total recibido: ${json.decode(response.body).length}');
          if (listadoDeContratos.length <
              json.decode(response.body).length) {
            listadoDeContratos.add(json.decode(response.body));
          } else {
            return;
          }
        });
    } else {
      return false;
    }

    //print('Lista de contratos ${listadoDeContratos.length}');
  }

  obtener6() {
    for (var i = 0; i < 6; i++) {
      if (listadoDeContratos.length <= _total) {
        //print('listado: ${listadoDeContratos.length}');
        //print('total: $_total');
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
