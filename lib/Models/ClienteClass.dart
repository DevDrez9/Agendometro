class ClienteClass {
  String? valorDocumento;
  int idEmpresa;
  String usuarioAlta;
  int idPersona;
  String? direccion;
  String? telefono;
  int fechaAlta;
  String apellidoPaterno;
  String apellidoMaterno;
  String nombre;
  String? fechaNacimiento;

  ClienteClass({
    this.valorDocumento,
    required this.idEmpresa,
    required this.usuarioAlta,
    required this.idPersona,
    this.direccion,
    this.telefono,
    required this.fechaAlta,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.nombre,
    this.fechaNacimiento,
  });

  // Constructor vacío
  factory ClienteClass.empty() {
    return ClienteClass(
      valorDocumento: "",
      idEmpresa: 0,
      usuarioAlta: "",
      idPersona: 0,
      direccion: null,
      telefono: null,
      fechaAlta: 0,
      apellidoPaterno: "",
      apellidoMaterno: "",
      nombre: "",
      fechaNacimiento: null,
    );
  }

  // Método para convertir JSON a objeto Persona
  factory ClienteClass.fromJson(Map<String, dynamic> json) {
    return ClienteClass(
      valorDocumento: json['valorDocumento'] ?? "",
      idEmpresa: json['idEmpresa'] ?? 0,
      usuarioAlta: json['usuarioAlta'] ?? '',
      idPersona: json['idPersona'] ?? 0,
      direccion: json['direccion'] ?? '',
      telefono: json['telefono'] ?? '',
      fechaAlta: json['fechaAlta'] ?? 0,
      apellidoPaterno: json['apellidoPaterno'] ?? '',
      apellidoMaterno: json['apellidoMaterno'] ?? '',
      nombre: json['nombre'] ?? '',
      fechaNacimiento: json['fechaNacimiento'] ?? '',
    );
  }

  // Método para convertir objeto Persona a JSON
  Map<String, dynamic> toJson() {
    return {
      "valorDocumento": valorDocumento,
      "idEmpresa": idEmpresa,
      "usuarioAlta": usuarioAlta,
      "idPersona": idPersona,
      "direccion": direccion,
      "telefono": telefono,
      "fechaAlta": fechaAlta,
      "apellidoPaterno": apellidoPaterno,
      "apellidoMaterno": apellidoMaterno,
      "nombre": nombre,
      "fechaNacimiento": fechaNacimiento,
    };
  }
}
