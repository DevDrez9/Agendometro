import 'dart:convert';
import 'dart:io';

import 'package:agendometro/Models/PendientesClass.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:agendometro/Utilidades/DateSelector.dart';
import 'package:agendometro/Utilidades/GlobalVariables.dart';
import 'package:agendometro/Widgets/CardHistorial.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  String fechaSelected = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fechaSelected = DateFormat('yyyy/MM/dd').format(DateTime.now());
    traerPendientes(fechaSelected.replaceAll("/", "-"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: AppTheme.mainSize,
        alignment: Alignment.topCenter,
        margin: EdgeInsets.symmetric(vertical: 50),
        child: SingleChildScrollView(
            child: Column(children: [
          DateSelector(onDateSelected: (value) {
            print(value);

            traerPendientes(DateFormat('yyyy/MM/dd').format(value));
          }),
          SizedBox(
            height: 20,
          ),
          Column(
            children: listaPendientes
                .map((pendiente) => cardHistorial(pendiente))
                .toList(),
          ),
        ])));
  }

  Map<String, dynamic> createPendientesJson({
    required String fecha,
  }) {
    return {
      "startDate": fecha,
      "endDate": fecha,
      "serviceId": 0,
      "employeeId": GlobalVariables.instance.mainUsuario.idEmpleado,
      "workId": 0,
      "customerId": 0,
      "especialidadId": 0,
      "state": 0,
      "page": 0,
      "size": 50
    };
  }

  List<PendientesClass> listaPendientes = [];
  traerPendientes(String fecha) async {
    print(GlobalVariables.instance.mainUsuario.idEmpleado);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + GlobalVariables.instance.mainUsuario.token
    };
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.post(
        Uri.parse(GlobalVariables.url12 + "/schedules/search"),
        headers: headers,
        body: json.encode(createPendientesJson(fecha: fecha)),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);
          // Extrae el objeto "tecnico"
          print("Servidor Historial " + jsonData.toString());

          if (jsonData['content'] is List) {
            setState(() {
              listaPendientes.clear();
              listaPendientes.addAll((jsonData['content'] as List)
                  .map((item) => PendientesClass.fromJson(item)));
            });
          } else {
            throw Exception("El campo 'content' no es una lista");
          }

          //return usuario;
        } catch (e) {
          print(" Buscador No Registrado " + "$e");
        }
      } else if (response.statusCode == 500) {
        print("error historial" + response.body);
      } else {
        //Alerta(context, "Error ", "Usuario no registrado");
        print(
            "Buscador error No entro ${response.statusCode} ${response.body}");

        //loginSqlite(login.usuario, login.contrasena, context);
      }
    } catch (e) {
      print("Buscadorno conectado");

      //loginSqlite(login.usuario, login.contrasena, context);
    }
  }
}
