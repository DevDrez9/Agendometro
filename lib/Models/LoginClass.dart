class LoginClass {
  String usuario;
  String contrasena;
  LoginClass({required this.usuario, required this.contrasena});
  LoginClass.vacio()
      : usuario = "",
        contrasena = "";

  Map<String, dynamic> toJson() {
    return {'dataPassword': contrasena, 'dataUser': usuario};
  }
}
