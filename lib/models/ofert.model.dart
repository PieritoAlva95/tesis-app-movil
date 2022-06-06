
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
         this.precio = '',
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
    String precio;
    String tipoPago;
    String categoria;
    String nombreUsuario;
    List<dynamic> interesados;

    factory Oferta.fromJson(Map<String, dynamic> json) => Oferta(
        disponible: json["disponible"],
        status: json["status"],
        statusUser: json["statusUser"],
        usuario: json["usuario"],
        fechaCreacion: DateTime.parse(json["fechaCreacion"]),
        titulo: json["titulo"],
        cuerpo: json["cuerpo"],
        precio: json["precio"],
        tipoPago: json["tipoPago"],
        categoria: json["categoria"],
        nombreUsuario: json["nombreUsuario"],
        interesados: List<dynamic>.from(json["interesados"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "disponible": disponible,
        "status": status,
        "statusUser": statusUser,
        "usuario": usuario,
        "fechaCreacion": fechaCreacion.toIso8601String(),
        "titulo": titulo,
        "cuerpo": cuerpo,
        "precio": precio,
        "tipoPago": tipoPago,
        "categoria": categoria,
        "nombreUsuario": nombreUsuario,
        "interesados": List<dynamic>.from(interesados.map((x) => x)),
    };
}
