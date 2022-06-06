
import 'dart:convert';

Password passwordFromJson(String str) => Password.fromJson(json.decode(str));

String passwordToJson(Password data) => json.encode(data.toJson());

class Password {
    Password({
        this.passwordActual = '',
        this.password = '',
    });

    String passwordActual;
    String password;

    factory Password.fromJson(Map<String, dynamic> json) => Password(
        passwordActual: json["passwordActual"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "passwordActual": passwordActual,
        "password": password,
    };
}
