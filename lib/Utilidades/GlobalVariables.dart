import 'dart:convert';
import 'dart:io';

import 'package:agendometro/Models/ServiciosClass.dart';
import 'package:agendometro/Models/Usuario.dart';
import 'package:http/io_client.dart';

class GlobalVariables {
  // Hacer que el constructor sea privado.
  GlobalVariables._privateConstructor();

  // Instancia única de la clase.
  static final GlobalVariables _instance =
      GlobalVariables._privateConstructor();

  // Método para obtener la instancia.
  static GlobalVariables get instance => _instance;

  static final url = "http://154.53.54.236:7013";
  //static final url12 = "https://gldscz.org:5012";

  static final url12 = "http://154.53.54.236:7017";
  static final url13 = "http://154.53.54.236:7018";
  String user = "";
  String pass = "";

  Usuario mainUsuario = Usuario.empty();
}
