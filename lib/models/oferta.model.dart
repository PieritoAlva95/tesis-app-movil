
import 'dart:convert';

Oferta ofertaFromJson(String str) => Oferta.fromJson(json.decode(str));

String ofertaToJson(Oferta data) => json.encode(data.toJson());

class Oferta {
    Oferta({
        this.disponible = 'sin contrato',
         this.status = true,
         this.statusUser = true,
         this.usuario = "",
         required this.fechaCreacion,
         this.titulo = '',
         this.cuerpo = '',
         this.precio = 0,
         this.tipoPago = '',
         this.categoria = '',
         this.nombreUsuario = '',
         required this.interesados,
    });

    String disponible;
    bool status;
    bool statusUser;
    String usuario;
    DateTime fechaCreacion;
    String titulo;
    String cuerpo;
    int precio;
    String tipoPago;
    String categoria;
    String nombreUsuario;
    List<Interesado> interesados;

    factory Oferta.fromJson(Map<String, dynamic> json) => Oferta(
        disponible: json["disponible"],
        status: json["status"],
        statusUser: json["statusUser"],
        usuario: json["usuario"],
        fechaCreacion: DateTime.parse(json["fechaCreacion"]),
        titulo: json["titulo"],
        cuerpo: json["Cuerpo"],
        precio: json["precio"],
        tipoPago: json["tipoPago"],
        categoria: json["categoria"],
        nombreUsuario: json["nombreUsuario"],
        interesados: List<Interesado>.from(json["interesados"].map((x) => Interesado.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "disponible": disponible,
        "status": status,
        "statusUser": statusUser,
        "usuario": usuario,
        "fechaCreacion": fechaCreacion.toIso8601String(),
        "titulo": titulo,
        "Cuerpo": cuerpo,
        "precio": precio,
        "tipoPago": tipoPago,
        "categoria": categoria,
        "nombreUsuario": nombreUsuario,
        "interesados": List<dynamic>.from(interesados.map((x) => x.toJson())),
    };
}

class Interesado {
    Interesado({
        this.aceptado = false,
        required this.fechaPostulacion,
        this.id ='',
        this.postulante ='',
        this.nombres = '',
        this.foto = '',
    });

    bool aceptado;
    DateTime fechaPostulacion;
    String id;
    String postulante;
    String nombres;
    String foto;

    factory Interesado.fromJson(Map<String, dynamic> json) => Interesado(
        aceptado: json["aceptado"],
        fechaPostulacion: DateTime.parse(json["fechaPostulacion"]),
        id: json["_id"],
        postulante: json["postulante"],
        nombres: json["nombres"],
        foto: json["foto"],
    );

    Map<String, dynamic> toJson() => {
        "aceptado": aceptado,
        "fechaPostulacion": fechaPostulacion.toIso8601String(),
        "_id": id,
        "postulante": postulante,
        "nombres": nombres,
        "foto": foto,
    };
}
