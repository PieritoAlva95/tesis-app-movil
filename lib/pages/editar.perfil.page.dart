import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobsapp/bloc/perfil_bloc.dart';
import 'package:jobsapp/bloc/provider.dart';
import 'package:jobsapp/models/user.model.dart';
import 'package:jobsapp/pages/dashboard.page.dart';
import 'package:jobsapp/provider/usuario.provider.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/utils.dart';

class EditarPerfilPage extends StatefulWidget {
  const EditarPerfilPage({Key? key}) : super(key: key);

  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {
  Map<String, dynamic> dataRedesSociales = {};
  List<String> skillsParaWidget = [];
  PickedFile _imageFile = PickedFile('');
  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  bool circularProgress = false;
  PerfilBloc perfilBloc = PerfilBloc();
  final usuarioProvider = UsuariosProvider();
  final preferencias = PreferenciasUsuario();
  Usuario user = Usuario(
    skills: [],
    fechaCreacion: DateTime.now(),
    experiencia: [],
    estudios: [],
    redesSociales: RedesSociales(),
  );
  bool estaLogueado = false;
  final String _url = URLFOTO;
  Future<void> verificarToken() async {
    bool verify = await usuarioProvider.verificarToken();
    if (verify) {
      estaLogueado = false;
      preferencias.clear();
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => DashboardPage(),
          ),
          (Route<dynamic> route) => false);
    } else {
      estaLogueado = true;
      print('Token válido ${preferencias.token}');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      verificarToken();
    });
  }

  final TextEditingController _nombresController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _biografiaController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _habilidadesController = TextEditingController();

  String id = '';
  String fotoUser = '';

  @override
  Widget build(BuildContext context) {
    perfilBloc = Provider.perfilBloc(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil de usuario'),
      ),
      key: scaffoldKey,
      //drawer: MenuWidget(),
      body: Form(
        key: _globalKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20.0,
          ),
          children: [
            FutureBuilder(
              future: perfilBloc.cargarUsuario(),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                if (snapshot.hasError) {
                  print("eroro: " + snapshot.hasError.toString());
                }
                if (snapshot.hasData && snapshot.data!['usuario'] != null) {
                  _nombresController.text =
                      snapshot.data!['usuario']['nombres'];
                  _apellidosController.text =
                      snapshot.data!['usuario']['apellidos'];
                  _biografiaController.text =
                      snapshot.data!['usuario']['bio'].toString();
                  _celularController.text =
                      snapshot.data!['usuario']['numeroDeCelular'].toString();
                  _emailController.text =
                      snapshot.data!['usuario']['email'].toString();

                  for (var item in snapshot.data!['usuario']['skills']) {
                    skillsParaWidget.add(item);
                  }
                  user.skills = skillsParaWidget;

                  if (snapshot.data!['usuario']['img'].toString().isNotEmpty) {
                    fotoUser = snapshot.data!['usuario']['img'];
                  } else {
                    fotoUser = URLFOTOPERFIL;
                  }
                  return Column(
                    children: [
                      actualizarImagenPerfilUsuario(),
                      _imageFile.path.isNotEmpty
                          ? _crearBotonActualizarFoto()
                          : Container(),
                      _crearNombre(perfilBloc),
                      const SizedBox(height: 15.0),
                      _crearApellido(perfilBloc),
                      const SizedBox(height: 15.0),
                      _crearbiografia(perfilBloc),
                      const SizedBox(height: 15.0),
                      _crearCelular(perfilBloc),
                      const SizedBox(height: 15.0),
                      _crearemail(perfilBloc),
                      const SizedBox(height: 15.0),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _crearBoton(perfilBloc),
                        ],
                      ),
                    ],
                  );
                } else {
                  print("no hay datos ");
                  return Center(
                    child: Container(
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Column(
                          children: const [
                            SizedBox(height: 45.0),
                            Text(
                              "No hay información del perfil",
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
                            SizedBox(height: 15.0),
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

  _crearBoton(PerfilBloc bloc) {
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
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
          ),
          child: Text('Actualizar Perfil'.toUpperCase()),
          onPressed: () => _editarPerfilUsuario(context, bloc),
        );
      },
    );
  }

  _crearBotonActualizarFoto() {
    return (_imageFile == null)
        ? Container()
        : ElevatedButton(
            style: ButtonStyle(
              padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15.0,
                ),
              ),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              elevation: const MaterialStatePropertyAll(4.0),
              backgroundColor: const MaterialStatePropertyAll(
                Color.fromRGBO(29, 53, 87, 1.0),
              ),
              foregroundColor: const MaterialStatePropertyAll(Colors.white),
            ),
            child: const Text('Actualizar imagen'),
            onPressed: _imageFile != null
                ? () async {
                    if (mounted) {
                      setState(
                        () {
                          circularProgress = true;
                        },
                      );
                    }
                    if (_imageFile.path != null) {
                      var imagenResponse =
                          await perfilBloc.actualizarImagen(_imageFile.path);
                      mostrarSnackBar('Imagen actualizada exitosamente');
                      Navigator.pushReplacementNamed(context, 'verperfil');
                      if (imagenResponse.statusCode == 200) {
                        if (mounted) {
                          setState(
                            () {
                              circularProgress = false;
                              _imageFile = PickedFile('');
                            },
                          );
                        }
                      }
                    } else {
                      if (mounted) {
                        setState(
                          () {
                            circularProgress = false;
                          },
                        );
                      }
                    }
                  }
                : null,
          );
  }

  _editarPerfilUsuario(BuildContext context, PerfilBloc bloc) async {
    if (!_globalKey.currentState!.validate()) return;

    user.nombres = _nombresController.text.toString();
    user.apellidos = _apellidosController.text.toString();
    user.bio = _biografiaController.text.toString();
    user.numeroDeCelular = _celularController.text.toString();
    user.email = _emailController.text.toString();

    final respuesta = await perfilBloc.editarDatosDelPerfilUsuario(user);
    if (respuesta['ok'] == true) {
      print('USER WIDGET: ${user.esAdmin}');
      print('Respuesta: ${respuesta}');
      Navigator.pushReplacementNamed(context, 'verperfil');
    }
    mostrarSnackBar(respuesta['msg']);
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: const Duration(milliseconds: 1800),
      backgroundColor: const Color.fromRGBO(29, 53, 87, 1.0),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  actualizarImagenPerfilUsuario() {
    return Center(
      child: Stack(
        children: [
          SizedBox(
            width: 200.0,
            height: 120.0,
            child: Semantics(
              child: _imageFile.path.toString().isNotEmpty
                  ? Image.file(File(_imageFile.path))
                  : Image.network(_url + fotoUser),
            ),
          ),
          Positioned(
            bottom: 70.0,
            right: 5.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => botonDeActualizarPerfil()),
                );
              },
              child: const Icon(
                Icons.camera_alt,
                color: Colors.redAccent,
                size: 40.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  botonDeActualizarPerfil() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        children: [
          const Text(
            "Buscar foto de perfil",
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.camera),
                onPressed: () {
                  tomarFotografia(ImageSource.camera);
                },
                label: const Text("Cámara"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image),
                onPressed: () {
                  tomarFotografia(ImageSource.gallery);
                },
                label: const Text("Galería"),
              )
            ],
          )
        ],
      ),
    );
  }

  tomarFotografia(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    if (mounted) {
      setState(() {
        _imageFile = pickedFile!;
      });
    }
  }

  _crearNombre(PerfilBloc bloc) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (value) => _nombresController.text = value!,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese sus nombres';
              } else {
                return null;
              }
            },
            controller: _nombresController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.person,
                color: Color.fromRGBO(53, 80, 112, 1.0),
              ),
              labelText: 'Nombres',
              counterText: snapshot.data,
            ),
          ),
        );
      },
    );
  }

  _crearApellido(PerfilBloc bloc) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (value) => _apellidosController.text = value!,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese sus apellidos';
              } else {
                return null;
              }
            },
            controller: _apellidosController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.person,
                color: Color.fromRGBO(53, 80, 112, 1.0),
              ),
              labelText: 'Apellidos',
              counterText: snapshot.data,
            ),
          ),
        );
      },
    );
  }

  _crearbiografia(PerfilBloc bloc) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            maxLines: 2,
            textAlign: TextAlign.justify,
            onSaved: (value) => _biografiaController.text = value!,
            validator: (value) {
              if (value!.isEmpty || value.length < 10) {
                return 'Ingrese su biografía';
              } else {
                return null;
              }
            },
            controller: _biografiaController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.markunread_mailbox_outlined,
                color: Color.fromRGBO(53, 80, 112, 1.0),
              ),
              labelText: 'Biografía',
              counterText: snapshot.data,
            ),
          ),
        );
      },
    );
  }

  _crearCelular(PerfilBloc bloc) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (value) => _celularController.text = value!,
            validator: (value) {
              if (value!.isEmpty || value.length < 10) {
                return 'Ingrese su número de celular';
              } else if (value.length > 10) {
                return 'Debe contener 10 dígitos';
              } else {
                return null;
              }
            },
            controller: _celularController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.phone_android,
                color: Color.fromRGBO(53, 80, 112, 1.0),
              ),
              labelText: 'Celular',
              counterText: snapshot.data,
            ),
          ),
        );
      },
    );
  }

  _crearemail(PerfilBloc bloc) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (value) => _emailController.text = value!,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese su correo electrónico';
              } else {
                return null;
              }
            },
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: const Icon(
                Icons.phone_callback,
                color: Color.fromRGBO(53, 80, 112, 1.0),
              ),
              labelText: 'Correo',
              counterText: snapshot.data,
            ),
          ),
        );
      },
    );
  }
}
