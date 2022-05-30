
import 'package:http/http.dart' as http;
import 'package:jobsapp/models/estudios.model.dart';
import 'package:jobsapp/models/user.model.dart';
import 'package:jobsapp/models/experiencia.model.dart';
import 'package:jobsapp/provider/usuario.provider.dart';

class PerfilBloc {

  final _perfilUsuarioProvider = UsuariosProvider();

  Future<Map<String, dynamic>> cargarUsuario() async {
    final usuario = await _perfilUsuarioProvider.obtenerUsuario();
    if (usuario != null) {
      return usuario;
    } else {
      return {"ok": false, "data": "No hay datos del usuario"};
    }
  }

   Future<Map<String, dynamic>> cargarUsuarioEspecifico(String id) async {
    final usuario = await _perfilUsuarioProvider.obtenerUsuarioEspecifico(id);
    //print(usuario);
    if (usuario != null) {
      return usuario;
    } else {
      return {"ok": false, "usuario": "No hay datos del usuario"};
    }
    //_pefilController.sink.add(usuario);
  }

Future<Map<String, dynamic>> editarDatosDelPerfilUsuario(Usuario usuario) async{
    print('usuario desde el bloc ${usuario}');
    final respuesta =
        await _perfilUsuarioProvider.editarDatosDelPerfilUsuario(usuario);
    return respuesta;
  }

  Future<bool> editarSkillsDelUsuario(Usuario usuario) async{
    print('usuario desde el bloc ${usuario}');
    final respuesta =
        await _perfilUsuarioProvider.editarSkillsDelUsuario(usuario);
    return respuesta;
  }
  
   Future<bool> editarExperienciaDelUsuario(UsuarioClass usuario) async{
    print('usuario desde el bloc ${usuario}');
    final respuesta =
        await _perfilUsuarioProvider.editarExperienciaDelUsuario(usuario);
    return respuesta;
  }

   Future<bool> editarEstudioDelUsuario(EstudioClass usuario) async{
    print('usuario desde el bloc ${usuario}');
    final respuesta =
        await _perfilUsuarioProvider.editarEstudioDelUsuario(usuario);
    return respuesta;
  }

  
  Future<http.StreamedResponse> actualizarImagen(String filePath) async {
    final respuesta = await _perfilUsuarioProvider.actualizarImagen(filePath);
    return respuesta;
  }


}
