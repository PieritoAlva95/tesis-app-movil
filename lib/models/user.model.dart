
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
        this.tokenfirebase = '',
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
    String tokenfirebase;

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
        tokenfirebase: json["tokenfirebase"],
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
        "tokenfirebase": tokenfirebase,
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
