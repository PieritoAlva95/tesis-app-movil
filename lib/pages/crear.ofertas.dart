import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobsapp/models/ofert.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/oferta.provider.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';

class CrearOfertaPage extends StatefulWidget {
  @override
  _CrearOfertaPageState createState() => _CrearOfertaPageState();
}

class _CrearOfertaPageState extends State<CrearOfertaPage> {
  final estiloTitulo = TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold);
  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Oferta oferta = Oferta(fechaCreacion: DateTime.now(), interesados: []);
  Map<String, dynamic> dataOferta = {};

  final ofertaProvider = OfertaProvider();
  final preferencias = PreferenciasUsuario();

  bool guardando = false;

  DateTime tiempo = new DateTime.now();

  final List<String> _tipoPago = [
    'Mensual',
    'Quincenal',
    'Semanal',
    'Por Hora',
    'Contrato'
  ];
  String opcionDePagoSeleccionada = "Contrato";

  String opcionDeCategoriaSeleccionada = "Otros";

  UsuariosProvider userProvider = UsuariosProvider();
  String result = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Now you can use your decoded token
    oferta.usuario = preferencias.idUsuario;
    oferta.nombreUsuario = preferencias.nombres;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Agregar Oferta'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    preferencias.token.toString().length > 0
                        ? _crearBanerSolicitarVisita()
                        : Container(),
                    SizedBox(
                      height: 20.0,
                    ),
                    preferencias.token.toString().length > 0
                        ? _crearBoton()
                        : _botonRedirigirLogin(),
                    SizedBox(
                      height: 20.0,
                    ),
                    //_crearDisponible()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _botonRedirigirLogin() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
        child: Text('Iniciar sesión'.toUpperCase()),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 10.0,
      color: Colors.blueAccent,
      textColor: Colors.white,
      onPressed: () {
        Navigator.pop(context);
        Navigator.of(context)
            .pushNamedAndRemoveUntil('login', (route) => false);
      },
    );
  }

  _crearBanerSolicitarVisita() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 50.0),
      child: Column(
        children: [
          Text(
            'Añadir Oferta de Trabajo',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Color.fromRGBO(53, 80, 112, 1.0)),
          ),
          Divider(),
          SizedBox(
            height: 40.0,
          ),
          _crearTituloDeLaOferta(),
          SizedBox(
            height: 10.0,
          ),
          _crearDescripcionDeLaOferta(),
          SizedBox(
            height: 10.0,
          ),
          _crearPrecioDeLaOferta(),
          SizedBox(
            height: 10.0,
          ),
          ListTile(
            title: Text(
              'Tipo Pago',
              style: TextStyle(fontSize: 15.0),
            ),
            trailing: _crearDropDownTipoPago(),
          ),
          ListTile(
            title: Text(
              'Categoría',
              style: TextStyle(fontSize: 15.0),
            ),
            trailing: _crearDropDownCategoria(),
          ),
        ],
      ),
    );
  }

  _crearTituloDeLaOferta() {
    return TextFormField(
      initialValue: oferta.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: ('Título'),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      onSaved: (value) => oferta.titulo = value!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Ingrese un título';
        } else {
          return null;
        }
      },
    );
  }

  _crearDescripcionDeLaOferta() {
    return TextFormField(
      initialValue: oferta.cuerpo,
      textCapitalization: TextCapitalization.sentences,
      maxLines: 4,
      decoration: InputDecoration(
          labelText: ('Descripción'),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      onSaved: (value) => oferta.cuerpo = value!,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Ingrese una descripción';
        } else {
          return null;
        }
      },
    );
  }

  _crearPrecioDeLaOferta() {
    return TextFormField(
      initialValue: oferta.precio.toString(),
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          labelText: ('Precio'),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      onSaved: (value) => oferta.precio = value.toString(),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Ingrese el precio';
        } else {
          return null;
        }
      },
    );
  }

  List<DropdownMenuItem<String>> getDropDown() {
    List<DropdownMenuItem<String>> lista = [];
    _tipoPago.forEach((opcion) {
      lista.add(DropdownMenuItem(
        child: Text(opcion),
        value: opcion,
      ));
    });

    return lista;
  }

  Widget _crearDropDownTipoPago() {
    return DropdownButton<String>(
      value: opcionDePagoSeleccionada,
      isExpanded: false,
      hint: Container(
        alignment: Alignment.centerRight,
        width: 160,
      ),
      elevation: 16,
      style: const TextStyle(color: Color.fromRGBO(53, 80, 112, 1.0)),
      underline: Container(
        height: 2,
        color: Color.fromRGBO(53, 80, 112, 1.0),
      ),
      items: getDropDown(),
      onChanged: (String? opt) {
        setState(() {
          opcionDePagoSeleccionada = opt!;
          oferta.tipoPago = opcionDePagoSeleccionada;
        });
      },
    );
  }

  Widget _crearDropDownCategoria() {
    return DropdownButton<String>(
      value: opcionDeCategoriaSeleccionada,
      isExpanded: false,
      hint: Container(
        alignment: Alignment.centerRight,
        width: 120,
      ),
      elevation: 16,
      style: const TextStyle(color: Color.fromRGBO(53, 80, 112, 1.0)),
      underline: Container(
        height: 2,
        color: Color.fromRGBO(53, 80, 112, 1.0),
      ),
      items: [
        DropdownMenuItem(
            child: Text("Albañilería / Construcción"), value: "Construccion"),
        DropdownMenuItem(
          child: Text("Trabajos Domésticos"),
          value: "Trabajos Domesticos",
        ),
        DropdownMenuItem(
          child: Text("Carpintería"),
          value: "Carpinteria",
        ),
        DropdownMenuItem(
          child: Text("Plomería"),
          value: "Plomeria",
        ),
        DropdownMenuItem(
          child: Text("Electricidad"),
          value: "Electricidad",
        ),
        DropdownMenuItem(
          child: Text("Atención al cliente"),
          value: "Atencion al cliente",
        ),
        DropdownMenuItem(
          child: Text("Vendedor/a"),
          value: "Vendedor",
        ),
        DropdownMenuItem(
          child: Text("Servicios Informáticos"),
          value: "Servicios Informaticos",
        ),
        DropdownMenuItem(
          child: Text("Servicios Profesionales"),
          value: "Servicios Profesionales",
        ),
        DropdownMenuItem(
          child: Text("Otros"),
          value: "Otros",
        )
      ],
      onChanged: (String? opt) {
        setState(() {
          opcionDeCategoriaSeleccionada = opt!;
          oferta.categoria = opcionDeCategoriaSeleccionada;
        });
      },
    );
  }

  _crearBoton() {
    return RaisedButton.icon(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color.fromRGBO(53, 80, 112, 1.0),
        textColor: Colors.white,
        icon: Icon(Icons.send),
        label: Text(
          'Añadir Oferta',
          style: TextStyle(fontSize: 15.0),
        ),
        onPressed: _submit);
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();
    if (mounted)
      setState(() {
        guardando = true;
      });

    ofertaProvider.crearOferta(oferta);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => DashboardPage()),
        (Route<dynamic> route) => false);
  }
}
