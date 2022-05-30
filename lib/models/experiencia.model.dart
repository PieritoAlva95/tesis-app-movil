// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

UsuarioClass usuarioFromJson(String str) => UsuarioClass.fromJson(json.decode(str));

String usuarioToJson(UsuarioClass data) => json.encode(data.toJson());


class UsuarioClass {
    UsuarioClass({
        required this.experiencia,
    });

    List<Experiencia> experiencia;

    factory UsuarioClass.fromJson(Map<String, dynamic> json) => UsuarioClass(
      
        experiencia: List<Experiencia>.from(json["experiencia"].map((x) => Experiencia.fromJson(x))),
       
    );

    Map<String, dynamic> toJson() => {
      
        "experiencia": List<dynamic>.from(experiencia.map((x) => x.toJson())),
      
    };
}

class Experiencia {
    Experiencia({
        this.id = '',
        this.titulo = '',
        this.empresa = '',
        required this.fechaInicio,
        this.fechaFin = '',
        this.descripcion = '',
    });

    String id;
    String titulo;
    String empresa;
    DateTime fechaInicio;
    String fechaFin;
    String descripcion;

    factory Experiencia.fromJson(Map<String, dynamic> json) => Experiencia(
        id: json["_id"],
        titulo: json["titulo"],
        empresa: json["empresa"],
        fechaInicio: DateTime.parse(json["fechaInicio"]),
        fechaFin: json["fechaFin"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "titulo": titulo,
        "empresa": empresa,
        "fechaInicio": "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fechaFin": fechaFin,
        "descripcion": descripcion,
    };
}

