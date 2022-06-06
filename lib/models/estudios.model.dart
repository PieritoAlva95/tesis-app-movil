
import 'dart:convert';

EstudioClass usuarioFromJson(String str) => EstudioClass.fromJson(json.decode(str));

String usuarioToJson(EstudioClass data) => json.encode(data.toJson());


class EstudioClass {
    EstudioClass({
        required this.estudios,
    });

    List<dynamic> estudios;

    factory EstudioClass.fromJson(Map<String, dynamic> json) => EstudioClass(
        estudios: List<Estudio>.from(json["estudios"].map((x) => Estudio.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "estudios": List<dynamic>.from(estudios.map((x) => x.toJson())),
    };
}



class Estudio {
    Estudio({
        this.id = '',
        this.nombreInstitucion = '',
        this.titulo = '',
        required this.fechaInicio,
        this.fechaFin = '',
        this.descripcion = '',
        this.empresa = '',
    });

    String id;
    String nombreInstitucion;
    String titulo;
    DateTime fechaInicio;
    String fechaFin;
    String descripcion;
    String empresa;

    factory Estudio.fromJson(Map<String, dynamic> json) => Estudio(
        id: json["_id"],
        nombreInstitucion: json["nombreInstitucion"],
        titulo: json["titulo"],
        fechaInicio: DateTime.parse(json["fechaInicio"]),
        fechaFin: json["fechaFin"],
        descripcion: json["descripcion"],
        empresa: json["empresa"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombreInstitucion": nombreInstitucion,
        "titulo": titulo,
        "fechaInicio": "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fechaFin": fechaFin,
        "descripcion": descripcion,
        "empresa": empresa,
    };
}

class RedesSociales {
    RedesSociales({
        this.twitter = '',
        this.facebook = '',
        this.linkedin = '',
        this.instagram = '',
    });

    String twitter;
    String facebook;
    String linkedin;
    String instagram;

    factory RedesSociales.fromJson(Map<String, dynamic> json) => RedesSociales(
        twitter: json["twitter"],
        facebook: json["facebook"],
        linkedin: json["linkedin"],
        instagram: json["instagram"],
    );

    Map<String, dynamic> toJson() => {
        "twitter": twitter,
        "facebook": facebook,
        "linkedin": linkedin,
        "instagram": instagram,
    };
}
