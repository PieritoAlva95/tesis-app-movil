import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/perfil_bloc.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/experiencia.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;


class EditarExperienciaPage extends StatefulWidget {
  @override
  _EditarExperienciaPageState createState() => _EditarExperienciaPageState();
}

class _EditarExperienciaPageState extends State<EditarExperienciaPage> {


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


  Future<void> verificarToken() async{
    bool verify = await usuarioProvider.verificarToken();
    if(verify){
      estaLogueado = false;
      preferencias.clear();
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => DashboardPage()), (Route<dynamic> route) => false); 
    }else{
      estaLogueado = true;
      print('Token válido ${preferencias.token}');
    }
  }


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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      verificarToken();
    });
  }


  String id = '';
  String fotoUser = '';

  @override
  Widget build(BuildContext context) {
    perfilBloc = Provider.perfilBloc(context)!;

    return Scaffold(
        appBar: AppBar(
          title: Text('Experiencia'),
          actions: [
            _botonAgregarHabilidad(context)
          ],
        ),
        key: scaffoldKey,
        //drawer: MenuWidget(),
        body: 
            Form(
              key: _globalKey,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                children: [
                  FutureBuilder(
                    future: perfilBloc.cargarUsuario(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {

                      experienciaParaWidget = [];

                      if (snapshot.hasError) {
                        print("eroro: " + snapshot.hasError.toString());
                      }
                      if (snapshot.hasData && snapshot.data!['usuario'] != null) {
           
                        experienciaList = snapshot.data!['usuario']['experiencia'];

                        print('user experience:${snapshot.data!['usuario']['uid']}');
                        
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
                            print(item.id);
                          }
                          
              
                        return Column(
                          children: [
                            _recorrerExperiencia(),
                            
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

 _recorrerExperiencia() {
    return Column(
        children: experienciaParaWidget
            .map<Widget>((experiencia) =>
                //Mostar items
                Column(
                  children: [
                    SizedBox(height: 5.0,),
                    Text(experiencia.titulo, style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),),
                    SizedBox(height: 5.0,),
                    Text(experiencia.descripcion, style: TextStyle(fontSize: 11.0, color: Color.fromRGBO(53, 80, 112, 2.0)), textAlign: TextAlign.justify,),
                    SizedBox(height: 10.0,),
                    Row(
                      children: [
                        Text('Fecha de inicio: ', style: TextStyle(color: Color.fromRGBO(53, 80, 112, 2.0), fontWeight: FontWeight.bold),),
                        Text(DateFormat('yyyy-MM-dd').format(experiencia.fechaInicio), style: TextStyle(color: Color.fromRGBO(53, 80, 112, 2.0)),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      children: [
                        Text('Fecha fin: ', style: TextStyle(color: Color.fromRGBO(53, 80, 112, 2.0), fontWeight: FontWeight.bold),),
                        Text(experiencia.fechaFin, style: TextStyle(color: Color.fromRGBO(53, 80, 112, 2.0)),),
                      ],
                    ),
                    SizedBox(height: 5.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(
                          onPressed: (){
                            Navigator.pushNamed(context, 'editexp',
                            arguments: {experiencia.id});
                          },/*{
                            print(experiencia.id);


                            _tituloExperienciaController.text = experiencia.titulo.toString();
                            _inicioExperienciaController.text = experiencia.fechaInicio.toString();
                            _empresaExperienciaController.text = experiencia.empresa.toString();
                            _finExperienciaController.text = experiencia.fechaFin.toString();
                            _descripcionExperienciaController.text = experiencia.descripcion.toString();
                            
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
            
            //PASAR A UN NUEVO ARCHIVO PARA EDITAR Y AGREGAR DATOS
            BottomSwitchListTile(bloquear: _blouearCheck),   

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
          DialogButton(color: Colors.red[900],
                     onPressed: () {
                       
                       setState(() {
                          _tituloExperienciaController.clear();
                          _empresaExperienciaController.clear();
                          _inicioExperienciaController.clear();
                          _finExperienciaController.clear();
                          _descripcionExperienciaController.clear();
                       });
                       Navigator.of(context).pop();
                     },
                     child: Text("Cancelar",
                      style: TextStyle(
                      color: Colors.white, fontSize: 12),),
                      ),
          DialogButton(
            onPressed: () async{
              
              for (var i = 0; i < experienciaList.length; i++) {
                                //print(experienciaList[i]);
                              if(experienciaList[i].toString().contains(experiencia.id)){
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
                            id: experiencia.id,
                            titulo: _tituloExperienciaController.text.toString(),
                            empresa: _empresaExperienciaController.text.toString(),
                            fechaInicio: DateTime.parse(_inicioExperienciaController.text.toString()),
                            fechaFin: _finExperienciaController.text.toString(),
                            descripcion: _descripcionExperienciaController.text.toString());

                      //agregarExperiencia(experienciaParaWidget, exp);

                 experienciaParaWidget.add(expEliminadaNuevamenteAgregada);

                  user.experiencia = experienciaParaWidget;

                   for (var item in user.experiencia) {
                            print('CAMPOS: ${item.id}');
                          }

            /* final respuesta = await perfilBloc.editarExperienciaDelUsuario(user);
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
              Navigator.pushReplacementNamed(context, 'editarexperiencia');*/

            },
            child: Text(
              "Añadir Experiencia",
              style: TextStyle(color: Colors.white, fontSize: 12,), textAlign: TextAlign.center,
            ),
          ),
          
              ]).show();


     },*/
     child: Icon(Icons.edit),
       ),
                        FlatButton(
                          onPressed: () async{

                            for (var i = 0; i < experienciaList.length; i++) {
                                //print(experienciaList[i]);
                              if(experienciaList[i].toString().contains(experiencia.id)){
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

                        user.experiencia = experienciaParaWidget;
                   
                  

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


                          },
                          child: Image.asset('assets/img/delete.png', height: 25.0),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                )
                )
            .toList());
  }

  _printBlos(){
    print(_blouearCheck);
  }

_switchLis(){
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
}
    _crearCheckBox() {
    return Checkbox(
        value: _blouearCheck,
        onChanged: (value) {
              if(mounted)
                setState(() {
                  _blouearCheck = value!;
                });
              });
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
        lastDate:  DateTime(2025),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      String fechaFormateada = DateFormat('yyyy-MM-dd').format(picked);
      if(mounted)
      setState(() {
        _fecha = fechaFormateada;
        _inicioExperienciaController.text = _fecha;
        //visitaModel.fecha = picked;
      });
    } else {
      if(mounted)
      setState(() {
        _inicioExperienciaController.text = _fechaActual(tiempo);
      });
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