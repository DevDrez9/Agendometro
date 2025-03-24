import 'dart:convert';
import 'dart:io';

import 'package:agendometro/Models/DtoSchedules.dart';
import 'package:agendometro/Models/PendientesClass.dart';
import 'package:agendometro/Pages/HomePage2.dart';
import 'package:agendometro/Theme/AppTextStyle.dart';
import 'package:agendometro/Theme/AppThemeColors.dart';
import 'package:agendometro/Utilidades/Alerta.dart';
import 'package:agendometro/Utilidades/GlobalVariables.dart';
import 'package:agendometro/Utilidades/LoadingDialog.dart';
import 'package:agendometro/Widgets/BotonSeccion.dart';
import 'package:agendometro/Widgets/TextInput2.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

void CronogramaVerPagar(
  BuildContext context,
  PendientesClass customer,
) {
  showDialog(
    context: context,
    barrierDismissible: true, // Evita que se cierre al tocar fuera
    builder: (BuildContext context) {
      return CronogramaVerDialog(
        customer: customer,
      );
    },
  );
}

class CronogramaVerDialog extends StatefulWidget {
  final PendientesClass customer;

  CronogramaVerDialog({required this.customer});

  @override
  _CronogramaVerDialogState createState() => _CronogramaVerDialogState();
}

class _CronogramaVerDialogState extends State<CronogramaVerDialog> {
  late List<Cuota> listaCuotas = [];
  late double costoTotal;
  final _formKeyPago = GlobalKey<FormState>();
  late List<TextEditingController> controllers = []; // Lista de controladores

  List<bool> isCheckedList = []; // Lista de estados de los checkboxes

  @override
  void initState() {
    super.initState();

    costoTotal = widget.customer.price.toDouble();

    getCuotas(widget.customer.workId);
  }

  bool estado = true;
  double faltante = 0;
  bool editable = false;
  bool editableCheck = true;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        width: 350,
        height: 500,
        decoration: BoxDecoration(
            color: Colors.white, // Fondo de la pantalla
            borderRadius: BorderRadius.circular(12)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Cronograma de Pago",
                      style: AppTextStyles.title,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: 250,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Costo Total",
                                  style: AppTextStyles.subtitleDark,
                                ),
                                Text(
                                  "${widget.customer.price} Bs",
                                  style: AppTextStyles.subtitleDark,
                                )
                              ],
                            ),
                          ])),
                  Form(
                      key: _formKeyPago,
                      child: Container(
                          width: 250,
                          child: Column(
                            children:
                                List.generate(listaCuotas.length, (index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Sesion ${index + 1}"),
                                  Row(
                                    children: [
                                      textInput2(
                                          controller: controllers[index],
                                          labelText: "Monto a pagar",
                                          //icon: Icons.attach_money_outlined,
                                          horizontal: 100,
                                          isNumberOnly: true,
                                          enabled: editable &&
                                              !listaCuotas[index].pagado),
                                      Checkbox(
                                        value: isCheckedList[
                                            index], // Estado del checkbox
                                        onChanged: !listaCuotas[index].pagado &&
                                                editableCheck
                                            ? (value) {
                                                setState(() {
                                                  isCheckedList[index] =
                                                      value!; // Actualizar el estado
                                                  editableCheck = false;

                                                  listaCuotas[index].pagado =
                                                      value;

                                                  Pago newPago = Pago(
                                                      fecha: listaCuotas[index]
                                                          .fecha,
                                                      monto: listaCuotas[index]
                                                          .montoCuota,
                                                      tipo: "CON",
                                                      formaPagos: [
                                                        FormaPago(
                                                            tipo: "CON",
                                                            monto: listaCuotas[
                                                                    index]
                                                                .montoCuota)
                                                      ]);

                                                  guardarPago(
                                                      newPago,
                                                      listaCuotas[index]
                                                          .idCuota);
                                                });
                                              }
                                            : null,
                                        activeColor: AppThemeColors.pago,
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }),
                          )))
                ],
              ),
              /* Container(
                    width: 250,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Saldo",
                          style: AppTextStyles.subtitleDark,
                        ),
                        Text(
                          "$total Bs",
                          style: AppTextStyles.subtitleDark,
                        )
                      ],
                    )),*/
              estado == true
                  ? Container()
                  : Container(
                      width: 250,
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(50, 230, 57, 71),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(
                        "Falta ${faltante} Bs.",
                        style: TextStyle(color: AppThemeColors.error),
                      ),
                    ),
              Container(
                  width: 350,
                  margin: EdgeInsets.only(bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BotonSeccion(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: AppThemeColors.error,
                        text: "Cancelar",
                      ),
                      editable
                          ? BotonSeccion(
                              onPressed: () {
                                LoadingDialog.showLoadingDialog(
                                    context, "Agendando");
                                double precio = widget.customer.price;
                                double total = 0;

                                int index = 0;
                                for (var controlador in controllers) {
                                  listaCuotas[index].montoCuota =
                                      double.tryParse(controlador.text) ?? 0;

                                  total = total +
                                      (double.tryParse(
                                              controlador.value.text) ??
                                          0);
                                  index++;
                                }

                                if (precio == total) {
                                  print("Servicio");
                                  setState(() {
                                    estado = true;
                                  });

                                  if (editableCheck == false) {
                                    print("enviar");
                                  } else {
                                    print("no enviar");
                                  }
                                  LoadingDialog.hideLoadingDialog(context);

                                  // CustomerServiceRequest citaModi = widget.customer;
                                  //citaModi.cuotas = listaCuotas;
                                  //print(citaModi.toJson().toString());

                                  // guardarCita(citaModi);
                                } else {
                                  LoadingDialog.hideLoadingDialog(context);
                                  print("Falta $precio $total");
                                  setState(() {
                                    estado = false;
                                    faltante = precio - total;
                                  });
                                }
                              },
                              color: AppThemeColors.pago,
                              text: "Pagar",
                            )
                          : Container(),
                    ],
                  )),
            ]),
      ),
    );
  }

  guardarPago(Pago nuevoPago, int idCuota) async {
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
        Uri.parse(GlobalVariables.url12 + "/works/fee-payment/$idCuota"),
        headers: headers,
        body: json.encode(nuevoPago.toJson()),
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        try {
          /* String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);*/
          // Extrae el objeto "tecnico"
          print("Guardado ");
          Navigator.pop(context);
          LoadingDialog.hideLoadingDialog(context);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage2()));

          Alerta(context, "Se hizo el Pago",
              "Se realizo el pago de ${nuevoPago.monto}.");

          //return usuario;
        } catch (e) {
          LoadingDialog.hideLoadingDialog(context);
          Alerta(context, "Error",
              "Error al intentar pagar, intentelo mas tarde.");

          print(" Error guardar " + "$e");
        }
      } else if (response.statusCode == 500) {
        print("Error guardar " + response.body);
        LoadingDialog.hideLoadingDialog(context);
        Alerta(context, "Error", "Error al  pagar, intentelo mas tarde.");
      } else {
        //Alerta(context, "Error ", "Usuario no registrado");
        print("Guardar error No entro ${response.statusCode} ${response.body}");
        LoadingDialog.hideLoadingDialog(context);
        Alerta(context, "Error", "Error al  pagar, intentelo mas tarde.");

        //loginSqlite(login.usuario, login.contrasena, context);
      }
    } catch (e) {
      print("Guadrdar conectado");
      LoadingDialog.hideLoadingDialog(context);
      Alerta(context, "Error",
          "Error al  conectarse al servidor, intentelo mas tarde.");

      //loginSqlite(login.usuario, login.contrasena, context);
    }

    // Filtra los clientes que coinciden con la consulta
  }

  getCuotas(int idCuotas) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + GlobalVariables.instance.mainUsuario.token
    };
    HttpClient client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    IOClient ioClient = IOClient(client);

    try {
      final response = await ioClient.get(
        Uri.parse(GlobalVariables.url12 + "/works/$idCuotas/cuotas"),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          String body = utf8.decode(response.bodyBytes);
          final jsonData = jsonDecode(body);
          // Extrae el objeto "tecnico"
          print("Servidor Cuotas " + jsonData.toString());

          if (jsonData is List) {
            setState(() {
              listaCuotas.clear();
              listaCuotas.addAll(
                  (jsonData as List).map((item) => Cuota.fromJson(item)));

              asignarDatos(listaCuotas);
            });
          } else {
            throw Exception("El campo 'content' no es una lista");
          }

          //return usuario;
        } catch (e) {
          print(" Lista Cuotas No Registrado " + "$e");
        }
      } else if (response.statusCode == 500) {
        print(response.body);
      } else {
        //Alerta(context, "Error ", "Usuario no registrado");
        print(
            "Lista Cuotas error No entro ${response.statusCode} ${response.body}");

        //loginSqlite(login.usuario, login.contrasena, context);
      }
    } catch (e) {
      print("Lista Cuotas no conectado");

      //loginSqlite(login.usuario, login.contrasena, context);
    }
  }

  asignarDatos(List<Cuota> listaAsignar) async {
    print(
      listaAsignar.map((cuota) => cuota.toJson()).toList(),
    );
    if (listaAsignar.length == widget.customer.sessions) {
      setState(() {
        controllers = List.generate(
          listaAsignar.length,
          (index) => TextEditingController(
              text: listaAsignar[index].montoCuota.toString()),
        );
        isCheckedList = List.generate(
            listaAsignar.length, (index) => listaAsignar[index].pagado);
      });
    }
  }
}
