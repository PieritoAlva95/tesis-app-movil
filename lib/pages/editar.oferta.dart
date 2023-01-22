import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/oferta.bloc.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/ofert.model.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';

class EditarOfertaPage extends StatefulWidget {
  const EditarOfertaPage({Key? key}) : super(key: key);

  @override
  _EditarOfertaPageState createState() => _EditarOfertaPageState();
}

class _EditarOfertaPageState extends State<EditarOfertaPage> {
  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  OfertaBloc ofertaBloc = OfertaBloc();
  final preferencias = PreferenciasUsuario();

  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _cuerpoController = TextEditingController();
  final TextEditingController _tipoPagoController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  String id = '';
  String result = '';

  //DropDown
  final List<String> _tipoPago = [
    'Mensual',
    'Quincenal',
    'Semanal',
    'Por Hora',
    'Contrato'
  ];
  String opcionDePagoSeleccionada = "Contrato";
  String opcionDeCategoriaSeleccionada = "Otros";
  Oferta oferta = Oferta(fechaCreacion: DateTime.now(), interesados: []);

  @override
  void initState() {
    super.initState();
    oferta.usuario = preferencias.idUsuario;
    oferta.nombreUsuario = preferencias.nombres;
  }

  @override
  Widget build(BuildContext context) {
    ofertaBloc = Provider.ofertaBloc(context)!;

    final contratoObtenido = ModalRoute.of(context)!.settings.arguments;
    final primero = contratoObtenido.toString().replaceFirst('{', '');
    final pos = primero.length - 1;
    result = primero.substring(0, pos);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Oferta'),
      ),
      key: scaffoldKey,
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          children: [
            FutureBuilder(
              future: ofertaBloc.cargarOfertaEspecifica(result),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasError) {
                  print("eroro: " + snapshot.hasError.toString());
                }
                if (snapshot.hasData && snapshot.data!['oferta'] != null) {
                  _tituloController.text = snapshot.data!['oferta']['titulo'];
                  _cuerpoController.text = snapshot.data!['oferta']['cuerpo'];
                  _precioController.text =
                      snapshot.data!['oferta']['precio'].toString();
                  _tipoPagoController.text =
                      snapshot.data!['oferta']['tipoPago'];
                  _categoriaController.text =
                      snapshot.data!['oferta']['categoria'];
                  opcionDeCategoriaSeleccionada =
                      snapshot.data!['oferta']['categoria'];
                  opcionDePagoSeleccionada =
                      snapshot.data!['oferta']['tipoPago'];
                  return Column(
                    children: [
                      _crearTitulo(ofertaBloc),
                      const SizedBox(height: 15.0),
                      _crearCuerpo(ofertaBloc),
                      const SizedBox(height: 15.0),
                      _crearPrecio(ofertaBloc),
                      const SizedBox(height: 15.0),
                      ListTile(
                        title: const Text(
                          'Tipo Pago',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        trailing: _crearDropDownTipoPago(),
                      ),
                      ListTile(
                        title: const Text(
                          'Categoría',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        trailing: _crearDropDownCategoria(),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _crearBoton(ofertaBloc),
                        ],
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: Container(
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Column(
                          children: const [
                            SizedBox(height: 80.0),
                            Text(
                              "No hay información de la ofertas",
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(53, 80, 112, 1.0),
                              ),
                            ),
                            SizedBox(height: 30.0),
                            FadeInImage(
                              placeholder:
                                  AssetImage('assets/img/buscando.png'),
                              image: AssetImage('assets/img/buscando.png'),
                              fit: BoxFit.cover,
                            ),
                            SizedBox(height: 30.0),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  _crearBoton(OfertaBloc bloc) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            elevation: const MaterialStatePropertyAll(5.0),
            backgroundColor: const MaterialStatePropertyAll(
              Color.fromRGBO(53, 80, 112, 1.0),
            ),
            // textColor: ,
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
          ),
          child: Text('Actualizar Oferta'.toUpperCase()),
          onPressed: () => {
            _editarPerfilUsuario(context, bloc),
            Navigator.pushReplacementNamed(context, 'dashboard')
          },
        );
      },
    );
  }

  _editarPerfilUsuario(BuildContext context, OfertaBloc bloc) async {
    if (!_globalKey.currentState!.validate()) return;

    oferta.titulo = _tituloController.text.toString();
    oferta.cuerpo = _cuerpoController.text.toString();
    oferta.tipoPago = _tipoPagoController.text.toString();
    oferta.precio = _precioController.text.toString();
    oferta.categoria = _categoriaController.text.toString();

    final respuesta = await ofertaBloc.editarOferta(oferta, result);
    
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, 'dashboard');

    _tituloController.dispose();
    _cuerpoController.dispose();
    _tipoPagoController.dispose();
    _precioController.dispose();
    _categoriaController.dispose();
  }

  _crearTitulo(OfertaBloc bloc) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              onSaved: (value) => _tituloController.text = value!,
              controller: _tituloController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                icon: const Icon(
                  Icons.title,
                  color: Color.fromRGBO(53, 80, 112, 1.0),
                ),
                labelText: 'Título',
                counterText: snapshot.data,
              ),
            ));
      },
    );
  }

  _crearCuerpo(OfertaBloc bloc) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              maxLines: 4,
              onSaved: (value) => _cuerpoController.text = value!,
              controller: _cuerpoController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                icon: const Icon(
                  Icons.description,
                  color: Color.fromRGBO(53, 80, 112, 1.0),
                ),
                labelText: 'Descripción',
                counterText: snapshot.data,
              ),
            ));
      },
    );
  }

  List<DropdownMenuItem<String>> getDropDown() {
    List<DropdownMenuItem<String>> lista = [];
    for (var opcion in _tipoPago) {
      lista.add(
        DropdownMenuItem(
          child: Text(opcion),
          value: opcion,
        ),
      );
    }
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
        color: const Color.fromRGBO(53, 80, 112, 1.0),
      ),
      items: getDropDown(),
      onChanged: (String? opt) {
        setState(() {
          opcionDePagoSeleccionada = opt!;
          _precioController.text = opcionDePagoSeleccionada;
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
        color: const Color.fromRGBO(53, 80, 112, 1.0),
      ),
      items: const [
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
          _categoriaController.text = opcionDeCategoriaSeleccionada;
        });
      },
    );
  }

  _crearPrecio(OfertaBloc bloc) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (value) => _precioController.text = value!,
            controller: _precioController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.monetization_on_rounded,
                color: Color.fromRGBO(53, 80, 112, 1.0),
              ),
              labelText: 'Precio',
              counterText: snapshot.data,
            ),
          ),
        );
      },
    );
  }
}
