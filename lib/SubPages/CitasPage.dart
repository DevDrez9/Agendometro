import 'dart:convert';
import 'dart:io';

import 'package:agendometro/Models/PendientesClass.dart';
import 'package:agendometro/Theme/AppTextStyle.dart';
import 'package:agendometro/Theme/App_theme.dart';
import 'package:agendometro/Utilidades/GlobalVariables.dart';
import 'package:agendometro/Widgets/CardCitas.dart';
import 'package:agendometro/Widgets/PagarAccion.dart';
import 'package:agendometro/Widgets/TratamientoAccion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/io_client.dart';

class CitasPage extends StatefulWidget {
  const CitasPage({super.key});

  @override
  State<CitasPage> createState() => _CitasPageState();
}

class _CitasPageState extends State<CitasPage> {
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
      child: Column(children: [
        Container(
            width: AppTheme.mainSize,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pendientes",
                  style: AppTextStyles.title,
                ),
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.date_range),
                      Text(
                        fechaSelected,
                        style: AppTextStyles.bodyDark,
                      )
                    ],
                  ),
                ),
              ],
            )),
        Container(
          width: AppTheme.mainSize,
          height: 2,
          color: Colors.black,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            height:
                MediaQuery.of(context).size.height * 0.6, // 70% de la altura
            child: SingleChildScrollView(
              child: Column(
                children: listaPendientes
                    .map(
                        (pendiente) => cardCitas(pendiente, onPressed: (value) {
                              showFullScreenPagarAccion(
                                  context,
                                  pendiente.service_name,
                                  pendiente.employee_nombre +
                                      " " +
                                      pendiente.employee_apellido_paterno,
                                  pendiente.customer_nombre +
                                      " " +
                                      pendiente.customer_apellido_paterno,
                                  pendiente.price.toString(),
                                  0);
                            }, onPressedTratamiento: (value) {
                              showFullScreenTratamiento(
                                  context,
                                  pendiente.service_name,
                                  pendiente.employee_nombre +
                                      " " +
                                      pendiente.employee_apellido_paterno,
                                  pendiente.customer_nombre +
                                      " " +
                                      pendiente.customer_apellido_paterno,
                                  pendiente.price.toString(),
                                  0);
                            }))
                    .toList(),
              ),
            ))
      ]),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      //firstDate: DateTime.now(), // Restringe fechas pasadas
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
      locale: const Locale('es', 'ES'),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
      traerPendientes(formattedDate.replaceAll("/", "-"));
      setState(() {
        fechaSelected = formattedDate;
      });
    }
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
        print(response.body);
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
