// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
    Usuario({
        required this.redesSociales,
        this.img = '',
        required this.skills,
        this.esAdmin = false,
        required this.fechaCreacion,
        this.activo = true,
        this.nombres = '',
        this.email = '',
        this.apellidos = '',
        this.documentoDeIdentidad = '',
        this.numeroDeCelular = '',
        required this.experiencia,
        required this.estudios,
        this.bio = '',
        this.uid = '',
        this.password ='',
        this.passwordConfirmar ='',
    });

    RedesSociales redesSociales;
    String img;
    List<String> skills;
    bool esAdmin;
    DateTime fechaCreacion;
    bool activo;
    String nombres;
    String email;
    String apellidos;
    String documentoDeIdentidad;
    String numeroDeCelular;
    List<dynamic> experiencia;
    List<dynamic> estudios;
    String bio;
    String uid;
    String password;
    String passwordConfirmar;

    factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        redesSociales: RedesSociales.fromJson(json["redesSociales"]),
        img: json["img"],
        skills: List<String>.from(json["skills"].map((x) => x)),
        esAdmin: json["esAdmin"],
        fechaCreacion: DateTime.parse(json["fechaCreacion"]),
        activo: json["activo"],
        nombres: json["nombres"],
        email: json["email"],
        apellidos: json["apellidos"],
        documentoDeIdentidad: json["documentoDeIdentidad"],
        numeroDeCelular: json["numeroDeCelular"],
        experiencia: List<dynamic>.from(json["experiencia"].map((x) => x)),
        estudios: List<dynamic>.from(json["estudios"].map((x) => x)),
        bio: json["bio"],
        uid: json["uid"],
        password: json["password"],
        passwordConfirmar: json["passwordConfirmar"],
    );

    Map<String, dynamic> toJson() => {
        "redesSociales": redesSociales.toJson(),
        "img": img,
        "skills": List<dynamic>.from(skills.map((x) => x)),
        "esAdmin": esAdmin,
        "fechaCreacion": fechaCreacion.toIso8601String(),
        "activo": activo,
        "nombres": nombres,
        "email": email,
        "apellidos": apellidos,
        "documentoDeIdentidad": documentoDeIdentidad,
        "numeroDeCelular": numeroDeCelular,
        "experiencia": List<dynamic>.from(experiencia.map((x) => x.toJson())),
        "estudios": List<dynamic>.from(estudios.map((x) => x.toJson())),
        "bio": bio,
        "uid": uid,
        "password": password,
        "passwordConfirmar": passwordConfirmar,
    };
}


/*class Experiencia {
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
        nombreInstitucion: json["nombreInstitucion"] == null ? null : json["nombreInstitucion"],
        titulo: json["titulo"],
        fechaInicio: DateTime.parse(json["fechaInicio"]),
        fechaFin: json["fechaFin"],
        descripcion: json["descripcion"],
        empresa: json["empresa"] == null ? null : json["empresa"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "nombreInstitucion": nombreInstitucion == null ? null : nombreInstitucion,
        "titulo": titulo,
        "fechaInicio": "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fechaFin": fechaFin,
        "descripcion": descripcion,
        "empresa": empresa == null ? null : empresa,
    };
}*/

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
