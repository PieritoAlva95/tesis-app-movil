import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jobsapp/models/email.model.dart';
import 'package:jobsapp/models/estudios.model.dart';
import 'package:jobsapp/models/password.model.dart';
import 'package:jobsapp/models/user.model.dart';
import 'package:jobsapp/models/experiencia.model.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/utils.dart';

class UsuariosProvider {
  final String _url = URLBASE;
  final preferencias = PreferenciasUsuario();

  Future<Map<String, dynamic>> enviarNotificacionFCMContratar(
      String idUsuario, String tituloOferta, String tipoNotificacion) async {
    print('idUsuario PROVIDER: $idUsuario');
    final url =
        '$_url/api/usuarios/notificacion-contratar/$idUsuario/pushed/$tituloOferta/$tipoNotificacion';
    final resp = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    print('RESP NOTFICA: ${resp.body}');
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      print('NOTIFIVATIOM: $body');
      return {'ok': true};
    } else {
      final body = json.decode(resp.body);
      return {'ok': false};
    }
  }

  Future<Map<String, dynamic>> login(String correo, String password) async {
    final authData = {'email': correo, 'password': password};

    final url = Uri.parse('$_url/api/login');
    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(authData));
    print('RESPUESTA: ' + resp.body);

    if (resp.statusCode == 503) {
      return {'ok': false, 'msg': 'Servicio No Disponible'};
    }

    if (resp.statusCode == 200) {
      final decodeData = json.decode(resp.body);

      preferencias.token = decodeData['token'];
      preferencias.idUsuario = decodeData['usuarioDB']['uid'];
      preferencias.nombres = decodeData['usuarioDB']['nombres'];
      preferencias.esAdmin = decodeData['usuarioDB']['esAdmin'];
      preferencias.passwordActual = password;
      return {'ok': true};
    }
    if (resp.statusCode == 404) {
      final decodeData = json.decode(resp.body);
      return {'ok': false, 'msg': decodeData['msg']};
    } else {
      final decodeData = json.decode(resp.body);
      return {'ok': false, 'msg': decodeData['msg']};
    }
  }

  Future<Map<String, dynamic>?> crearUsuario(Usuario usuario) async {
    final Uri url = Uri.parse('$_url/api/usuarios');
    final resp = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(usuario));

    if (resp.statusCode == 503) {
      return {'ok': false, 'msg': 'Servicio No Disponible'};
    }
    if (resp.statusCode == 200) {
      final decodeData = json.decode(resp.body);

      preferencias.token = decodeData['token'];
      return {'ok': true};
    } else {
      final decodeData = json.decode(resp.body);
      return {'ok': false, 'msg': decodeData['msg']};
    }
  }

  Future<bool> verificarToken() async {
    final url = '$_url/api/usuarios/validar/token';
    bool result;
    final resp = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'token': preferencias.token}));

    if (resp.statusCode == 404) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  Future<Map<String, dynamic>> obtenerUsuario() async {
    final url = '$_url/api/usuarios/' + preferencias.idUsuario;
    final resp = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);

      return body;
    } else {
      final body = json.decode(resp.body);
      return {'ok': false, 'msg': body['msg']};
    }
  }

  Future<Map<String, dynamic>> obtenerUsuarioEspecifico(String id) async {
    final url = '$_url/api/usuarios/' + id;
    final resp = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      return body;
    } else {
      final body = json.decode(resp.body);
      return {'ok': false, 'msg': body['msg']};
    }
  }

  Future<http.StreamedResponse> actualizarImagen(String filePath) async {
    final url = '$_url/api/upload/usuarios/${preferencias.idUsuario}';
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("imagen", filePath));

    request.headers.addAll(
        {"Content-Type": "multipart/form-data", 'x-token': preferencias.token});
    var response = request.send();
    return response;
  }

  Future<Map<String, dynamic>> editarDatosDelPerfilUsuario(
      Usuario usuario) async {
    var data = {};

    if (usuario.nombres.toString().isNotEmpty) {
      data = {
        "nombres": usuario.nombres,
        "apellidos": usuario.apellidos,
        "bio": usuario.bio,
        "numeroDeCelular": usuario.numeroDeCelular,
        "email": usuario.email,
      };
    }
    if (usuario.redesSociales.twitter.isNotEmpty ||
        usuario.redesSociales.facebook.isNotEmpty ||
        usuario.redesSociales.linkedin.isNotEmpty ||
        usuario.redesSociales.instagram.isNotEmpty) {
      data = {
        'redesSociales': {
          'twitter': usuario.redesSociales.twitter,
          'facebook': usuario.redesSociales.facebook,
          'linkedin': usuario.redesSociales.linkedin,
          'instagram': usuario.redesSociales.instagram,
        }
      };
    }

    final url = Uri.parse('$_url/api/usuarios/${preferencias.idUsuario}');
    final respuesta = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          'x-token': preferencias.token
        },
        body: json.encode(data));
    if (respuesta.statusCode == 200) {
      final body = json.decode(respuesta.body);
      data = {};
      return body;
    }
    if (respuesta.statusCode == 500) {
      final body = json.decode(respuesta.body);
      data = {};
      return {'ok': false, 'msg': 'El número de celular ingresado ya existe'};
    } else {
      final body = json.decode(respuesta.body);
      data = {};
      return body;
    }
  }

  Future<bool> editarSkillsDelUsuario(Usuario usuario) async {
    var data = {};

    data = {
      "skills": usuario.skills,
    };

    final url = Uri.parse('$_url/api/usuarios/${preferencias.idUsuario}');
    final respuesta = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          'x-token': preferencias.token
        },
        body: json.encode(data));
    if (respuesta.statusCode == 200) {
      final body = json.decode(respuesta.body);
      data = {};
      return true;
    } else {
      final body = json.decode(respuesta.body);
      data = {};
      return false;
    }
  }

  Future<bool> editarExperienciaDelUsuario(UsuarioClass usuario) async {
    final url = Uri.parse('$_url/api/usuarios/${preferencias.idUsuario}');
    final respuesta = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          'x-token': preferencias.token
        },
        body: json.encode(usuario));
    if (respuesta.statusCode == 200) {
      final body = json.decode(respuesta.body);
      return true;
    } else {
      final body = json.decode(respuesta.body);
      return false;
    }
  }

  Future<bool> editarEstudioDelUsuario(EstudioClass usuario) async {
    final url = Uri.parse('$_url/api/usuarios/${preferencias.idUsuario}');
    final respuesta = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          'x-token': preferencias.token
        },
        body: json.encode(usuario));
    if (respuesta.statusCode == 200) {
      final body = json.decode(respuesta.body);
      return true;
    } else {
      final body = json.decode(respuesta.body);
      return false;
    }
  }

  Future<bool> editarPasswordDelUsuario(Password usuario) async {
    final url =
        Uri.parse('$_url/api/usuarios/cambio/${preferencias.idUsuario}');
    final respuesta = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          'x-token': preferencias.token
        },
        body: json.encode(usuario));
    if (respuesta.statusCode == 200) {
      final body = json.decode(respuesta.body);
      return true;
    } else {
      final body = json.decode(respuesta.body);
      return true;
    }
  }

  Future<Map<String, dynamic>> editarEmailDelUsuario(Email usuario) async {
    final url = Uri.parse('$_url/api/resetear-password/');
    final respuesta = await http.put(url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(usuario));
    if (respuesta.statusCode == 200) {
      final body = json.decode(respuesta.body);
      return {'ok': true};
    } else {
      final body = json.decode(respuesta.body);
      return {'ok': false, 'msg': body['msg']};
    }
  }

  Future<Map<String, dynamic>> obtenerUsuariosDelAdministrador() async {
    final url = '$_url/api/usuarios/obtener/usuarios/' + preferencias.idUsuario;
    final resp = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);

      return body;
    } else {
      final body = json.decode(resp.body);
      return {'ok': false, 'msg': body['msg']};
    }
  }

  Future<Map<String, dynamic>> editarEstadoDelUsuario(
      bool estadoUsuario, bool esAdmin, String uidUsuarioEditar) async {
    var data = {};

    if (estadoUsuario.toString().isNotEmpty) {
      data = {
        "activo": estadoUsuario,
        "esAdmin": esAdmin,
      };
    }

    //print('DESDE ACTIVO PROVIDER: ${data}');

    final url = Uri.parse('$_url/api/usuarios/${uidUsuarioEditar}');
    final respuesta = await http.put(url,
        headers: {
          "Content-Type": "application/json",
          'x-token': preferencias.token
        },
        body: json.encode(data));
    if (respuesta.statusCode == 503) {
      return {'ok': false, 'msg': 'Servicio No Disponible'};
    }
    if (respuesta.statusCode == 200) {
      final body = json.decode(respuesta.body);
      data = {};
      return body;
    } else {
      final body = json.decode(respuesta.body);
      data = {};
      return body;
    }
  }

  Future<bool> editarTokenFCMDelUsuario(firebaseToken) async {
    //TODO: Corregir esto del token
    print('token FIREBASE: $firebaseToken');
    final authData = {'tokenfirebase': firebaseToken};
    final url =
        '$_url/api/usuarios/actualizartoken-firebase/usuario/${preferencias.idUsuario}';
    final respuesta = await http.put(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'x-token': preferencias.token
        },
        body: json.encode(authData));

    if (respuesta.statusCode == 200) {
      final body = json.decode(respuesta.body);
      print('Respuesta FCM ${body}');
      return true;
    } else {
      return false;
    }
  }
}
