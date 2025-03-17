import 'dart:convert';
import 'dart:io';

import 'package:agendometro/Models/LoginClass.dart';
import 'package:agendometro/Models/Usuario.dart';
import 'package:agendometro/SubPages/MenuDrawer.dart';
import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:agendometro/Utilidades/Alerta.dart';
import 'package:agendometro/Utilidades/Encriptar.dart';
import 'package:agendometro/Utilidades/GlobalVariables.dart';
import 'package:agendometro/Utilidades/LoadingDialog.dart';
import 'package:agendometro/Widgets/BotonPrimario.dart';
import 'package:agendometro/Widgets/BotonSegundario.dart';
import 'package:agendometro/Widgets/textInput.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKeyLogin = GlobalKey<FormState>();
  TextEditingController controllerUser = TextEditingController();
  TextEditingController controllerPass = TextEditingController();
  bool recuerdameCheck = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeColors.backgroundLight,
      body: SingleChildScrollView(
          child: Center(
              child: Container(
                  width: AppTheme.mainSize,
                  margin:
                      EdgeInsets.symmetric(vertical: AppTheme.marginVertical),
                  child: Form(
                    key: _formKeyLogin,
                    child: Column(children: [
                      SizedBox(
                        height: 100,
                      ),
                      Container(
                        width:
                            AppTheme.mainSize, // Ocupa todo el ancho disponible
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/loggo.png"),
                            fit: BoxFit
                                .cover, // Mantiene la proporción y ajusta la altura
                          ),
                        ),
                      ),
                      textInput(
                          controller: controllerUser,
                          labelText: "Usuario",
                          isTextOnly: true),
                      SizedBox(
                        height: 20,
                      ),
                      textInput(
                          controller: controllerPass,
                          labelText: "Contraseña",
                          isPassword: true),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: recuerdameCheck,
                            activeColor: AppThemeColors.primary,
                            onChanged: (bool? newValue) {
                              setState(() {
                                recuerdameCheck = newValue ?? false;
                              });
                            },
                          ),
                          Text(
                            "Recuérdame",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      PrimaryButton(
                          text: "Ingresar",
                          onPressed: () {
                            if (_formKeyLogin.currentState!.validate()) {
                              print("Valido " +
                                  Encriptador.encrypt(
                                      controllerUser.value.text) +
                                  " " +
                                  Encriptador.encrypt(
                                      controllerPass.value.text));

                              LoginClass loginClass = LoginClass(
                                  contrasena:
                                      Encriptador.encrypt(controllerPass.text),
                                  usuario:
                                      Encriptador.encrypt(controllerUser.text));

                              logearse(loginClass, context);
                            }
                          })
                    ]),
                  )))),
    );
  }

  logearse(LoginClass login, BuildContext context) async {
    LoadingDialog.showLoadingDialog(context, "Cargando");

    final headers = {
      'Content-Type': 'application/json',
    };
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse(GlobalVariables.url + "/TokenRest/v1/token"),
        headers: headers,
        body: json.encode(login.toJson()),
      );

      if (response.statusCode == 200) {
        try {
          String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);
          // Extrae el objeto "tecnico"
          print("Servidor " + jsonData.toString());
          //Map<String, dynamic> tecnico = jsonData['tecnico'];

          // Map<String, dynamic> token = jsonData["token"];

          // TecnicoClass tecnicoClass = TecnicoClass.fromJson(tecnico);

          GlobalVariables.instance.user = controllerUser.text;
          GlobalVariables.instance.pass = controllerPass.text;

          String token = jsonData["token"];

          Usuario datos = Usuario.fromJson(jsonData);

          GlobalVariables.instance.mainUsuario = datos;

          if (recuerdameCheck == true) {
            saveData(controllerUser.text, controllerPass.text);
          }

          //GlobalVariables.instance.usuario = datos;

          LoadingDialog.hideLoadingDialog(context);
          Navigator.pushNamed(context, 'home2');

          //return usuario;
        } catch (e) {
          print("No Registrado " + "$e");
          LoadingDialog.hideLoadingDialog(context);
          Alerta(context, "Error ", "Error de tipeado");
        }
      } else if (response.statusCode == 500) {
        LoadingDialog.hideLoadingDialog(context);
        print(response.body);
        Alerta(context, "Error ", " ${response.statusCode} ${response.body}");
      } else {
        LoadingDialog.hideLoadingDialog(context);
        Alerta(context, "Error ", " ${response.statusCode} ${response.body}");
        print("error No entro ${response.statusCode} ${response.body}");

        //loginSqlite(login.usuario, login.contrasena, context);
      }
    } catch (e) {
      print("no conectado");
      LoadingDialog.hideLoadingDialog(context);
      Alerta(context, "Error ", "Usuario no registrado");
      //loginSqlite(login.usuario, login.contrasena, context);
    }
  }

  // Función para guardar los datos en la memoria local
  Future<void> saveData(String user, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
    await prefs.setString('password', pass);
    print('Datos guardados correctamente');
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    String? password = prefs.getString('password');
    if (user != null && password != null) {
      setState(() {
        controllerUser.text = user;
        controllerPass.text = password.toString();
      });
      print('Datos recuperados: $user, $password');
    }
  }
}
