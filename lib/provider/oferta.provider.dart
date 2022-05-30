import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:jobsapp/models/ofert.model.dart';
import 'package:jobsapp/sharepreference/preferenciasUsuario.dart';

class OfertaProvider {
  final String _url = 'https://jobstesis.herokuapp.com';
  final preferenciaToken = PreferenciasUsuario();

  /*Future<Oferta> obtenerOfertas(int cantidad) async {
    final url =
        Uri.parse('$_url/api/oferta/$cantidad?token=${preferenciaToken.token}');

    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );

    //print(resp.body);
    final respu = ofertaFromJson(resp.body);
    return respu;

  }*/

  Future<Map<String, dynamic>?> crearOferta(Oferta oferta) async {

    final Uri url = Uri.parse('$_url/api/oferta?token=${preferenciaToken.token}');

   Map<String, String> requestHeaders = {
       'Content-Type': 'application/json',
       'x-token': preferenciaToken.token
     };

    final resp = await http.post(url,
        headers: requestHeaders,
        body: json.encode(oferta));

print(resp.statusCode);
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



    Future<Map<String, dynamic>?> editarOferta(Oferta oferta, String id) async {

      print(oferta);
      print(id);
    final Uri url = Uri.parse('$_url/api/oferta/${id}?token=${preferenciaToken.token}');

   Map<String, String> requestHeaders = {
       'Content-Type': 'application/json',
       'x-token': preferenciaToken.token
     };

    final resp = await http.put(url,
        headers: requestHeaders,
        body: json.encode(oferta));
        print('URL: ${resp.request}');
        print('DATOS OFERTA: ${resp.body}');

print('StatusCode: ${resp.statusCode}');
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



    Future<Map<String, dynamic>> obtenerOferta(String id) async{
    final url = '$_url/api/oferta/${id}';
    final resp = await http.get( Uri.parse(url), headers: {"Content-Type": "application/json"},);
    if(resp.statusCode == 200){
      final body = json.decode(resp.body);
      //print('providerUser: ${body}');
      return {'oferta':body['ofertaDB']};
    }else{
      final body = json.decode(resp.body);
      return {'ok': false, 'msg': body};
    }
  }



 Future<Map<String, dynamic>?> editarPostulanteOferta(Oferta oferta, String id) async {
      
      print('ofertID: ${oferta.tipoPago}');
      print(id);
      print(oferta.interesados);

    final Uri url = Uri.parse('$_url/api/postulante/${id}?token=${preferenciaToken.token}');

   Map<String, String> requestHeaders = {
       'Content-Type': 'application/json',
       'x-token': preferenciaToken.token
     };

    final resp = await http.put(url,
        headers: requestHeaders,
        body: jsonEncode(oferta));
        print('URL: ${resp.request}');
        print('DATOS OFERTA: ${resp.body}');
        

print('StatusCode: ${resp.statusCode}');
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


 /* Future<Map<String, dynamic>> cargarOfertasContratos() async{
    final url = '$_url/api/oferta/${preferenciaToken.idUsuario}';
    final resp = await http.get( Uri.parse(url), headers: {"Content-Type": "application/json"},);
    if(resp.statusCode == 200){
      final body = json.decode(resp.body);
      //print('providerUser: ${body}');
      return {'oferta':body['ofertaDB']};
    }else{
      final body = json.decode(resp.body);
      return {'ok': false, 'msg': body};
    }
  }*/

}
