import 'dart:convert';
import 'dart:io';

import 'package:agendometro/Pages/HomePage.dart';
import 'package:agendometro/Pages/HomePage2.dart';
import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:agendometro/Utilidades/Alerta.dart';
import 'package:agendometro/Utilidades/GlobalVariables.dart';
import 'package:agendometro/Utilidades/LoadingDialog.dart';
import 'package:agendometro/Widgets/BotonPrimario.dart';
import 'package:agendometro/Widgets/DatePicker.dart';
import 'package:agendometro/Widgets/DatePicker2.dart';
import 'package:agendometro/Widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

class RegistrarPage extends StatefulWidget {
  const RegistrarPage({super.key});

  @override
  State<RegistrarPage> createState() => _RegistrarPageState();
}

class _RegistrarPageState extends State<RegistrarPage> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController paternoController = TextEditingController();
  TextEditingController maternoController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  //TextEditingController correoController = TextEditingController();
  TextEditingController fechaController = TextEditingController();

  TextEditingController documentoController = TextEditingController();

  final _formKeyRegistrar = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage2()),
          );
          return false; // Evita que el sistema maneje el retroceso
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("Registrar"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage2()),
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
                child: Container(
              alignment: Alignment.center,
              child: Form(
                key: _formKeyRegistrar,
                child: Column(children: [
                  textInput(
                    controller: celularController,
                    labelText: "Celular",
                    isNumberOnly: true,
                  ),
                  textInput(controller: nombreController, labelText: "Nombre"),
                  textInput(
                      controller: paternoController,
                      labelText: "Apellido Paterno"),
                  textInput(
                      controller: maternoController,
                      labelText: "Apellido Materno",
                      isValidatorEnabled: false),
                  textInput(
                      controller: documentoController,
                      labelText: "Documento Identidad",
                      isValidatorEnabled: false),
                  textInput(
                      controller: direccionController,
                      labelText: "Direccion",
                      isValidatorEnabled: false),
                  DatePickerField2(
                    controller: fechaController,
                    label: "Fecha Naciemiento",
                    validator: (value) {
                      if (value!.isEmpty || value == null) {
                        return "Ingrese fecha de nacimiento";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  PrimaryButton(
                      text: "Registrar",
                      onPressed: () {
                        if (_formKeyRegistrar.currentState!.validate()) {
                          print("Registrar " + fechaController.value.text);
                          registrarCliente();
                        }
                      })
                ]),
              ),
            ))));
  }

  Map<String, dynamic> toJsonCliente() {
    return {
      "apellidoMaterno": maternoController.value.text,
      "apellidoPaterno": paternoController.value.text,
      "direccion": direccionController.value.text,
      "fechaNacimiento": fechaController.value.text.replaceAll("/", "-"),
      "idPersona": 0,
      "idempresa":
          GlobalVariables.instance.mainUsuario.persona.idempresa.idempresa,
      "nombre": nombreController.value.text,
      "telefono": celularController.value.text,
      "usuarioAlta": "Movil",
      "valorDocumento": documentoController.value.text,
    };
  }

  registrarCliente() async {
    LoadingDialog.showLoadingDialog(context, "Registrando");

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + GlobalVariables.instance.mainUsuario.token
    };
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);

    print(toJsonCliente());

    try {
      final response = await ioClient.post(
        Uri.parse(GlobalVariables.url13 + "/persona/v1/guardar-simplificado"),
        headers: headers,
        body: json.encode(toJsonCliente()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);
          // Extrae el objeto "tecnico"
          print("Servidor " + jsonData.toString());

          await Alerta(
              context, "Registrado", "Se registro correctamente al usuario");

          LoadingDialog.hideLoadingDialog(context);

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage2(
                    initialTab: 1,
                  )));

          //return usuario;
        } catch (e) {
          LoadingDialog.hideLoadingDialog(context);
          Alerta(context, "Error",
              "Error al intentar registrar, intentelo mas tarde.");
          print(" Registrar No Registrado " + "$e");
        }
      } else if (response.statusCode == 500) {
        LoadingDialog.hideLoadingDialog(context);
        Alerta(context, "Error", "Error al registrar, intentelo mas tarde.");
        print(response.body);
      } else {
        //Alerta(context, "Error ", "Usuario no registrado");
        print(
            "Registrar error No entro ${response.statusCode} ${response.body}");
        LoadingDialog.hideLoadingDialog(context);
        Alerta(context, "Error",
            "Error al intentar registrar, intentelo mas tarde.");

        //loginSqlite(login.usuario, login.contrasena, context);
      }
    } catch (e) {
      LoadingDialog.hideLoadingDialog(context);
      Alerta(context, "Error",
          "Error al intentar registrar, intentelo mas tarde.");
      print("Registrar no conectado " + e.toString());

      //loginSqlite(login.usuario, login.contrasena, context);
    }
  }
}
