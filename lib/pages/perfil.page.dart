import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jobsapp/bloc/perfil_bloc.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/user.model.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool circularProgress = false;
  PerfilBloc perfilBloc = PerfilBloc();
  final usuarioProvider = UsuariosProvider();
  final preferencias = PreferenciasUsuario();

  final Usuario usuario = Usuario(
    skills: [],
    experiencia: [],
    estudios: [],
    fechaCreacion: DateTime.now(),
    redesSociales: RedesSociales(),
  );

  Map<String, dynamic> data = {};
  List redesSocialesParaWidget = [];
  List<String> skillsParaWidget = [];

  String idObtenido = '';

  final String _url = URLFOTO;

  void launchWhatsApp({
    required int phone,
    required String message,
  }) async {
    String url() {
      if (Platform.isAndroid) {
        // add the [https]
        return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
      } else {
        // add the [https]
        return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'No se puede realizar esta acción ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    perfilBloc = Provider.perfilBloc(context)!;
    final idPersonaInteresada = ModalRoute.of(context)!.settings.arguments;

    if (idPersonaInteresada != null) {
      final primero = idPersonaInteresada.toString().replaceFirst('{', '');
      final pos = primero.length - 1;
      idObtenido = primero.substring(0, pos);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Perfil de usuario'),
        ),
        key: scaffoldKey,
        //drawer: MenuWidget(),
        body: Form(
          key: _globalKey,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            children: [
              FutureBuilder(
                future: idObtenido.toString().isEmpty
                    ? perfilBloc.cargarUsuario()
                    : perfilBloc.cargarUsuarioEspecifico(idObtenido.toString()),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  redesSocialesParaWidget = [];
                  skillsParaWidget = [];

                  if (snapshot.hasError) {
                    print("eroro: " + snapshot.hasError.toString());
                  }
                  if (snapshot.hasData && snapshot.data!['usuario'] != null) {
                    usuario.nombres = snapshot.data!['usuario']['nombres'];
                    usuario.apellidos = snapshot.data!['usuario']['apellidos'];
                    usuario.email = snapshot.data!['usuario']['email'];
                    usuario.numeroDeCelular =
                        snapshot.data!['usuario']['numeroDeCelular'];
                    usuario.experiencia =
                        snapshot.data!['usuario']['experiencia'];
                    usuario.estudios = snapshot.data!['usuario']['estudios'];
                    usuario.img = snapshot.data!['usuario']['img'];
                    usuario.bio = snapshot.data!['usuario']['bio'].toString();

                    for (var item in snapshot.data!['usuario']['skills']) {
                      skillsParaWidget.add(item);
                    }
                    usuario.skills = skillsParaWidget;

                    data = snapshot.data!['usuario']['redesSociales'];

                    for (var item in data.values) {
                      if (item.toString().isNotEmpty) {
                        redesSocialesParaWidget.add(item);
                      }
                    }

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(29, 53, 87, 1.0),
                                Color.fromRGBO(29, 53, 87, 1.0),
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 80.0,
                                backgroundImage:
                                    usuario.img.toString().isNotEmpty
                                        ? NetworkImage(_url + usuario.img)
                                        : NetworkImage(urlPhotoUserNotFound),
                                backgroundColor: Colors.blueAccent,
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 15.0,
                                ),
                                child: Text(
                                  usuario.nombres.toString() +
                                      ' ' +
                                      usuario.apellidos.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Text(
                                usuario.email.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10.0),
                              InkWell(
                                onTap: () {
                                  if (usuario.numeroDeCelular
                                      .toString()
                                      .isNotEmpty) {
                                    launchWhatsApp(
                                        phone: int.parse(
                                            '+593' + usuario.numeroDeCelular),
                                        message: 'Hola desde JobsApp');
                                  }
                                },
                                child: Text(
                                  '${usuario.numeroDeCelular.toString()} Contactame por Whatsapp!',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              _redesSociales(),
                              const SizedBox(height: 25.0),
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Text(
                                      'Biografía',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          usuario.bio,
                                          style: const TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    const Text(
                                      'Habilidades',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    _skillsWidget(),
                                    const SizedBox(
                                      height: 30.0,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromRGBO(29, 53, 87, 1.0),
                                width: 2.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Experiencia',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Color.fromRGBO(29, 53, 87, 1.0),
                                ),
                              ),
                              _recorrerExperiencia(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromRGBO(29, 53, 87, 1.0),
                                width: 2.0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                'Estudios',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Color.fromRGBO(29, 53, 87, 1.0),
                                ),
                              ),
                              _recorrerEstudios(),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Container(
                          color: Colors.transparent,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 45.0,
                                ),
                                const Text("No hay información del perfil",
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromRGBO(29, 53, 87, 1.0))),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                FadeInImage(
                                  placeholder: NetworkImage(SEARCHNOTFOUND),
                                  image: NetworkImage(SEARCHNOTFOUND),
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
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
        ));
  }

  _redesSociales() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: redesSocialesParaWidget
            .map((item) => Row(
                  children: [
                    const SizedBox(
                      width: 25.0,
                    ),
                    InkWell(
                      onTap: () async {
                        await launch(item);
                      },
                      child: _itemRedesSociales(item),
                    ),
                  ],
                ))
            .toList());
  }

  _itemRedesSociales(String value) {
    if (value.contains('facebook')) {
      return const FadeInImage(
        placeholder: AssetImage('assets/icons/facebook.png'),
        image: AssetImage('assets/icons/facebook.png'),
        height: 20.0,
      );
    }
    if (value.contains('twitter')) {
      return const FadeInImage(
        placeholder: AssetImage('assets/icons/twitter.png'),
        image: AssetImage('assets/icons/twitter.png'),
        height: 20.0,
      );
    }
    if (value.contains('linkedin')) {
      return const FadeInImage(
        placeholder: AssetImage('assets/icons/linkedin.png'),
        image: AssetImage('assets/icons/linkedin.png'),
        height: 20.0,
      );
    }
    if (value.contains('instagram')) {
      return const FadeInImage(
        placeholder: AssetImage('assets/icons/instagram.png'),
        image: AssetImage('assets/icons/instagram.png'),
        height: 20.0,
      );
    }
    if (value.isEmpty) {
      return Container();
    }
  }

  _recorrerExperiencia() {
    return Column(
        children: usuario.experiencia
            .map<Widget>((experiencia) =>
                //Mostar items
                Column(
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      experiencia['titulo'],
                      style: const TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      experiencia['fechaInicio'] +
                          ' | ' +
                          experiencia['fechaFin'],
                      style: const TextStyle(fontSize: 11.0),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      experiencia['empresa'],
                      style: const TextStyle(
                          fontSize: 11.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      experiencia['descripcion'],
                      style: const TextStyle(fontSize: 11.0),
                      textAlign: TextAlign.justify,
                    ),
                    const Divider(),
                  ],
                ))
            .toList());
  }

  _recorrerEstudios() {
    return Column(
      children: usuario.estudios
          .map<Widget>(
            (experiencia) =>
                //Mostar items
                Column(
              children: [
                const SizedBox(height: 5.0),
                Text(
                  experiencia['titulo'],
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  experiencia['fechaInicio'] + ' | ' + experiencia['fechaFin'],
                  style: const TextStyle(fontSize: 11.0),
                ),
                const SizedBox(height: 5.0),
                Text(
                  experiencia['nombreInstitucion'],
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  experiencia['descripcion'],
                  style: const TextStyle(fontSize: 11.0),
                  textAlign: TextAlign.justify,
                ),
                const Divider(),
              ],
            ),
          )
          .toList(),
    );
  }

  _skillsWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(right: 25.0),
      child: Row(
        children: usuario.skills
            .map(
              (item) => Row(
                children: [
                  const SizedBox(width: 25.0),
                  const Icon(
                    Icons.check_box,
                    color: Colors.white,
                  ),
                  Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
