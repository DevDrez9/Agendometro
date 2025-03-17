class Usuario {
  final Persona persona;
  final String token;
  final int idEmpleado;
  final int idUsuario;

  // Constructor principal
  Usuario(
      {required this.persona,
      required this.token,
      required this.idUsuario,
      required this.idEmpleado});

  // Constructor vacío
  Usuario.empty()
      : persona = Persona.empty(),
        token = '',
        idUsuario = 0,
        idEmpleado = 0;

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
        persona: Persona.fromJson(json['usuario']['idpersona']),
        token: json['token'] ?? "",
        idUsuario: json['usuario']['idusuario'] ?? 0,
        idEmpleado: json['idempleado'] ?? 0);
  }
}

class Persona {
  final int idpersona;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String tipoDocumento;
  final String fechaAlta;
  final String usuarioAlta;
  final Empresa idempresa;

  // Constructor principal
  Persona({
    required this.idpersona,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.tipoDocumento,
    required this.fechaAlta,
    required this.usuarioAlta,
    required this.idempresa,
  });

  // Constructor vacío
  Persona.empty()
      : idpersona = 0,
        nombre = '',
        apellidoPaterno = '',
        apellidoMaterno = '',
        tipoDocumento = '',
        fechaAlta = '',
        usuarioAlta = '',
        idempresa = Empresa.empty();

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      idpersona: json['idpersona'] ?? 0,
      nombre: json['nombre'] ?? '',
      apellidoPaterno: json['apellido_paterno'] ?? '',
      apellidoMaterno: json['apellido_materno'] ?? '',
      tipoDocumento: json['tipo_documento'] ?? '',
      fechaAlta: json['fecha_alta'] ?? '',
      usuarioAlta: json['usuario_alta'] ?? '',
      idempresa: Empresa.fromJson(json['idempresa']),
    );
  }
}

class Empresa {
  final int idempresa;
  final String razonSocial;
  final String nombre;
  final String nit;
  final String fechaAlta;
  final String usuarioAlta;
  final String estado;
  final List<dynamic> idcliente;

  // Constructor principal
  Empresa({
    required this.idempresa,
    required this.razonSocial,
    required this.nombre,
    required this.nit,
    required this.fechaAlta,
    required this.usuarioAlta,
    required this.estado,
    required this.idcliente,
  });

  // Constructor vacío
  Empresa.empty()
      : idempresa = 0,
        razonSocial = '',
        nombre = '',
        nit = '',
        fechaAlta = '',
        usuarioAlta = '',
        estado = '',
        idcliente = [];

  factory Empresa.fromJson(Map<String, dynamic> json) {
    return Empresa(
      idempresa: json['idempresa'] ?? 0,
      razonSocial: json['razon_social'] ?? '',
      nombre: json['nombre'] ?? '',
      nit: json['nit'] ?? '',
      fechaAlta: json['fecha_alta'] ?? '',
      usuarioAlta: json['usuario_alta'] ?? '',
      estado: json['estado'] ?? '',
      idcliente: [],
    );
  }
}
