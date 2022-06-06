
import 'package:jobsapp/models/ofert.model.dart';
import 'package:jobsapp/provider/oferta.provider.dart';
import 'package:rxdart/rxdart.dart';

class OfertaBloc {

  final _ofertaController = BehaviorSubject<Oferta>();

  final _ofertaProvider =  OfertaProvider();


  //Recuperar datos del stream
  Stream<Oferta> get contratosStream => _ofertaController.stream;

    void crearOferta(Oferta oferta) async{
    await _ofertaProvider.crearOferta(oferta);
  }

  Future<Map<String, dynamic>> editarOferta(Oferta oferta, String id) async{
    final ofertaResponse = await _ofertaProvider.editarOferta(oferta, id);
    return {'body': ofertaResponse};
  }

   Future<Map<String, dynamic>> editarPostulanteOferta(Oferta oferta, String id) async{
    final ofertaResponse = await _ofertaProvider.editarPostulanteOferta(oferta, id);
    return {'body': ofertaResponse};
  }


  Future<Map<String, dynamic>> cargarOfertaEspecifica(String id) async {
    final usuario = await _ofertaProvider.obtenerOferta(id);
    if (usuario != null) {
    
      return usuario;
    } else {
      return {"ok": false, "usuario": "No hay datos del usuario"};
    }
    //_pefilController.sink.add(usuario);
  }


  dispose(){
    _ofertaController.close();
  }
}