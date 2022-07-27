import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jobsapp/models/ofert.model.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';
import 'package:jobsapp/utils/utils.dart';

class OfertaProvider {
  final String _url = URLBASE;
  final preferenciaToken = PreferenciasUsuario();

  Future<Map<String, dynamic>> crearOferta(Oferta oferta) async {
    final Uri url =
        Uri.parse('$_url/api/oferta?token=${preferenciaToken.token}');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'x-token': preferenciaToken.token
    };

    final resp = await http.post(url,
        headers: requestHeaders, body: json.encode(oferta));
       
        //print(json.decode(resp.body)['medico']);
        

    if (resp.statusCode == 503) {
      return {'ok': false, 'msg': 'Servicio No Disponible'};
    }
    if (resp.statusCode == 200) {
      final decodeData = json.decode(resp.body);
      print('response: $decodeData');
      return decodeData;
    } else {
      final decodeData = json.decode(resp.body);
      return {'ok': false, 'msg': decodeData['msg']};
    }
  }

//le quito el signo  Future<Map<String, dynamic>?>  para retornar el resultado
  Future<Map<String, dynamic>> editarOferta(Oferta oferta, String id) async {
    final Uri url =
        Uri.parse('$_url/api/oferta/${id}?token=${preferenciaToken.token}');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'x-token': preferenciaToken.token
    };

    final resp =
        await http.put(url, headers: requestHeaders, body: json.encode(oferta));

    if (resp.statusCode == 503) {
      return {'ok': false, 'msg': 'Servicio No Disponible'};
    }
    if (resp.statusCode == 200) {
      return {'ok': true};
    } else {
      final decodeData = json.decode(resp.body);
      return {'ok': false, 'msg': decodeData['msg']};
    }
  }

  Future<Map<String, dynamic>> obtenerOferta(String id) async {
    final url = '$_url/api/oferta/${id}';
    final resp = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      return {'oferta': body['ofertaDB']};
    } else {
      final body = json.decode(resp.body);
      return {'ok': false, 'msg': body};
    }
  }

  Future<Map<String, dynamic>?> editarPostulanteOferta(
      Oferta oferta, String id) async {
    final Uri url =
        Uri.parse('$_url/api/postulante/${id}?token=${preferenciaToken.token}');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'x-token': preferenciaToken.token
    };

    final resp =
        await http.put(url, headers: requestHeaders, body: jsonEncode(oferta));

    if (resp.statusCode == 503) {
      return {'ok': false, 'msg': 'Servicio No Disponible'};
    }
    if (resp.statusCode == 200) {
      return {'ok': true};
    } else {
      final decodeData = json.decode(resp.body);
      return {'ok': false, 'msg': decodeData['msg']};
    }
  }

  Future<Map<String, dynamic>> enviarNotificacionFCM(String idOferta) async {
    print('idOFERTA PROVIDER: $idOferta');
    final url = '$_url/api/oferta/notificacion-usuario/${idOferta}/pushed';
    final resp = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );
    if (resp.statusCode == 200) {
      final body = json.decode(resp.body);
      return {'ok': true};
    } else {
      final body = json.decode(resp.body);
      return {'ok': false};
    }
  }

  /*enviarNotificacionFCM(idOferta: string) {
    console.log('push'+ idInmueble)
    let url = URL_SERVICIOS + '/api/oferta/notificacion-usuario/:idOferta'+ idInmueble;
    url += '?token=' + this._usuarioService.token;
    return this.http.get(url).pipe(map((resp: any) => resp.ok));
  }*/

}
