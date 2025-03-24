import 'dart:convert';
import 'dart:io';

import 'package:agendometro/Models/DtoSchedules.dart';
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

void CronogramaPagar(
  BuildContext context,
  String total,
  CustomerServiceRequest customer,
) {
  showDialog(
    context: context,
    barrierDismissible: true, // Evita que se cierre al tocar fuera
    builder: (BuildContext context) {
      return CronogramaDialog(
        customer: customer,
        total: total,
      );
    },
  );
}

class CronogramaDialog extends StatefulWidget {
  final CustomerServiceRequest customer;
  final String total;

  CronogramaDialog({required this.customer, required this.total});

  @override
  _CronogramaDialogState createState() => _CronogramaDialogState();
}

class _CronogramaDialogState extends State<CronogramaDialog> {
  late List<Cuota> listaCuotas = [];
  late double costoTotal;
  final _formKeyPago = GlobalKey<FormState>();
  late List<TextEditingController> controllers; // Lista de controladores

  @override
  void initState() {
    super.initState();

    costoTotal = widget.customer.price.toDouble();

    listaCuotas = List.generate(
      widget.customer.sessions,
      (index) {
        // Verifica si dtoSchedules[index] existe
        final schedule = widget.customer.dtoSchedules.length > index
            ? widget.customer.dtoSchedules[index]
            : null;

        // Obtén la fecha o usa un valor predeterminado si es nulo
        final fecha = schedule?.scheduleStartTime ?? "";

        // Si es la primera cuota, usa el monto del pago; de lo contrario, usa 0
        double montoCuota = index == 0 && widget.customer.pagos.isNotEmpty
            ? widget.customer.pagos[0].monto
            : 0;

        // Si es la primera cuota, márcala como pagada; de lo contrario, no
        final pagado = index == 0;

        return Cuota(
            fecha: fecha, montoCuota: montoCuota, pagado: pagado, idCuota: 0);
      },
    );
    controllers = List.generate(
      widget.customer.sessions,
      (index) => index == 0
          ? TextEditingController(
              text: widget.customer.pagos[0].monto.toString())
          : TextEditingController(text: ""),
    );
  }

  bool estado = true;
  double faltante = 0;

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
                                  "${widget.total} Bs",
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
                            children: List.generate(widget.customer.sessions,
                                (index) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Sesion ${index + 1}"),
                                  index == 0
                                      ? textInput2(
                                          controller: controllers[index],
                                          enabled: false,
                                          labelText: "Pagado",
                                          icon: Icons.attach_money_outlined,
                                          horizontal: 100,
                                          isNumberOnly: true,
                                        )
                                      : textInput2(
                                          controller: controllers[index],
                                          labelText: "Monto a pagar",
                                          icon: Icons.attach_money_outlined,
                                          horizontal: 100,
                                          isNumberOnly: true,
                                        )
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
                      BotonSeccion(
                        onPressed: () {
                          LoadingDialog.showLoadingDialog(context, "Agendando");
                          double precio = widget.customer.price;
                          double total = 0;

                          int index = 0;
                          for (var controlador in controllers) {
                            listaCuotas[index].montoCuota =
                                double.tryParse(controlador.text) ?? 0;

                            total = total +
                                (double.tryParse(controlador.value.text) ?? 0);
                            index++;
                          }

                          if (precio == total) {
                            print("Servicio");
                            setState(() {
                              estado = true;
                            });
                            CustomerServiceRequest citaModi = widget.customer;
                            citaModi.cuotas = listaCuotas;
                            print(citaModi.toJson().toString());

                            guardarCita(citaModi);
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
                        text: "Continuar",
                      ),
                    ],
                  )),
            ]),
      ),
    );
  }

  guardarCita(CustomerServiceRequest nuevaCita) async {
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
        Uri.parse(GlobalVariables.url12 + "/works/notification"),
        headers: headers,
        body: json.encode(nuevaCita.toJson()),
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
          Alerta(context, "Se Registro", "Se registro correctamente la cita.");

          //return usuario;
        } catch (e) {
          LoadingDialog.hideLoadingDialog(context);
          Alerta(context, "Error",
              "Error al intentar agendar, intentelo mas tarde.");

          print(" Error guardar " + "$e");
        }
      } else if (response.statusCode == 500) {
        print("Error guardar " + response.body);
        LoadingDialog.hideLoadingDialog(context);
        Alerta(context, "Error", "Error al  agendar, intentelo mas tarde.");
      } else {
        //Alerta(context, "Error ", "Usuario no registrado");
        print("Guardar error No entro ${response.statusCode} ${response.body}");
        LoadingDialog.hideLoadingDialog(context);
        Alerta(context, "Error", "Error al  agendar, intentelo mas tarde.");

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
}
