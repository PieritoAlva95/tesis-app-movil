import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/perfil_bloc.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/experiencia.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/switch.list.tile.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';


class EditExpPage extends StatefulWidget {
  @override
  _EditExpPageState createState() => _EditExpPageState();
}

class _EditExpPageState extends State<EditExpPage> {


     TextEditingController _tituloExperienciaController = TextEditingController();
     TextEditingController _empresaExperienciaController = TextEditingController();
     TextEditingController _inicioExperienciaController = TextEditingController();
     TextEditingController _finExperienciaController = TextEditingController();
     TextEditingController _descripcionExperienciaController = TextEditingController();

     List<Experiencia> experienciaParaWidget = [];
     List experienciaList = [];
     var uuid = Uuid();
     String _fecha = '';
       DateTime tiempo =  DateTime.now();

     Experiencia expInicial = Experiencia(fechaInicio: DateTime.now());
     Experiencia exp = Experiencia(fechaInicio: DateTime.now());
     Experiencia expEliminada = Experiencia(fechaInicio: DateTime.now());
     Experiencia expEliminadaNuevamenteAgregada = Experiencia(fechaInicio: DateTime.now());


  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _blouearCheck = false;
  String _callBackParams = '';


  bool circularProgress = false;
  PerfilBloc perfilBloc = PerfilBloc();
  final usuarioProvider = UsuariosProvider();
  final preferencias =  PreferenciasUsuario();
  UsuarioClass user = UsuarioClass(experiencia: []);

  bool estaLogueado = false;
    final String _url = 'https://jobstesis.herokuapp.com/uploads/';




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tituloExperienciaController.dispose();
    _empresaExperienciaController.dispose();
    _inicioExperienciaController.dispose();
    _finExperienciaController.dispose();
    _descripcionExperienciaController.dispose();
  }


  String id = '';
  String fotoUser = '';
  String result = '';

  @override
  Widget build(BuildContext context) {
    perfilBloc = Provider.perfilBloc(context)!;

    final contratoObtenido = ModalRoute.of(context)!.settings.arguments;
    print(contratoObtenido);
     final primero = contratoObtenido.toString().replaceFirst('{', '');
     final pos = primero.length-1;
    result = primero.substring(0, pos);


    return Scaffold(
        appBar: AppBar(
          title: Text('Experiencia'),
          actions: [
            _botonAgregarHabilidad(context)
          ],
        ),
        //drawer: MenuWidget(),
        body: 
            ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              children: [
                FutureBuilder(
                  future: perfilBloc.cargarUsuarioEspecifico(preferencias.idUsuario),
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {

                    
                    experienciaParaWidget = [];

                    if (snapshot.hasError) {
                      print("eroro: " + snapshot.hasError.toString());
                    }
                    if (snapshot.hasData && snapshot.data!['usuario'] != null) {
           
                      experienciaList = snapshot.data!['usuario']['experiencia'];
                      
                      for (var i = 0; i < experienciaList.length; i++) {

                            expInicial = Experiencia(
                          id: experienciaList[i]['_id'],
                          titulo: experienciaList[i]['titulo'],
                          empresa: experienciaList[i]['empresa'],
                          fechaInicio: DateTime.parse(experienciaList[i]['fechaInicio'].toString()),
                          fechaFin: experienciaList[i]['fechaFin'],
                          descripcion: experienciaList[i]['descripcion']);
                        
                          experienciaParaWidget.add(expInicial);
                      }

                     
                        for (var item in experienciaParaWidget) {

                           if(item.id == result){

                           _tituloExperienciaController.text = item.titulo;
                          _inicioExperienciaController.text = item.fechaInicio.toString();
                          _empresaExperienciaController.text = item.empresa;
                          _finExperienciaController.text = item.fechaFin;
                          _descripcionExperienciaController.text = item.descripcion;
                        }
                        }
                        //_inicioExperienciaController.text = _fecha;
                        //print(_inicioExperienciaController.text.toString());
            
                      return Column(
                        children: [
                          
                          
                          _formEditExperiencia()
                          
                        ],
                      );
                    }else {
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
                                  
                                  Text("Sin experiencias laborales",
                                      style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(53, 80, 112, 2.0))),
                                  SizedBox(
                                    height: 30.0,
                                  ),FadeInImage(
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
        );
  }


  _botonAgregarHabilidad (BuildContext context) {
    return FlatButton(
      child: Icon(Icons.add, color: Colors.white, size: 40.0,),
      onPressed: () {
         Alert(
        context: context,
        title: "Añadir Experiencia",
        content: Column(
          children: <Widget>[
            TextField(
              controller: _tituloExperienciaController,
              decoration: InputDecoration(
                icon: Icon(Icons.title),
                labelText: 'Titulo',
              ),
            ),

           _crearFecha(context),

            /*TextField(
              controller: _inicioExperienciaController,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_month),
                labelText: 'Fecha Inicio',
              ),
            ),*/

            TextField(
              controller: _empresaExperienciaController,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Empresa',
              ),
            ),

            TextField(
              controller: _finExperienciaController,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_month),
                labelText: 'Fecha final',
              ),
            ),

            TextField(
              controller: _descripcionExperienciaController,
              decoration: InputDecoration(
                icon: Icon(Icons.description),
                labelText: 'Descripción',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () async{
              
              exp = Experiencia(
                            id: uuid.v1().toString().replaceAll('-', '').substring(0,24),
                            titulo: _tituloExperienciaController.text.toString(),
                            empresa: _empresaExperienciaController.text.toString(),
                            fechaInicio: DateTime.parse(_inicioExperienciaController.text.toString()),
                            fechaFin: _finExperienciaController.text.toString(),
                            descripcion: _descripcionExperienciaController.text.toString());

         
                  
                  /*Map<String, dynamic> daos = {
                          "_id": uuid.v1().toString().replaceAll('-', '').substring(0,24),
                          "titulo": _tituloExperienciaController.text.toString(),
                          "empresa": _empresaExperienciaController.text.toString(),
                          "fechaInicio": _inicioExperienciaController.text.toString(),
                          "fechaFin": _finExperienciaController.text.toString(),
                          "descripcion": _descripcionExperienciaController.text.toString()
                          };*/
                  experienciaParaWidget.add(exp);

                  user.experiencia = experienciaParaWidget;
                   for (var item in user.experiencia) {
                            print('CAMPOS: ${item}');
                          }
                  
                  //print(experienciaParaWidget);
              
             // print(user.experiencia);

             final respuesta = await perfilBloc.editarExperienciaDelUsuario(user);
              print('Respuesta: ${respuesta}');
              mostrarSnackBar('Datos actualizados exitosamente');
              experienciaParaWidget = [];
              setState(() {
                          _tituloExperienciaController.clear();
                          _empresaExperienciaController.clear();
                          _inicioExperienciaController.clear();
                          _finExperienciaController.clear();
                          _descripcionExperienciaController.clear();
                       });
               Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'editarexperiencia');

            },
            child: Text(
              "Añadir Experiencia",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
      },
    );
  }

  _formEditExperiencia(){
    return Column(
      children: [
        Column(
          children: <Widget>[
            TextField(
              controller: _tituloExperienciaController,
              decoration: InputDecoration(
                icon: Icon(Icons.title),
                labelText: 'Titulo',
              ),
            ),
            
            //PASAR A UN NUEVO ARCHIVO PARA EDITAR Y AGREGAR DATOS
                    _crearCheckBox(),
            

                      (_blouearCheck == false)
                      ? _crearFecha(context): Container(),
           

            TextField(
              controller: _empresaExperienciaController,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Empresa',
              ),
            ),

            TextField(
              controller: _finExperienciaController,
              decoration: InputDecoration(
                icon: Icon(Icons.calendar_month),
                labelText: 'Fecha final',
              ),
            ),

            TextField(
              controller: _descripcionExperienciaController,
              decoration: InputDecoration(
                icon: Icon(Icons.description),
                labelText: 'Descripción',
              ),
            ),
          ],
        ),
        RaisedButton(
          color: Color.fromRGBO(29, 53, 87, 1.0),
          onPressed: () async{
            
              
              for (var i = 0; i < experienciaList.length; i++) {
                                //print(experienciaList[i]);
                              if(experienciaList[i].toString().contains(result)){
                                //print('removed ${experienciaList[i]}');
                              experienciaList.remove(experienciaList[i]);
                              }
                        }

                        experienciaParaWidget = [];

                        for (var i = 0; i < experienciaList.length; i++) {
                               // print('new ${experienciaList[i]}');
                             
                        }

                        for (var i = 0; i < experienciaList.length; i++) {

                            expEliminada = Experiencia(
                            id: experienciaList[i]['_id'],
                            titulo: experienciaList[i]['titulo'],
                            empresa: experienciaList[i]['empresa'],
                            fechaInicio: DateTime.parse(experienciaList[i]['fechaInicio'].toString()),
                            fechaFin: experienciaList[i]['fechaFin'],
                            descripcion: experienciaList[i]['descripcion']);
                          
                            experienciaParaWidget.add(expEliminada);
                        }
              

              expEliminadaNuevamenteAgregada = Experiencia(
                            id: result,
                            titulo: _tituloExperienciaController.text.toString(),
                            empresa: _empresaExperienciaController.text.toString(),
                            fechaInicio: DateTime.parse(_inicioExperienciaController.text.toString()),
                            fechaFin: _finExperienciaController.text.toString(),
                            descripcion: _descripcionExperienciaController.text.toString());

                      //agregarExperiencia(experienciaParaWidget, exp);

                 experienciaParaWidget.add(expEliminadaNuevamenteAgregada);

                  user.experiencia = experienciaParaWidget;

                   for (var item in user.experiencia) {
                            print('CAMPOS: ${item.titulo}');
                          }

            final respuesta = await perfilBloc.editarExperienciaDelUsuario(user);
              print('Respuesta: ${respuesta}');
              mostrarSnackBar('Datos actualizados exitosamente');
             
              setState(() {
                          _tituloExperienciaController.clear();
                          _empresaExperienciaController.clear();
                          _inicioExperienciaController.clear();
                          _finExperienciaController.clear();
                          _descripcionExperienciaController.clear();
                       });
               Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'editarexperiencia');

            },
            child: Text(
              "Añadir Experiencia",
              style: TextStyle(color: Colors.white, fontSize: 12,), textAlign: TextAlign.center,
            ),
        ),
      ],
    );
  }


/*_switchLis(){
  return SwitchListTile(
    value: _blouearCheck,
    title: Text('Trabajo Actual'), 
    onChanged: (value) => {
    setState((){
      _blouearCheck = value;
      print(_blouearCheck);
    })
  }
  );
}*/
    _crearCheckBox() {
    return Row(
      children: [
        Checkbox(
            value: _blouearCheck,
            onChanged: (value) {
                  if(mounted) {
                    setState(() {
                      _blouearCheck = value!;
                      _fecha = DateTime.now().toString();
                      _inicioExperienciaController.text = DateTime.now().toString();
                      print(_inicioExperienciaController.text.toString());
                    });
                  }
                  }),
                  Text('Trabajo Actual')
      ],
    );
  }

    _crearFecha(BuildContext context) {
    return TextFormField(
      controller: _inicioExperienciaController,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
                icon: Icon(Icons.calendar_month),
                labelText: 'Fecha Inicio',
              ),
      onTap: () {
        FocusScope.of(context).requestFocus( FocusNode());
        _selectDate(context);
        
      },
      validator: (value) {
        if (value!.length <= 0) {
          return 'Ingrese la fecha de visita';
        } else {
          return null;
        }
      },
    );
  }

    _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate:  DateTime.now(),
        firstDate:  DateTime.now(),
        lastDate:  DateTime(2030),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      String fechaFormateada = DateFormat('yyyy-MM-dd').format(picked);
      if(mounted) {
        setState(() {
        _fecha = fechaFormateada;
        _inicioExperienciaController.text = _fecha;
        //visitaModel.fecha = picked;
      });
      }
    } else {
      if(mounted) {
        setState(() {
        _inicioExperienciaController.text = _fechaActual(tiempo);
      });
      }
    }
  }




List<Experiencia> agregarExperiencia(List<Experiencia> list, Experiencia subject) {
  if (list.contains(subject)) {
    list.remove(subject);
    return list;
  } else {
    list.add(subject);
    return list;
  }
}

 String _fechaActual(DateTime fecha) {
    String fechaFormateada = DateFormat('yyyy-MM-dd').format(fecha);
    return fechaFormateada;
  }


  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1800),
      backgroundColor: Color.fromRGBO(29, 53, 87, 1.0),
    );
    scaffoldKey.currentState!.showSnackBar(snackbar);
  }
}
Widget _buildSwitchListTile(
    String title,
    String description,
    bool currentValue,
    Function(bool) updateValue, // changed from Function updateValue
  ) {
    return SwitchListTile(
      title: Text(title),
      value: currentValue,
      subtitle: Text(
        description,
      ),
      onChanged: updateValue, // changed from (value) => updateValue
    );
  }