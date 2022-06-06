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
  @override
  _OfertasAdministradorState createState() => _OfertasAdministradorState();
}

class _OfertasAdministradorState extends State<OfertasAdministrador> {
  final estiloTitulo = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);

  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.black);

  late ScrollController _scrollController;
  final preferenciaToken = PreferenciasUsuario();
  Oferta oferta = Oferta(fechaCreacion: DateTime.now(), interesados: []);

  List<dynamic> listadoDeContratos = [];
  int _total = 0;

  final usuariosProvider = UsuariosProvider();
  final ofertaProvider = OfertaProvider();

   Future<void> verificarToken() async{
    bool verify = await usuariosProvider.verificarToken();
    if(verify){
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }else{
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Administrar Ofertas'),
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
                           
                          Text("No tienes Ofertas",
                              style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(53, 80, 112, 1.0))),
                          SizedBox(
                            height: 30.0,
                          ),FadeInImage(
                            placeholder: AssetImage('assets/img/buscando.png'),
                            image: AssetImage('assets/img/buscando.png'),
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 15.0,
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
               
                  Row(
                    children: [
                      Text(
                    'Título: ',
                    style: estiloTitulo,
                  ),
                  Text(listadoDeContratos[index][index]['titulo'].toString(), textAlign: TextAlign.justify,
                  style: estiloSubTitulo),
                    ],
                  ),

                  
                  Row(
                    children: [
                      Text(
                    'Descripción: ',
                    style: estiloTitulo,
                  ),
                  Text(listadoDeContratos[index][index]['cuerpo']
                      .toString(), style: estiloSubTitulo),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Precio (USD): ',
                        style: estiloTitulo,
                      ),
                      Text(listadoDeContratos[index][index]['precio']
                          .toString(), style: estiloSubTitulo),
                    ],
                  ),
                   Row(
                    children: [
                      Text(
                        'Tipo de Pago: ',
                        style: estiloTitulo,
                      ),
                      Text(listadoDeContratos[index][index]['tipoPago']
                          .toString(), style: estiloSubTitulo),
                    ],
                  ),
                  Divider(),
                   
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: [
                       Row(
                    children: [
                    Text(
                    'Acción: ',
                    style: estiloTitulo,
                  ),
                  
                  listadoDeContratos[index][index]['status'] && listadoDeContratos[index][index]['disponible']=='contrato finalizado'?
                  Text('contrato finalizado'):
                  listadoDeContratos[index][index]['status'] && listadoDeContratos[index][index]['disponible']=='con contrato'?
                  Text('Oferta con contrato'):
                  RaisedButton(
                    child: Container(
                      child: Column(
                        children: [
                          listadoDeContratos[index][index]['status'] && listadoDeContratos[index][index]['disponible']=='sin contrato'?Text('Desactivar'):Text('Activar'),
                        ],
                      ),
                    ),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    elevation: 10.0,
                    color: Colors.red,
                    textColor: Colors.white, 
                    onPressed: (){
                      oferta.titulo = listadoDeContratos[index][index]['titulo'];
                      oferta.cuerpo = listadoDeContratos[index][index]['cuerpo'];
                      oferta.precio = listadoDeContratos[index][index]['precio'].toString();
                      oferta.tipoPago = listadoDeContratos[index][index]['tipoPago'];
                      oferta.categoria = listadoDeContratos[index][index]['categoria'];
                      oferta.fechaCreacion = DateTime.parse(listadoDeContratos[index][index]['fechaCreacion']);
                      oferta.interesados = listadoDeContratos[index][index]['interesados'];
                      oferta.status = listadoDeContratos[index][index]['status'];
                      oferta.usuario = listadoDeContratos[index][index]['usuario'];
                      oferta.nombreUsuario = listadoDeContratos[index][index]['nombreUsuario'];

                      if(oferta.status == true){
                        oferta.status = false;
                        ofertaProvider.editarOferta(oferta, listadoDeContratos[index][index]['_id']);
                        oferta = Oferta(fechaCreacion: DateTime.now(), interesados: []);
                        Navigator.pushReplacementNamed(context, 'ofertasadmin');
                      }if(oferta.status == false){
                        oferta.status = true;
                        ofertaProvider.editarOferta(oferta, listadoDeContratos[index][index]['_id']);
                        oferta = Oferta(fechaCreacion: DateTime.now(), interesados: []);
                        Navigator.pushReplacementNamed(context, 'ofertasadmin');
                      }
                      print('Oferta A modificar: ${listadoDeContratos[index][index]['_id']}');
                    }
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
    // Now you can use your decoded token
    final uid = preferenciaToken.idUsuario;
    final response = await http.get(
      Uri.parse(
          '$URLBASE/api/oferta/admin/ofertas'),
      headers: {"Content-Type": "application/json"},
    );
    print('datos: ${response.body}');
    if (response.statusCode == 200) {
      if (mounted)
        setState(() {
          if (listadoDeContratos.length <
              json.decode(response.body)['ofertas'].length) {
            listadoDeContratos.add(json.decode(response.body)['ofertas']);
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
