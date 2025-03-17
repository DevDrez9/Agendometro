class EspecialistaClass {
  int id;
  String email;
  String telefonoCelular;
  String telefonoFijo;
  double haberBasico;
  Person person;

  EspecialistaClass({
    required this.id,
    required this.email,
    required this.telefonoCelular,
    required this.telefonoFijo,
    required this.haberBasico,
    required this.person,
  });

  // Constructor vacío
  factory EspecialistaClass.empty() {
    return EspecialistaClass(
      id: 0,
      email: '',
      telefonoCelular: '',
      telefonoFijo: '',
      haberBasico: 0.0,
      person: Person.empty(),
    );
  }

  // Método fromJson
  factory EspecialistaClass.fromJson(Map<String, dynamic> json) {
    return EspecialistaClass(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      telefonoCelular: json['telefonoCelular'] ?? '',
      telefonoFijo: json['telefonoFijo'] ?? '',
      haberBasico: (json['haberBasico'] ?? 0).toDouble(),
      person: Person.fromJson(json['person'] ?? {}),
    );
  }
}

class Person {
  int id;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String correo;
  String telefono;
  int idEmpresa;

  Person({
    required this.id,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.correo,
    required this.telefono,
    required this.idEmpresa,
  });

  // Constructor vacío
  factory Person.empty() {
    return Person(
      id: 0,
      nombre: '',
      apellidoPaterno: '',
      apellidoMaterno: '',
      correo: '',
      telefono: '',
      idEmpresa: 0,
    );
  }

  // Método fromJson
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      apellidoPaterno: json['apellidoPaterno'] ?? '',
      apellidoMaterno: json['apellidoMaterno'] ?? '',
      correo: json['correo'] ?? '',
      telefono: json['telefono'] ?? '',
      idEmpresa: json['idEmpresa'] ?? 0,
    );
  }
}
